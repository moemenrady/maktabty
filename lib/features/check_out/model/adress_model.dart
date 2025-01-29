// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AddressModel {
  final int? id;
  final int userId;
  final String address;
  final String region;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AddressModel({
    this.id,
    required this.userId,
    required this.address,
    required this.region,
    this.createdAt,
    this.updatedAt,
  });

  AddressModel copyWith({
    int? id,
    int? userId,
    String? address,
    String? region,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      address: address ?? this.address,
      region: region ?? this.region,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    // For new addresses (id is null), exclude id and add current timestamp
    if (id == null) {
      final now = DateTime.now().toIso8601String();
      return {
        'user_id': userId,
        'address': address,
        'region': region,
        'created_at': now,
        'updated_at': now,
      };
    }
    // For existing addresses (id is not null), include id
    return {
      'id': id,
      'user_id': userId,
      'address': address,
      'region': region,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id']?.toInt() ?? 0,
      userId: map['user_id']?.toInt() ?? 0,
      address: map['address'] ?? '',
      region: map['region'] ?? '',
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt:
          map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AddressModel(id: $id, region: $region, address: $address, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant AddressModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.region == region &&
        other.address == address &&
        other.userId == userId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        region.hashCode ^
        address.hashCode ^
        userId.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
