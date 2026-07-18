class PaymentPageAdapter<T> {
  String itemId;
  String collection;
  int amount;
  T? extra;
  PaymentPageAdapter({
    required this.itemId,
    required this.collection,
    required this.amount,
    this.extra,
  });
}
