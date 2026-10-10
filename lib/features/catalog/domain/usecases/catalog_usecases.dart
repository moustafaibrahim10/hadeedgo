import '../entities/catalog_entities.dart';
import '../repositories/catalog_repository.dart';

class GetCategories {
  final CatalogRepository repository;
  const GetCategories(this.repository);
  Future<List<Category>> call() => repository.getCategories();
}

class GetSuppliers {
  final CatalogRepository repository;
  const GetSuppliers(this.repository);
  Future<List<Supplier>> call() => repository.getSuppliers();
}

class GetSupplierDetails {
  final CatalogRepository repository;
  const GetSupplierDetails(this.repository);
  Future<Supplier> call(String id) => repository.getSupplierDetails(id);
}

class GetFeaturedOffers {
  final CatalogRepository repository;
  const GetFeaturedOffers(this.repository);
  Future<List<Offer>> call({int? limit}) =>
      repository.getFeaturedOffers(limit: limit);
}

class GetProducts {
  final CatalogRepository repository;
  const GetProducts(this.repository);
  Future<List<Product>> call({String? categoryId, String? supplierId}) =>
      repository.getProducts(categoryId: categoryId, supplierId: supplierId);
}

class GetProductDetails {
  final CatalogRepository repository;
  const GetProductDetails(this.repository);
  Future<ProductDetails> call(String id) => repository.getProductDetails(id);
}
