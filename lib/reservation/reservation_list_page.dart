import 'package:flutter/material.dart';
import 'add_reservation.dart';

class ReservationListPage extends StatefulWidget {
  @override
  _ReservationListPageState createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  List<Reservation> reservations = [];

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
                      // Navigate to reservation details page
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddReservationPage(
                    onAddReservation: (reservation) {
                      setState(() {
                        reservations.add(reservation as Reservation);
                      });
                    },
                  )),
                );
              },
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
