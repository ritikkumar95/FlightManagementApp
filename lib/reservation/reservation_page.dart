import 'package:flutter/material.dart';
import 'package:flight_management_app/customer_list/customer_database_helper.dart';

class ReservationListPage extends StatefulWidget {
  @override
  _ReservationListPageState createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  List<Map<String, dynamic>> _reservations = [];
  final _databaseHelper = CustomerDatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  // Load reservations from the database
  Future<void> _loadReservations() async {
    final reservations = await _databaseHelper.getAllReservations();
    setState(() {
      _reservations = reservations;
    });
  }

  // Delete a reservation from the database
  Future<void> _deleteReservation(int id) async {
    await _databaseHelper.deleteReservation(id);
    _loadReservations(); // Reload reservations after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservations'),
      ),
      body: ListView.builder(
        itemCount: _reservations.length,
        itemBuilder: (context, index) {
          final reservation = _reservations[index];
          return ListTile(
            title: Text(reservation['reservationName']),
            subtitle: Text('Flight: ${reservation['flight']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteReservation(reservation['_id']),
            ),
          );
        },
      ),
    );
  }
}
