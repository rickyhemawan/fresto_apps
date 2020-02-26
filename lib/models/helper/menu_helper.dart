import '../menu.dart';

class MenuHelper extends Menu {
  int quantity = 0;
  double get subTotal => this.price * quantity;

  MenuHelper.fromMenu(Menu menu) {
    this.name = menu.name;
    this.quantity = 0;
    this.price = menu.price;
    this.imageUrl = menu.imageUrl;
    this.description = menu.description;
    this.available = menu.available;
  }

  MenuHelper.fromJson(Map<String, dynamic> json) {
    this.imageUrl = json["imageUrl"];
    this.price = json["price"].toDouble();
    this.description = json["description"];
    this.name = json["name"];
    this.available = json["available"];
    this.quantity = json["quantity"];
  }

  Map<String, dynamic> toJson() => {
        "imageUrl": this.imageUrl,
        "price": this.price,
        "description": this.description,
        "name": this.name,
        "available": this.available,
        "quantity": this.quantity,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other && other is MenuHelper && runtimeType == other.runtimeType;

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() {
    return super.toString() + 'MenuHelper{quantity: $quantity}';
  }
}
