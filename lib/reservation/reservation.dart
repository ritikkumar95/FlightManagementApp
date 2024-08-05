import 'package:floor/floor.dart';

@entity
class Reservation {
  @primaryKey
  final int? id;
  final int flightId;
  final int customerId;
  final String reservationName;

  Reservation(this.id, this.flightId, this.customerId, this.reservationName);
}
