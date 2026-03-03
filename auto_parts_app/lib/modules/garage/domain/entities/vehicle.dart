class Vehicle {
  final String id;
  final String brand;
  final String model;
  final int year;
  final String? nickname;
  final String? color;

  const Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    this.nickname,
    this.color,
  });

  String get displayName => nickname ?? '$brand $model $year';
  String get shortName => '$brand $model';

  Map<String, dynamic> toMap() => {
        'id': id,
        'brand': brand,
        'model': model,
        'year': year,
        'nickname': nickname,
        'color': color,
      };

  factory Vehicle.fromMap(Map<String, dynamic> map) => Vehicle(
        id: map['id'] as String,
        brand: map['brand'] as String,
        model: map['model'] as String,
        year: map['year'] as int,
        nickname: map['nickname'] as String?,
        color: map['color'] as String?,
      );
}
