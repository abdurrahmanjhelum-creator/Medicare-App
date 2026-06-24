// Medicine ka data model — pehle pharmacy_screen.dart ke andar list thi
class Medicine {
  final String title;
  final String category;
  final String price;
  final bool inStock;

  Medicine({
    required this.title,
    required this.category,
    required this.price,
    this.inStock = true,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      title: json['name'] ?? json['title'] ?? '',
      category: json['category'] ?? '',
      price: '\$${json['price']?.toString() ?? '0.00'}',
      inStock: json['inStock'] ?? true,
    );
  }
}
