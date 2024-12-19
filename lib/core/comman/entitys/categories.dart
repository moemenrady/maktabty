// ignore_for_file: public_member_api_docs, sort_constructors_first

class Categories {
  final int id;
  final String name;
  final String imageUrl;

  Categories({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  Categories copyWith({
    int? id,
    String? name,
    String? imageUrl,
  }) {
    return Categories(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(
      id: map['id'],
      name: map['name'],
      imageUrl: map['image_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
    };
  }
}
