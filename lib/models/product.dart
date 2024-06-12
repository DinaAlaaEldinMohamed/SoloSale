class Product {
  String? productName, productDescription, owner;
  int? productId, categoryId, stock;
  double? price;
  bool? isAvailable;
  String? image;
  String? categoryName;
  Product();

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    productDescription = json['productDescription'];
    owner = json['owner'];
    categoryId = json['categoryId'];
    stock = json['stock'];
    price = json['price'];
    isAvailable = json['isAvailable'] == 1 ? true : false;
    categoryName = json['categoryName'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productDescription': productDescription,
      'owner': owner,
      'categoryId': categoryId,
      'stock': stock,
      'price': price,
      'isAvailable': isAvailable,
      'image': image,
    };
  }

  Map<String, dynamic> utoJson() {
    return {
      // 'productId': productId,
      'productName': productName,
      'productDescription': productDescription,
      'owner': owner,
      'categoryId': categoryId,
      'stock': stock,
      'price': price,
      'isAvailable': isAvailable,
      'image': image,
    };
  }
}
