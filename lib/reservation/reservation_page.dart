import 'package:flutter/material.dart';

class ReservationListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservations List'),
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with actual reservation count
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Reservation $index'), // Replace with actual reservation data
            onTap: () {
              // Navigate to reservation details
            },
          );
        },
      ),
    );
  }
}
