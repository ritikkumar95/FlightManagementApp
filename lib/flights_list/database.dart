import 'package:floor/floor.dart';
import '../reservation/reservation.dart';
import '../reservation/reservationDAO.dart';
import 'flight.dart';   // Make sure to import the Flight and Reservation classes
import 'flightDAO.dart';

import 'database.g.dart';
@Database(version: 1, entities: [Flight, Reservation])
abstract class AppDatabase extends FloorDatabase {
  FlightDao get flightDao;
  ReservationDao get reservationDao;
}
