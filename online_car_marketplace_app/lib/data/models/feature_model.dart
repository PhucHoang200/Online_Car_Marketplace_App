class Feature {
  final int id;
  final String name;

  Feature({required this.id, required this.name});

  factory Feature.fromMap(Map<String, dynamic> map) {
    return Feature(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
  };
}