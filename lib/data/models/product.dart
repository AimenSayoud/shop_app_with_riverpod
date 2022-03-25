class Product {
  final String? productID;
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? price;
  bool? favorite = false;

  Product({
    this.productID,
    this.title,
    this.description,
    this.imageUrl,
    this.price,
  });
}
