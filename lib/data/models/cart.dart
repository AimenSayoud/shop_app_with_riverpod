class CartItem {
  final String pid;
  final String cid;
  final String title;
  int quantity;
  final String price;

  CartItem({
    required this.pid,
    required this.cid,
    required this.title,
    required this.quantity,
    required this.price,
  });
}
