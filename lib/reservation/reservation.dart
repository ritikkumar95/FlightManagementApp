import 'package:floor/floor.dart';
import '../flights_list/flight.dart';
import '../customer_list/customer.dart';

@entity
class Reservation {
  @primaryKey
  final int? id;
  final String name;
  final int flightId;
  final int customerId;
  final String reservationDate;

  Reservation(this.id, this.name, this.flightId, this.customerId, this.reservationDate);
}
