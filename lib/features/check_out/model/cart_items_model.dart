// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CartItemsModel {
  final String itemId;
  final int itemCount;
  final String itemName;
  final int itemPrice;
  final int totalPricePerItem;
  CartItemsModel({
    required this.itemId,
    required this.itemCount,
    required this.itemName,
    required this.itemPrice,
    required this.totalPricePerItem,
  });

  CartItemsModel copyWith({
    String? itemId,
    int? itemCount,
    String? itemName,
    int? itemPrice,
    int? totalPricePerItem,
  }) {
    return CartItemsModel(
      itemId: itemId ?? this.itemId,
      itemCount: itemCount ?? this.itemCount,
      itemName: itemName ?? this.itemName,
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
      'total_price_per_item': totalPricePerItem,
    };
  }

  factory CartItemsModel.fromMap(Map<String, dynamic> map) {
    return CartItemsModel(
      itemId: map['item_id'] as String,
      itemCount: map['item_count'] as int,
      itemName: map['item_name'] as String,
      itemPrice: map['item_price'] as int,
      totalPricePerItem: map['total_price_per_item'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemsModel.fromJson(String source) =>
      CartItemsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CartItemsModel(itemId: $itemId, itemCount: $itemCount, itemName: $itemName, itemPrice: $itemPrice, totalPricePerItem: $totalPricePerItem)';
  }

  @override
  bool operator ==(covariant CartItemsModel other) {
    if (identical(this, other)) return true;

    return other.itemId == itemId &&
        other.itemCount == itemCount &&
        other.itemName == itemName &&
        other.itemPrice == itemPrice &&
        other.totalPricePerItem == totalPricePerItem;
  }

  @override
  int get hashCode {
    return itemId.hashCode ^
        itemCount.hashCode ^
        itemName.hashCode ^
        itemPrice.hashCode ^
        totalPricePerItem.hashCode;
  }
}
