import 'package:floor/floor.dart';
import '../reservation/reservation.dart';
import '../reservation/reservationDAO.dart';
import 'flight.dart';
import 'flightDAO.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';

part 'database.g.dart';
@Database(version: 1, entities: [Flight, Reservation])
abstract class AppDatabase extends FloorDatabase {
  FlightDao get flightDao;
  ReservationDao get reservationDao;
}
