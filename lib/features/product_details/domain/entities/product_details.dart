enum ProductDetailsType { beam, rebar, coil }

class ProductDetails {
  final String name;
  final String supplier;
  final String description;
  final String price;
  final ProductDetailsType type;
  final int pricePerTon;
  final String imageAsset;

  const ProductDetails({
    required this.name,
    required this.supplier,
    required this.description,
    required this.price,
    required this.type,
    this.pricePerTon = 48000,
    this.imageAsset = 'assets/photos/png/onboarding3.png',
  });
}
