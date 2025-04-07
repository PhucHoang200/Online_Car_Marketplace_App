class CarFeature {
  final int carId;
  final int featureId;

  CarFeature({required this.carId, required this.featureId});

  factory CarFeature.fromMap(Map<String, dynamic> map) {
    return CarFeature(
      carId: map['carId'] as int,
      featureId: map['featureId'] as int,
    );
  }

  Map<String, dynamic> toMap() => {
    'carId': carId,
    'featureId': featureId,
  };
}