class CarModel {
  final int id;
  final int brandId;
  final int carTypeId;
  final String name;

  CarModel({required this.id, required this.brandId, required this.carTypeId, required this.name});

  factory CarModel.fromMap(Map<String, dynamic> map) {
    return CarModel(
      id: map['id'] as int,
      brandId: map['brandId'] as int,
      carTypeId: map['carTypeId'] as int,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'brandId': brandId,
    'carTypeId': carTypeId,
    'name': name,
  };
}