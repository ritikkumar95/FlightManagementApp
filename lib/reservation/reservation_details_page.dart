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
    if (widget.reservation != null) {
      _reservation = widget.reservation!;
      _reservationNameController.text = _reservation[ReservationDatabaseHelper.columnReservationName] ?? '';
      _flightController.text = _reservation[ReservationDatabaseHelper.columnFlight] ?? '';
    } else {
      _reservation = {};
    }
  }

  Future<void> _saveReservation() async {
    final reservationName = _reservationNameController.text;
    final flight = _flightController.text;

    if (reservationName.isNotEmpty && flight.isNotEmpty) {
      final reservation = {
        ReservationDatabaseHelper.columnReservationName: reservationName,
        ReservationDatabaseHelper.columnFlight: flight,
        ReservationDatabaseHelper.columnCustomerIdFk: widget.customer?['customerId'], // Ensure this field is present
      };

      try {
        if (_reservation.isNotEmpty) {
          reservation[ReservationDatabaseHelper.columnReservationId] = _reservation[ReservationDatabaseHelper.columnReservationId];
          final result = await ReservationDatabaseHelper.instance.updateReservation(reservation);
          print('Update result: $result');
          if (result > 0) {
            Navigator.of(context).pop(reservation);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Update failed')),
            );
          }
        } else {
          final result = await ReservationDatabaseHelper.instance.insertReservation(reservation);
          print('Insert result: $result');
          if (result > 0) {
            Navigator.of(context).pop(reservation);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Insert failed')),
            );
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving reservation: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields must be filled out!')),
      );
    }
  }

  Future<void> _deleteReservation() async {
    final reservationId = _reservation[ReservationDatabaseHelper.columnReservationId];
    if (reservationId != null) {
      try {
        final result = await ReservationDatabaseHelper.instance.deleteReservation(reservationId);
        print('Delete result: $result');
        if (result > 0) {
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Delete failed')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting reservation: $e')),
        );
      }
    }
  }

  Future<void> _confirmDeleteReservation() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this reservation?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Dismiss dialog
                await _deleteReservation();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final customer = widget.customer;

    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _reservationNameController,
              decoration: InputDecoration(labelText: 'Reservation Name'),
            ),
            TextField(
              controller: _flightController,
              decoration: InputDecoration(labelText: 'Flight'),
            ),
            SizedBox(height: 20),
            if (customer != null) ...[
              Text('Customer Name: ${customer[CustomerDatabaseHelper.columnFirstName] ?? ''} ${customer[CustomerDatabaseHelper.columnLastName] ?? ''}'),
              Text('Address: ${customer[CustomerDatabaseHelper.columnAddress] ?? ''}'),
              Text('Birthday: ${customer[CustomerDatabaseHelper.columnBirthday] ?? ''}'),
            ] else ...[
              Text('No customer data available.'),
            ],
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _saveReservation,
                  child: Text(_reservation.isNotEmpty ? 'Update Reservation' : 'Add Reservation'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                ),
                SizedBox(width: 10),
                if (_reservation.isNotEmpty) ...[
                  ElevatedButton(
                    onPressed: _confirmDeleteReservation,
                    child: Text('Delete Reservation'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
