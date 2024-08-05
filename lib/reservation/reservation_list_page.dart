import 'package:flight_management_app/reservation/reservation_detail_page.dart';
import 'package:flutter/material.dart';
import '../flights_list/database.dart';

import 'reservation.dart';


class ReservationListPage extends StatefulWidget {
  @override
  _ReservationListPageState createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  late AppDatabase database;
  List<Reservation> reservations = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _showReservations();
  }

  Future<void> _showReservations() async {
    final reservationDao = database.reservationDao;
    final reservationList = await reservationDao.findAllReservations();
    setState(() {
      reservations = reservationList;
    });
  }

  void _onReservationAdded() async {
    await _showReservations();
  }

  void _onReservationUpdated(Reservation reservation) async {
    await _showReservations();
  }

  void _onReservationDeleted(Reservation reservation) async {
    await _showReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservations List'),
      ),
      body: ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          final reservation = reservations[index];
          return ListTile(
            title: Text('Reservation Name: ${reservation.reservationName}'),
            subtitle: Text('Flight ID: ${reservation.flightId} | Customer ID: ${reservation.customerId}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReservationDetailsPage(
                    reservation: reservation,
                    onDelete: _onReservationDeleted,
                    onUpdate: _onReservationUpdated,
                  ),
                ),
              ).then((_) => _showReservations());
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReservationDetailsPage(onAdd: _onReservationAdded),
            ),
          ).then((_) => _showReservations());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
