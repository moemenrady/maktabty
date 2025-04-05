import 'dart:convert';

class ServiceProviderRequestModel {
  final int? id;
  final DateTime? createdAt;
  final String state;
  final int serviceProviderId;
  final String? nationalIdFront;
  final String? nationalIdBack;

  ServiceProviderRequestModel({
    this.id,
    this.createdAt,
    this.state = 'pending',
    required this.serviceProviderId,
    this.nationalIdFront,
    this.nationalIdBack,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'state': state,
      'service_provider_id': serviceProviderId,
      'national_id_front': nationalIdFront,
      'national_id_back': nationalIdBack,
    };
  }

  factory ServiceProviderRequestModel.fromMap(Map<String, dynamic> map) {
    return ServiceProviderRequestModel(
      id: map['id']?.toInt(),
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      state: map['state'] ?? 'pending',
      serviceProviderId: map['service_provider_id']?.toInt() ?? 0,
      nationalIdFront: map['national_id_front'],
      nationalIdBack: map['national_id_back'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceProviderRequestModel.fromJson(String source) =>
      ServiceProviderRequestModel.fromMap(json.decode(source));

  ServiceProviderRequestModel copyWith({
    int? id,
    DateTime? createdAt,
    String? state,
    int? serviceProviderId,
    String? nationalIdFront,
    String? nationalIdBack,
  }) {
    return ServiceProviderRequestModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      state: state ?? this.state,
      serviceProviderId: serviceProviderId ?? this.serviceProviderId,
      nationalIdFront: nationalIdFront ?? this.nationalIdFront,
      nationalIdBack: nationalIdBack ?? this.nationalIdBack,
    );
  }
}
