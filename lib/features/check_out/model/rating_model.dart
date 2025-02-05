// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RatingModel {
  final int id;
  final double rate;
  final int userId;
  final String itemId;
  final String comment;
  final DateTime createdAt;

  RatingModel({
    required this.id,
    required this.rate,
    required this.userId,
    required this.itemId,
    required this.comment,
    required this.createdAt,
  });

  RatingModel copyWith({
    int? id,
    double? rate,
    int? userId,
    String? itemId,
    String? comment,
    DateTime? createdAt,
  }) {
    return RatingModel(
      id: id ?? this.id,
      rate: rate ?? this.rate,
      userId: userId ?? this.userId,
      itemId: itemId ?? this.itemId,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'rate': rate,
      'user_id': userId,
      'item_id': itemId,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory RatingModel.fromMap(Map<String, dynamic> map) {
    return RatingModel(
      id: map['id'] as int,
      rate: (map['rate'] as num).toDouble(),
      userId: map['user_id'] as int,
      itemId: map['item_id'] as String,
      comment: map['comment'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory RatingModel.fromJson(String source) =>
      RatingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RatingModel(id: $id, rate: $rate, userId: $userId, itemId: $itemId, comment: $comment, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant RatingModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.rate == rate &&
        other.userId == userId &&
        other.itemId == itemId &&
        other.comment == comment &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        rate.hashCode ^
        userId.hashCode ^
        itemId.hashCode ^
        comment.hashCode ^
        createdAt.hashCode;
  }
}
