import 'package:flutter/material.dart';
import 'reservation_list_page.dart';

class AddReservationPage extends StatefulWidget {
  final Function(Reservation) onAddReservation;

  AddReservationPage({required this.onAddReservation});

  @override
  _AddReservationPageState createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {
  String reservationName = '';
  String selectedCustomer = '';
  String selectedFlight = '';

  // Assume these are populated from a database or API
  List<String> customers = ['John Doe', 'Jane Smith'];
  List<String> flights = ['AC 456 - Toronto to Vancouver', 'AC 457 - Toronto to Vancouver'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Reservation'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Reservation Name'),
              onChanged: (value) {
                setState(() {
                  reservationName = value;
                });
              },
            ),
            DropdownButton<String>(
              value: selectedCustomer.isEmpty ? null : selectedCustomer,
              hint: Text('Select Customer'),
              items: customers.map((customer) {
                return DropdownMenuItem<String>(
                  value: customer,
                  child: Text(customer),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCustomer = value!;
                });
              },
            ),
            DropdownButton<String>(
              value: selectedFlight.isEmpty ? null : selectedFlight,
              hint: Text('Select Flight'),
              items: flights.map((flight) {
                return DropdownMenuItem<String>(
                  value: flight,
                  child: Text(flight),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedFlight = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final reservation = Reservation(
                  name: reservationName,
                  customerName: selectedCustomer,
                  flightInfo: selectedFlight,
                );
                widget.onAddReservation(reservation);
                Navigator.pop(context);
              },
              child: Text('Add Reservation'),
            ),
          ],
        ),
      ),
    );
  }
}
