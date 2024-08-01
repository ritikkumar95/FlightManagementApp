import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'reservation.dart';
import 'add_reservation_page.dart';

class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  List<Reservation> reservations = [];
  Database? database;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  void _initializeDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'flight_management.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE reservations(id INTEGER PRIMARY KEY, name TEXT)",
        );
      },
      version: 1,
    );
    _fetchReservations();
  }

  void _fetchReservations() async {
    final List<Map<String, dynamic>> maps = await database!.query('reservations');
    setState(() {
      reservations = List.generate(maps.length, (i) {
        return Reservation(
          id: maps[i]['id'],
          name: maps[i]['name'],
          customerName: maps[i]['customerName'],
          flightNumber: maps[i]['flightNumber'],
          departureCity: maps[i]['departureCity'],
          destinationCity: maps[i]['destinationCity'],
          departureTime: DateTime.parse(maps[i]['departureTime']),
          arrivalTime: DateTime.parse(maps[i]['arrivalTime']),

        );
      });
    });
  }

  void _addReservation(String name) async {
    await database!.insert(
      'reservations',
      {'name': name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _fetchReservations();
  }

  void _showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservations'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Instructions'),
                  content: Text('Use the button below to add a new reservation.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(reservations[index].name),
                  onTap: () {
                    // Show reservation details
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Reservation Name',
              ),
              onSubmitted: (value) {
                _addReservation(value);
                _showSnackbar(context, 'Reservation added');
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddReservationPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
