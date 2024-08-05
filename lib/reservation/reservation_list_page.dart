import 'package:flutter/material.dart';
import '../flights_list/database.dart';
import 'reservation_page.dart';
import 'reservation.dart';


class ReservationListPage extends StatefulWidget {
  @override
  _ReservationListPageState createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  late AppDatabase database;
  List<Reservation> reservations = [];
  Reservation? selectedReservation;

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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var isWideScreen = size.width > 720;

    return Scaffold(
      appBar: AppBar(
        title: Text('Reservations List'),
      ),
      body: isWideScreen
          ? Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildReservationList(context),
          ),
          if (selectedReservation != null)
            Expanded(
              flex: 2,
              child: ReservationPage(
                reservation: selectedReservation,
                onDelete: _onReservationDeleted,
                onUpdate: _onReservationUpdated,
              ),
            ),
        ],
      )
          : _buildReservationList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReservationPage(onAdd: _onReservationAdded),
            ),
          ).then((_) => _showReservations());
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _onReservationSelected(Reservation reservation) {
    setState(() {
      selectedReservation = reservation;
    });
  }

  void _onReservationDeleted(Reservation reservation) async {
    await _showReservations();
    setState(() {
      selectedReservation = null;
    });
  }

  void _onReservationUpdated(Reservation reservation) async {
    await _showReservations();
    setState(() {
      selectedReservation = reservation;
    });
  }

  void _onReservationAdded() async {
    await _showReservations();
    setState(() {
      selectedReservation = reservations.last;
    });
  }

  Widget _buildReservationList(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              return ListTile(
                title: Text('${reservation.name}'),
                subtitle: Text('Flight ID: ${reservation.flightId} - Customer ID: ${reservation.customerId}'),
                onTap: () {
                  if (MediaQuery.of(context).size.width > 720) {
                    _onReservationSelected(reservation);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReservationPage(
                          reservation: reservation,
                          onDelete: _onReservationDeleted,
                          onUpdate: _onReservationUpdated,
                        ),
                      ),
                    ).then((_) => _showReservations());
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
