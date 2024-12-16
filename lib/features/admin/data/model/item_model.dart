// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ItemModel {
  final String? id;
  final String? name;
  final int? categoryId;
  final String? imageUrl;
  final int? quantity;
  final String? createdAt;
  ItemModel({
    this.id,
    this.name,
    this.categoryId,
    this.imageUrl,
    this.quantity,
    this.createdAt,
  });

  ItemModel copyWith({
    String? id,
    String? name,
    int? categoryId,
    String? imageUrl,
    int? quantity,
    String? createdAt,
  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id ?? '',
      'name': name ?? '',
      'category_id': categoryId ?? 0,
      'image_url': imageUrl ?? '',
      'quantity': quantity ?? 0,
      'updated_at': createdAt ?? ''
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] as String?,
      name: map['name'] as String?,
      categoryId: map['category_id'] as int?,
      imageUrl: map['image_url'] as String?,
      quantity: map['quantity'] as int?,
      createdAt: map['updated_at'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemModel.fromJson(String source) =>
      ItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemModel(id: $id, name: $name, categoryId: $categoryId, imageUrl: $imageUrl, quantity: $quantity, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ItemModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.categoryId == categoryId &&
        other.imageUrl == imageUrl &&
        other.quantity == quantity &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        categoryId.hashCode ^
        imageUrl.hashCode ^
        quantity.hashCode ^
        createdAt.hashCode;
  }
}
