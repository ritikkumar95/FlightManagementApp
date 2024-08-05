class Airplane {
  final int? id;
  final String type;
  final int passengers;
  final double maxSpeed;
  final double range;

  Airplane({
    this.id,
    required this.type,
    required this.passengers,
    required this.maxSpeed,
    required this.range,
  });

  factory Airplane.fromJson(Map<String, dynamic> json) => Airplane(
    id: json['id'],
    type: json['type'],
    passengers: json['passengers'],
    maxSpeed: json['maxSpeed'],
    range: json['range'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'passengers': passengers,
    'maxSpeed': maxSpeed,
    'range': range,
  };
}
