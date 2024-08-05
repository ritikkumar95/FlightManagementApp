import 'package:flight_management_app/reservation/reservation_detail.dart';
import 'package:flutter/material.dart';
import 'add_reservation.dart';


class ReservationListPage extends StatefulWidget {
  @override
  _ReservationListPageState createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  List<Reservation> reservations = [];

  void _navigateToAddReservation() async {
    final reservation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddReservationPage(
        onAddReservation: (reservation) {
          setState(() {
            reservations.add(reservation as Reservation);
          });
        },
      )),
    );

    if (reservation != null) {
      setState(() {
        reservations.add(reservation as Reservation);
      });
    }
  }

  void _viewReservationDetails(Reservation reservation) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReservationDetailsPage(reservation: reservation)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservations'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(reservations[index].name),
                    subtitle: Text('${reservations[index].customerName} - ${reservations[index].flightInfo}'),
                    onTap: () {
                      _viewReservationDetails(reservations[index]);
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _navigateToAddReservation,
              child: Text('Add Reservation'),
            ),
          ],
        ),
      ),
    );
  }
}

class Reservation {
  final String name;
  final String customerName;
  final String flightInfo;

  Reservation({
    required this.name,
    required this.customerName,
    required this.flightInfo,
  });
}
