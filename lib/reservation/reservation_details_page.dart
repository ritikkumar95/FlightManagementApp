import 'package:flutter/material.dart';
import '../customer_list/customer_database_helper.dart';
import 'reservation_database_helper.dart';

class ReservationDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? reservation;
  final Map<String, dynamic>? customer;

  ReservationDetailsPage({this.reservation, this.customer});

  @override
  _ReservationDetailsPageState createState() => _ReservationDetailsPageState();
}

class _ReservationDetailsPageState extends State<ReservationDetailsPage> {
  final _reservationNameController = TextEditingController();
  final _flightController = TextEditingController();
  late Map<String, dynamic> _reservation;

  @override
  void initState() {
    super.initState();
    _reservation = widget.reservation ?? {};
    _reservationNameController.text = _reservation[ReservationDatabaseHelper.columnReservationName] ?? '';
    _flightController.text = _reservation[ReservationDatabaseHelper.columnFlight] ?? '';
  }

  Future<void> _updateReservation() async {
    final reservationName = _reservationNameController.text;
    final flight = _flightController.text;

    if (reservationName.isNotEmpty && flight.isNotEmpty) {
      final updatedReservation = {
        ReservationDatabaseHelper.columnReservationId: _reservation[ReservationDatabaseHelper.columnReservationId],
        ReservationDatabaseHelper.columnReservationName: reservationName,
        ReservationDatabaseHelper.columnCustomerIdFk: _reservation[ReservationDatabaseHelper.columnCustomerIdFk],
        ReservationDatabaseHelper.columnFlight: flight,
      };

      await ReservationDatabaseHelper.instance.updateReservation(updatedReservation);
      Navigator.of(context).pop(updatedReservation);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields must be filled out!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _reservationNameController,
              decoration: InputDecoration(labelText: 'Reservation Name'),
            ),
            TextField(
              controller: _flightController,
              decoration: InputDecoration(labelText: 'Flight'),
            ),
            Text('Customer Name: ${widget.customer?[CustomerDatabaseHelper.columnFirstName] ?? ''} ${widget.customer?[CustomerDatabaseHelper.columnLastName] ?? ''}'),
            Text('Address: ${widget.customer?[CustomerDatabaseHelper.columnAddress] ?? ''}'),
            Text('Birthday: ${widget.customer?[CustomerDatabaseHelper.columnBirthday] ?? ''}'),
            ElevatedButton(
              onPressed: _updateReservation,
              child: Text('Update Reservation'),
            ),
          ],
        ),
      ),
    );
  }
}
