import 'package:flight_management_app/reservation/reservation_list.dart';
import 'package:flutter/material.dart';


class ReservationDetailsPage extends StatelessWidget {
  final Reservation reservation;

  ReservationDetailsPage({required this.reservation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reservation Name: ${reservation.name}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Customer: ${reservation.customerName}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Flight: ${reservation.flightInfo}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}