// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CartItemsModel {
  final String itemId;
  final int itemCount;
  final String itemName;
  final String itemImage;
  final int itemQuantity;
  final double itemPrice;
  final double totalPricePerItem;
  CartItemsModel({
    this.itemId = "",
    this.itemCount = 0,
    this.itemName = "",
    this.itemImage = "",
    this.itemQuantity = 0,
    this.itemPrice = 0,
    this.totalPricePerItem = 0,
  });

  CartItemsModel copyWith({
    String? itemId,
    int? itemCount,
    String? itemName,
    String? itemImage,
    int? itemQuantity,
    double? itemPrice,
    double? totalPricePerItem,
  }) {
    return CartItemsModel(
      itemId: itemId ?? this.itemId,
      itemCount: itemCount ?? this.itemCount,
      itemName: itemName ?? this.itemName,
      itemImage: itemImage ?? this.itemImage,
      itemQuantity: itemQuantity ?? this.itemQuantity,
      itemPrice: itemPrice ?? this.itemPrice,
      totalPricePerItem: totalPricePerItem ?? this.totalPricePerItem,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'item_id': itemId,
      'item_count': itemCount,
      'item_name': itemName,
      'item_price': itemPrice,
      'item_quantity': itemQuantity,
      'item_image': itemImage,
      'total_price_per_item': totalPricePerItem,
    };
  }

  factory CartItemsModel.fromMap(Map<String, dynamic> map) {
    return CartItemsModel(
      itemId: map['item_id'] as String? ?? "",
      itemCount: map['item_count'] as int? ?? 0,
      itemName: map['item_name'] as String? ?? "",
      itemPrice: map['item_price'] as double? ?? 0,
      itemQuantity: map['item_quantity'] as int? ?? 0,
      itemImage: map['item_image'] as String? ?? "",
      totalPricePerItem: map['total_price_per_item'] as double? ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemsModel.fromJson(String source) =>
      CartItemsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CartItemsModel(itemId: $itemId, itemCount: $itemCount, itemName: $itemName, itemPrice: $itemPrice, itemQuantity: $itemQuantity, itemImage: $itemImage, totalPricePerItem: $totalPricePerItem)';
  }

  @override
  bool operator ==(covariant CartItemsModel other) {
    if (identical(this, other)) return true;

    return other.itemId == itemId &&
        other.itemCount == itemCount &&
        other.itemName == itemName &&
        other.itemPrice == itemPrice &&
        other.itemQuantity == itemQuantity &&
        other.itemImage == itemImage &&
        other.totalPricePerItem == totalPricePerItem;
  }

  @override
  int get hashCode {
    return itemId.hashCode ^
        itemCount.hashCode ^
        itemName.hashCode ^
        itemPrice.hashCode ^
        itemQuantity.hashCode ^
        itemImage.hashCode ^
        totalPricePerItem.hashCode;
  }
}
