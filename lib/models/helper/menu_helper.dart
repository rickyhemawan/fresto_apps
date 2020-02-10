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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other && other is MenuHelper && runtimeType == other.runtimeType;

  @override
  int get hashCode => super.hashCode;
}
