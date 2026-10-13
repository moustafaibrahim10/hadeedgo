import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failure_exception.dart';
import '../../../../core/error/failures.dart';
import '../../../catalog/domain/entities/catalog_entities.dart';
import '../../../catalog/domain/usecases/catalog_usecases.dart';
import '../../../orders/domain/entities/order.dart';
import '../../../orders/domain/usecases/orders_usecases.dart';

/// The two fulfillment methods supported by the backend
/// `POST /api/v1/orders` contract. The enum value maps 1:1 to the
/// `deliveryMethod` string expected by the API ("Delivery" | "Pickup").
enum FulfillmentMethod { delivery, pickup }

extension FulfillmentMethodApi on FulfillmentMethod {
  /// Exact enum string the backend expects. Never lowercase / rename.
  String get apiValue =>
      this == FulfillmentMethod.delivery ? 'Delivery' : 'Pickup';
}

enum SuppliersLoadStatus { initial, loading, success, failure }

/// Immutable state for the checkout flow.
///
/// Holds the selected fulfillment method, the branch-specific inputs and the
/// real catalog suppliers used for the Pickup branch. Business rules (which
/// branch is active, what is required) live here and in [CheckoutCubit], never
/// in the widgets.
class CheckoutState {
  final FulfillmentMethod method;

  // Delivery branch inputs.
  final String addressLabel;
  final String addressDetails;
  final DateTime? preferredDeliveryDate;

  // Pickup branch inputs.
  final Supplier? selectedSupplier;
  final List<Supplier> suppliers;
  final SuppliersLoadStatus suppliersStatus;

  // Submission + feedback.
  final bool isSubmitting;
  final Order? createdOrder;
  final String? addressLabelError;
  final String? addressDetailsError;
  final String? supplierError;
  final String? errorMessage;

  const CheckoutState({
    this.method = FulfillmentMethod.delivery,
    this.addressLabel = '',
    this.addressDetails = '',
    this.preferredDeliveryDate,
    this.selectedSupplier,
    this.suppliers = const [],
    this.suppliersStatus = SuppliersLoadStatus.initial,
    this.isSubmitting = false,
    this.createdOrder,
    this.addressLabelError,
    this.addressDetailsError,
    this.supplierError,
    this.errorMessage,
  });

  bool get isDelivery => method == FulfillmentMethod.delivery;
  bool get isPickup => method == FulfillmentMethod.pickup;

  CheckoutState copyWith({
    FulfillmentMethod? method,
    String? addressLabel,
    String? addressDetails,
    DateTime? preferredDeliveryDate,
    bool clearPreferredDeliveryDate = false,
    Supplier? selectedSupplier,
    bool clearSelectedSupplier = false,
    List<Supplier>? suppliers,
    SuppliersLoadStatus? suppliersStatus,
    bool? isSubmitting,
    Order? createdOrder,
    String? addressLabelError,
    bool clearAddressLabelError = false,
    String? addressDetailsError,
    bool clearAddressDetailsError = false,
    String? supplierError,
    bool clearSupplierError = false,
    String? errorMessage,
    bool clearError = false,
  }) => CheckoutState(
    method: method ?? this.method,
    addressLabel: addressLabel ?? this.addressLabel,
    addressDetails: addressDetails ?? this.addressDetails,
    preferredDeliveryDate: clearPreferredDeliveryDate
        ? null
        : (preferredDeliveryDate ?? this.preferredDeliveryDate),
    selectedSupplier: clearSelectedSupplier
        ? null
        : (selectedSupplier ?? this.selectedSupplier),
    suppliers: suppliers ?? this.suppliers,
    suppliersStatus: suppliersStatus ?? this.suppliersStatus,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    createdOrder: createdOrder ?? this.createdOrder,
    addressLabelError: clearAddressLabelError
        ? null
        : (addressLabelError ?? this.addressLabelError),
    addressDetailsError: clearAddressDetailsError
        ? null
        : (addressDetailsError ?? this.addressDetailsError),
    supplierError: clearSupplierError
        ? null
        : (supplierError ?? this.supplierError),
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
  );
}

/// Drives the checkout flow: fulfillment selection, branch inputs, validation
/// and order creation through the existing [CreateOrder] use case. Reuses the
/// existing catalog [GetSuppliers] use case for the Pickup branch — no mock
/// suppliers, no invented endpoints.
class CheckoutCubit extends Cubit<CheckoutState> {
  final CreateOrder _createOrder;
  final GetSuppliers _getSuppliers;

  CheckoutCubit(this._createOrder, this._getSuppliers)
    : super(const CheckoutState());

  /// Selects the fulfillment method. Switching to Pickup lazily loads the real
  /// catalog suppliers. Clears branch-specific errors on switch.
  void selectMethod(FulfillmentMethod method) {
    if (state.method == method) return;
    emit(
      state.copyWith(
        method: method,
        clearAddressDetailsError: true,
        clearSupplierError: true,
        clearError: true,
      ),
    );
    if (method == FulfillmentMethod.pickup) loadSuppliers();
  }

  void setAddressLabel(String value) => emit(
    state.copyWith(addressLabel: value, clearAddressLabelError: true, clearError: true),
  );

  void setAddressDetails(String value) => emit(
    state.copyWith(addressDetails: value, clearAddressDetailsError: true),
  );

  void setPreferredDeliveryDate(DateTime? date) =>
      emit(state.copyWith(preferredDeliveryDate: date));

  void clearPreferredDeliveryDate() =>
      emit(state.copyWith(clearPreferredDeliveryDate: true));

  /// Loads real suppliers from `GET /api/v1/catalog/suppliers`. Idempotent —
  /// won't refetch once loaded or while loading.
  Future<void> loadSuppliers() async {
    if (state.suppliersStatus == SuppliersLoadStatus.loading ||
        state.suppliersStatus == SuppliersLoadStatus.success) {
      return;
    }
    emit(
      state.copyWith(
        suppliersStatus: SuppliersLoadStatus.loading,
        clearError: true,
      ),
    );
    try {
      final suppliers = await _getSuppliers();
      emit(
        state.copyWith(
          suppliersStatus: SuppliersLoadStatus.success,
          suppliers: suppliers,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          suppliersStatus: SuppliersLoadStatus.failure,
          errorMessage: _message(error),
        ),
      );
    }
  }

  void selectSupplier(Supplier? supplier) => emit(
    state.copyWith(selectedSupplier: supplier, clearSupplierError: true),
  );

  /// Validates the active branch. Returns true when the branch is valid.
  bool _validate() {
    if (state.isDelivery) {
      final labelInvalid = state.addressLabel.trim().isEmpty;
      final detailsInvalid = state.addressDetails.trim().isEmpty;
      emit(
        state.copyWith(
          addressLabelError: labelInvalid ? 'يرجى اختيار تصنيف العنوان' : null,
          clearAddressLabelError: !labelInvalid,
          addressDetailsError: detailsInvalid
              ? 'يرجى إدخال عنوان التوصيل بالتفصيل'
              : null,
          clearAddressDetailsError: !detailsInvalid,
        ),
      );
      return !labelInvalid && !detailsInvalid;
    }
    final invalid =
        state.selectedSupplier == null || state.selectedSupplier!.id.isEmpty;
    emit(
      state.copyWith(
        supplierError: invalid ? 'يرجى اختيار المصنع لاستلام الطلب' : null,
        clearSupplierError: !invalid,
      ),
    );
    return !invalid;
  }

  /// Builds the correct payload for the active branch and creates the order.
  ///
  /// Delivery → sends address fields, `pickupSupplierId` = null.
  /// Pickup   → sends `pickupSupplierId` = real UUID, address fields = null.
  ///
  /// Guards against duplicate submission while a request is in flight.
  Future<void> submit() async {
    if (state.isSubmitting) return;
    if (!_validate()) return;

    emit(state.copyWith(isSubmitting: true, clearError: true));

    final delivery = state.isDelivery;
    try {
      final order = await _createOrder(
        deliveryMethod: state.method.apiValue,
        deliveryAddressDetails: delivery ? state.addressDetails.trim() : null,
        deliveryAddressLabel: delivery && state.addressLabel.trim().isNotEmpty
            ? state.addressLabel.trim()
            : null,
        pickupSupplierId: delivery ? null : state.selectedSupplier!.id,
        preferredDeliveryDate: delivery ? state.preferredDeliveryDate : null,
      );
      emit(state.copyWith(isSubmitting: false, createdOrder: order));
    } catch (error) {
      emit(state.copyWith(isSubmitting: false, errorMessage: _message(error)));
    }
  }
}

String _message(Object error) => error is FailureException
    ? error.failure.message
    : error is Failure
    ? error.message
    : 'تعذر إنشاء الطلب';
