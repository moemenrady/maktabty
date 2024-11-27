// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Categories {
  final int id;
  final String name;
  Categories({
    required this.id,
    required this.name,
  });

  Categories copyWith({
    int? id,
    String? name,
  }) {
    return Categories(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Categories.fromJson(String source) =>
      Categories.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Categories(id: $id, name: $name)';

  @override
  bool operator ==(covariant Categories other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
