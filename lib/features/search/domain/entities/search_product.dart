class SearchProduct {
  final String name;
  final String description;
  final String price;
  final SearchProductType type;
  final bool accent;

  const SearchProduct({
    required this.name,
    required this.description,
    required this.price,
    required this.type,
    this.accent = false,
  });
}

enum SearchProductType { rebar, coil }
