import 'package:flutter_test/flutter_test.dart';
import 'package:hadeedgo/features/checkout/presentation/cubits/checkout_cubit.dart';
import 'package:hadeedgo/features/catalog/domain/entities/catalog_entities.dart';
import 'package:hadeedgo/features/orders/domain/entities/order.dart';
import 'package:hadeedgo/features/orders/domain/repositories/orders_repository.dart';
import 'package:hadeedgo/features/orders/domain/usecases/orders_usecases.dart';
import 'package:hadeedgo/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:hadeedgo/features/catalog/domain/usecases/catalog_usecases.dart';

/// Records the arguments the checkout flow passes to the order repository so
/// tests can assert the exact `POST /api/v1/orders` payload per branch.
class _RecordingOrdersRepository implements OrdersRepository {
  CreateOrderArgs? lastArgs;
  int createCallCount = 0;
  Object? errorToThrow;
  Order? orderToReturn;

  @override
  Future<Order> createOrder({
    required String deliveryMethod,
    String? deliveryAddressDetails,
    String? deliveryAddressLabel,
    String? pickupSupplierId,
    DateTime? preferredDeliveryDate,
  }) async {
    createCallCount++;
    lastArgs = CreateOrderArgs(
      deliveryMethod: deliveryMethod,
      deliveryAddressDetails: deliveryAddressDetails,
      deliveryAddressLabel: deliveryAddressLabel,
      pickupSupplierId: pickupSupplierId,
      preferredDeliveryDate: preferredDeliveryDate,
    );
    if (errorToThrow != null) throw errorToThrow!;
    return orderToReturn ?? _sampleOrder(deliveryMethod: deliveryMethod);
  }

  @override
  Future<OrdersPage> getOrders({
    String filter = 'All',
    int page = 1,
    int pageSize = 20,
  }) async => throw UnimplementedError();
  @override
  Future<ActiveOrder> getActiveOrder() async => throw UnimplementedError();
  @override
  Future<Order> getOrder(String id) async => throw UnimplementedError();
  @override
  Future<OrderTracking> getTracking(String id) async =>
      throw UnimplementedError();
}

class CreateOrderArgs {
  final String deliveryMethod;
  final String? deliveryAddressDetails;
  final String? deliveryAddressLabel;
  final String? pickupSupplierId;
  final DateTime? preferredDeliveryDate;
  CreateOrderArgs({
    required this.deliveryMethod,
    this.deliveryAddressDetails,
    this.deliveryAddressLabel,
    this.pickupSupplierId,
    this.preferredDeliveryDate,
  });
}

class _FakeCatalogRepository implements CatalogRepository {
  List<Supplier> suppliers = const [];
  Object? errorToThrow;

  @override
  Future<List<Supplier>> getSuppliers() async {
    if (errorToThrow != null) throw errorToThrow!;
    return suppliers;
  }

  @override
  Future<List<Category>> getCategories() async => throw UnimplementedError();
  @override
  Future<Supplier> getSupplierDetails(String id) async =>
      throw UnimplementedError();
  @override
  Future<List<Offer>> getFeaturedOffers({int? limit}) async =>
      throw UnimplementedError();
  @override
  Future<List<Product>> getProducts({
    String? categoryId,
    String? supplierId,
  }) async => throw UnimplementedError();
  @override
  Future<ProductDetails> getProductDetails(String id) async =>
      throw UnimplementedError();
}

Order _sampleOrder({required String deliveryMethod}) => Order.fromJson({
  'id': 'order-uuid-1',
  'orderNumber': null,
  'status': 'Pending',
  'deliveryMethod': deliveryMethod,
  'subTotal': 1000,
  'deliveryFee': 50,
  'taxAmount': 154,
  'totalAmount': 1204,
  'currency': 'EGP',
  'createdAt': '2026-10-13T01:39:14.769Z',
  'items': [
    {
      'id': 'item-1',
      'productId': 'product-1',
      'titleAr': 'حديد تسليح',
      'quantity': 2,
      'unitPrice': 500,
      'lineTotal': 1000,
      'unit': 'Ton',
      'currency': 'EGP',
    },
  ],
  'statusEvents': [
    {'status': 'Pending', 'title': 'تم استلام الطلب', 'isCurrent': true},
  ],
});

Supplier _supplier(String id, String nameAr) =>
    Supplier(id: id, nameAr: nameAr, isVerified: true);

void main() {
  late _RecordingOrdersRepository ordersRepo;
  late _FakeCatalogRepository catalogRepo;
  late CheckoutCubit cubit;

  setUp(() {
    ordersRepo = _RecordingOrdersRepository();
    catalogRepo = _FakeCatalogRepository();
    cubit = CheckoutCubit(CreateOrder(ordersRepo), GetSuppliers(catalogRepo));
  });

  tearDown(() => cubit.close());

  group('FulfillmentMethod enum → API contract', () {
    test('maps to the exact backend enum strings', () {
      expect(FulfillmentMethod.delivery.apiValue, 'Delivery');
      expect(FulfillmentMethod.pickup.apiValue, 'Pickup');
    });
  });

  group('A. Delivery branch', () {
    test('sends delivery fields and pickupSupplierId == null', () async {
      cubit.setAddressLabel('موقع البناء');
      cubit.setAddressDetails('العاصمة الإدارية - القطعة 42');
      cubit.setPreferredDeliveryDate(DateTime(2026, 10, 20));

      await cubit.submit();

      final args = ordersRepo.lastArgs!;
      expect(args.deliveryMethod, 'Delivery');
      expect(args.deliveryAddressLabel, 'موقع البناء');
      expect(args.deliveryAddressDetails, 'العاصمة الإدارية - القطعة 42');
      expect(args.pickupSupplierId, isNull);
      expect(args.preferredDeliveryDate, DateTime(2026, 10, 20));
      expect(cubit.state.createdOrder, isNotNull);
    });

    test('omits optional date when not provided but keeps required label',
        () async {
      cubit.setAddressLabel('الشركة');
      cubit.setAddressDetails('عنوان فقط');
      await cubit.submit();

      final args = ordersRepo.lastArgs!;
      expect(args.deliveryMethod, 'Delivery');
      expect(args.deliveryAddressDetails, 'عنوان فقط');
      expect(args.deliveryAddressLabel, 'الشركة');
      expect(args.preferredDeliveryDate, isNull);
      expect(args.pickupSupplierId, isNull);
    });
  });

  group('B. Pickup branch', () {
    test(
      'loads real suppliers and sends real UUID with null address fields',
      () async {
        catalogRepo.suppliers = [
          _supplier('sup-uuid-1111', 'حديد عز'),
          _supplier('sup-uuid-2222', 'المصرية للحديد'),
        ];

        cubit.selectMethod(FulfillmentMethod.pickup);
        await Future.delayed(Duration.zero); // let loadSuppliers settle

        expect(cubit.state.suppliers, hasLength(2));
        expect(cubit.state.suppliersStatus, SuppliersLoadStatus.success);

        cubit.selectSupplier(cubit.state.suppliers.first);
        await cubit.submit();

        final args = ordersRepo.lastArgs!;
        expect(args.deliveryMethod, 'Pickup');
        // Real UUID, never the display name.
        expect(args.pickupSupplierId, 'sup-uuid-1111');
        expect(args.pickupSupplierId, isNot('حديد عز'));
        // Address fields must be null for Pickup.
        expect(args.deliveryAddressLabel, isNull);
        expect(args.deliveryAddressDetails, isNull);
        expect(args.preferredDeliveryDate, isNull);
      },
    );

    test('supplier load failure surfaces an error message', () async {
      catalogRepo.errorToThrow = Exception('network down');
      cubit.selectMethod(FulfillmentMethod.pickup);
      await Future.delayed(Duration.zero);

      expect(cubit.state.suppliersStatus, SuppliersLoadStatus.failure);
      expect(cubit.state.errorMessage, isNotNull);
    });
  });

  group('C. Validation', () {
    test('Pickup without a supplier does not call the API', () async {
      catalogRepo.suppliers = [_supplier('sup-uuid-1111', 'حديد عز')];
      cubit.selectMethod(FulfillmentMethod.pickup);
      await Future.delayed(Duration.zero);

      await cubit.submit();

      expect(ordersRepo.createCallCount, 0);
      expect(cubit.state.supplierError, isNotNull);
    });

    test('Delivery with empty address details does not call the API', () async {
      cubit.setAddressLabel('البيت');
      cubit.setAddressDetails('   ');
      await cubit.submit();

      expect(ordersRepo.createCallCount, 0);
      expect(cubit.state.addressDetailsError, isNotNull);
    });

    test('Delivery without an address label does not call the API', () async {
      cubit.setAddressDetails('عنوان صحيح بدون تصنيف');
      await cubit.submit();

      expect(ordersRepo.createCallCount, 0);
      expect(cubit.state.addressLabelError, isNotNull);
      expect(cubit.state.createdOrder, isNull);
    });

    test('selecting a label clears the label error', () async {
      cubit.setAddressDetails('عنوان صحيح');
      await cubit.submit();
      expect(cubit.state.addressLabelError, isNotNull);

      cubit.setAddressLabel('موقع البناء');
      expect(cubit.state.addressLabelError, isNull);
    });
  });

  group('D. API errors', () {
    test('server error is mapped to a message, not a raw exception', () async {
      ordersRepo.errorToThrow = Exception('boom');
      cubit.setAddressLabel('البيت');
      cubit.setAddressDetails('عنوان صحيح');
      await cubit.submit();

      expect(cubit.state.createdOrder, isNull);
      expect(cubit.state.errorMessage, isNotNull);
      expect(cubit.state.isSubmitting, isFalse);
    });
  });

  group('E. Duplicate submit guard', () {
    test('rapid concurrent taps create only one order', () async {
      ordersRepo.orderToReturn = _sampleOrder(deliveryMethod: 'Delivery');
      cubit.setAddressLabel('البيت');
      cubit.setAddressDetails('عنوان صحيح');

      final first = cubit.submit();
      final second = cubit.submit(); // ignored while in flight
      await Future.wait([first, second]);

      expect(ordersRepo.createCallCount, 1);
    });
  });

  group('F. Success data', () {
    test('created order is exposed on state for the success screen', () async {
      ordersRepo.orderToReturn = _sampleOrder(deliveryMethod: 'Delivery');
      cubit.setAddressLabel('البيت');
      cubit.setAddressDetails('عنوان صحيح');
      await cubit.submit();

      final order = cubit.state.createdOrder!;
      expect(order.id, 'order-uuid-1');
      expect(order.orderItems, hasLength(1));
      expect(order.orderItems.first.quantity, 2);
      expect(order.totalAmount, 1204);
      expect(order.currency, 'EGP');
      expect(order.statusEvents.first.isCurrent, isTrue);
    });
  });
}
