class Menu {
  String imageUrl;
  double price;
  String description;
  String name;
  bool available;

  Menu(
      {this.imageUrl, this.price, this.description, this.name, this.available});

  Menu.fromJson(Map<String, dynamic> json) {
    this.imageUrl = json["imageUrl"];
    this.price = json["price"].toDouble();
    this.description = json["description"];
    this.name = json["name"];
    this.available = json["available"];
  }

  Map<String, dynamic> toJson() => {
        "imageUrl": this.imageUrl,
        "price": this.price,
        "description": this.description,
        "name": this.name,
        "available": this.available,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Menu &&
          runtimeType == other.runtimeType &&
          imageUrl == other.imageUrl &&
          price == other.price &&
          description == other.description &&
          name == other.name &&
          available == other.available;

  @override
  int get hashCode =>
      imageUrl.hashCode ^
      price.hashCode ^
      description.hashCode ^
      name.hashCode ^
      available.hashCode;
}
