import '../entities/catalog_entities.dart';

abstract interface class CatalogRepository {
  Future<List<Category>> getCategories();
  Future<List<Supplier>> getSuppliers();
  Future<Supplier> getSupplierDetails(String id);
  Future<List<Offer>> getFeaturedOffers({int? limit});
  Future<List<Product>> getProducts({String? categoryId, String? supplierId});
  Future<ProductDetails> getProductDetails(String id);
}
