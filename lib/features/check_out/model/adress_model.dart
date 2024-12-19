// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AddressModel {
  final int? id;
  final String? region;
  final String? address;
  final int? userId;
  AddressModel({
    this.id,
    this.region,
    this.address,
    this.userId,
  });

  AddressModel copyWith({
    int? id,
    String? region,
    String? address,
    int? userId,
  }) {
    return AddressModel(
      id: id ?? this.id,
      region: region ?? this.region,
      address: address ?? this.address,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    if (id == null) {
      return <String, dynamic>{
        'region': region,
        'address': address,
        'user_id': userId,
      };
    } else {
      return <String, dynamic>{
        'id': id,
        'region': region,
        'address': address,
        'user_id': userId,
      };
    }
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] as int? ?? 0,
      region: map['region'] as String? ?? '',
      address: map['address'] as String? ?? '',
      userId: map['user_id'] as int? ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AddressModel(id: $id, region: $region, address: $address, userId: $userId)';
  }

  @override
  bool operator ==(covariant AddressModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.region == region &&
        other.address == address &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ region.hashCode ^ address.hashCode ^ userId.hashCode;
  }
}
