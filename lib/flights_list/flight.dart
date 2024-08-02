import 'package:floor/floor.dart';

@entity
class Flight{
  @primaryKey
  final int? id;
  final String departureCity;
  final String destinationCity;
  final String arrivalTime;
  final String departureTime;

  Flight(this.id, this.departureCity, this.destinationCity,
      this.arrivalTime, this.departureTime);

}