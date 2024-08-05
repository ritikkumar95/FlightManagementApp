import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'flight.dart';
import 'flightDAO.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Flight])
abstract class AppDatabase extends FloorDatabase {
  FlightDao get flightDao;
}