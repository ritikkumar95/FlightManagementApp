import 'package:flutter/material.dart';

import 'add_reservation.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('flight Management System'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddReservationPage()),
            );
          },
          child: Text('Add Reservation'),
        ),
      ),
    );
  }
}
