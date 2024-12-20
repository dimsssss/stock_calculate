import 'dart:convert';

class InputModel {
  final String id;
  int count;
  int price;
  int amount;

  InputModel({
    required this.id,
    this.count = 0,
    this.price = 0,
    this.amount = 0,
  });

  InputModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        count = json['count'],
        price = json['price'],
        amount = json['amount'];

  Map<String, dynamic> toJson() =>
      {'id': id, 'count': count, 'price': price, 'amount': amount};

  String toStringJson() {
    return jsonEncode(toJson());
  }

  void changeCount(int newCount) {
    count = newCount;
  }

  void changePrice(int newPrice) {
    price = newPrice;
  }

  void changeAmount() {
    amount = price * count;
  }

  void setAmount(int newAmount) {
    amount = newAmount;
  }

  void floorCountForAmount() {
    count = (amount / price).floor();
    amount = count * price;
  }
}
