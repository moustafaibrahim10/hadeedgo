import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failure_exception.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/catalog_entities.dart';
import '../../domain/usecases/catalog_usecases.dart';

enum CatalogStatus { initial, loading, success, empty, failure }

class CatalogListState<T> {
  final CatalogStatus status;
  final List<T> items;
  final String? errorMessage;

  const CatalogListState({
    this.status = CatalogStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  CatalogListState<T> copyWith({
    CatalogStatus? status,
    List<T>? items,
    String? errorMessage,
  }) => CatalogListState(
    status: status ?? this.status,
    items: items ?? this.items,
    errorMessage: errorMessage,
  );
}

class CategoriesCubit extends Cubit<CatalogListState<Category>> {
  final GetCategories _getCategories;
  CategoriesCubit(this._getCategories) : super(const CatalogListState());

  Future<void> load() async {
    emit(state.copyWith(status: CatalogStatus.loading, errorMessage: null));
    try {
      final items = await _getCategories();
      emit(
        state.copyWith(
          status: items.isEmpty ? CatalogStatus.empty : CatalogStatus.success,
          items: items,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: CatalogStatus.failure,
          errorMessage: _message(error),
        ),
      );
    }
  }
}

class SuppliersCubit extends Cubit<CatalogListState<Supplier>> {
  final GetSuppliers _getSuppliers;
  SuppliersCubit(this._getSuppliers) : super(const CatalogListState());

  Future<void> load() async {
    emit(state.copyWith(status: CatalogStatus.loading, errorMessage: null));
    try {
      final items = await _getSuppliers();
      emit(
        state.copyWith(
          status: items.isEmpty ? CatalogStatus.empty : CatalogStatus.success,
          items: items,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: CatalogStatus.failure,
          errorMessage: _message(error),
        ),
      );
    }
  }
}

class FeaturedOffersCubit extends Cubit<CatalogListState<Offer>> {
  final GetFeaturedOffers _getOffers;
  FeaturedOffersCubit(this._getOffers) : super(const CatalogListState());

  Future<void> load({int? limit}) async {
    emit(state.copyWith(status: CatalogStatus.loading, errorMessage: null));
    try {
      final items = await _getOffers(limit: limit);
      emit(
        state.copyWith(
          status: items.isEmpty ? CatalogStatus.empty : CatalogStatus.success,
          items: items,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: CatalogStatus.failure,
          errorMessage: _message(error),
        ),
      );
    }
  }
}

class ProductsCubit extends Cubit<CatalogListState<Product>> {
  final GetProducts _getProducts;
  String? categoryId;
  String? supplierId;

  ProductsCubit(this._getProducts) : super(const CatalogListState());

  Future<void> load({String? categoryId, String? supplierId}) async {
    this.categoryId = categoryId;
    this.supplierId = supplierId;
    emit(state.copyWith(status: CatalogStatus.loading, errorMessage: null));
    try {
      final items = await _getProducts(
        categoryId: this.categoryId,
        supplierId: this.supplierId,
      );
      emit(
        state.copyWith(
          status: items.isEmpty ? CatalogStatus.empty : CatalogStatus.success,
          items: items,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: CatalogStatus.failure,
          errorMessage: _message(error),
        ),
      );
    }
  }

  Future<void> changeFilters({String? categoryId, String? supplierId}) =>
      load(categoryId: categoryId, supplierId: supplierId);
}

class CatalogDetailsState<T> {
  final CatalogStatus status;
  final T? item;
  final String? errorMessage;
  const CatalogDetailsState({
    this.status = CatalogStatus.initial,
    this.item,
    this.errorMessage,
  });
}

class SupplierDetailsCubit extends Cubit<CatalogDetailsState<Supplier>> {
  final GetSupplierDetails _getSupplier;
  SupplierDetailsCubit(this._getSupplier) : super(const CatalogDetailsState());

  Future<void> load(String id) async {
    emit(const CatalogDetailsState(status: CatalogStatus.loading));
    try {
      emit(
        CatalogDetailsState(
          status: CatalogStatus.success,
          item: await _getSupplier(id),
        ),
      );
    } catch (error) {
      emit(
        CatalogDetailsState(
          status: CatalogStatus.failure,
          errorMessage: _message(error),
        ),
      );
    }
  }
}

class ProductDetailsCubit extends Cubit<CatalogDetailsState<ProductDetails>> {
  final GetProductDetails _getProduct;
  ProductDetailsCubit(this._getProduct) : super(const CatalogDetailsState());

  Future<void> load(String id) async {
    emit(const CatalogDetailsState(status: CatalogStatus.loading));
    try {
      emit(
        CatalogDetailsState(
          status: CatalogStatus.success,
          item: await _getProduct(id),
        ),
      );
    } catch (error) {
      emit(
        CatalogDetailsState(
          status: CatalogStatus.failure,
          errorMessage: _message(error),
        ),
      );
    }
  }
}

String _message(Object error) => error is FailureException
    ? error.failure.message
    : error is Failure
    ? error.message
    : 'تعذر تحميل البيانات';
