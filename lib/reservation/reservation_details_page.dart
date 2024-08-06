import 'package:flutter/material.dart';
import '../customer_list/customer_database_helper.dart';
import 'reservation_database_helper.dart';

class ReservationDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? reservation;
  final Map<String, dynamic>? customer;

  const ReservationDetailsPage({super.key, this.reservation, this.customer});

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
      _reservation = Map<String, dynamic>.from(widget.reservation!);
      _reservationNameController.text = _reservation[ReservationDatabaseHelper.columnReservationName] ?? '';
      _flightController.text = _reservation[ReservationDatabaseHelper.columnFlight] ?? '';
    } else {
      _reservation = {};
    }
  }

  Future<void> _saveReservation() async {
    final reservationName = _reservationNameController.text;
    final flight = _flightController.text;

    if (reservationName.isEmpty || flight.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    _reservation[ReservationDatabaseHelper.columnReservationName] = reservationName;
    _reservation[ReservationDatabaseHelper.columnFlight] = flight;

    try {
      if (_reservation[ReservationDatabaseHelper.columnReservationId] == null) {
        await ReservationDatabaseHelper.instance.insertReservation(_reservation);
      } else {
        await ReservationDatabaseHelper.instance.updateReservation(_reservation);
      }
      Navigator.of(context).pop();
    } catch (e) {
      print('Error saving reservation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving reservation: $e')),
      );
    }
  }

  Future<void> _updateReservation() async {
    final reservationName = _reservationNameController.text;
    final flight = _flightController.text;

    if (reservationName.isEmpty || flight.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    _reservation[ReservationDatabaseHelper.columnReservationName] = reservationName;
    _reservation[ReservationDatabaseHelper.columnFlight] = flight;

    try {
      if (_reservation[ReservationDatabaseHelper.columnReservationId] != null) {
        await ReservationDatabaseHelper.instance.updateReservation(_reservation);
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error updating reservation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating reservation: $e')),
      );
    }
  }

  Future<void> _deleteReservation() async {
    if (_reservation[ReservationDatabaseHelper.columnReservationId] == null) {
      return;
    }

    try {
      await ReservationDatabaseHelper.instance.deleteReservation(_reservation[ReservationDatabaseHelper.columnReservationId]);
      Navigator.of(context).pop();
    } catch (e) {
      print('Error deleting reservation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting reservation: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final reservationName = widget.reservation?[ReservationDatabaseHelper.columnReservationName] ?? '';
    final flight = widget.reservation?[ReservationDatabaseHelper.columnFlight] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _reservationNameController,
              decoration: const InputDecoration(labelText: 'Reservation Name'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _flightController,
              decoration: const InputDecoration(labelText: 'Flight'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _saveReservation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  onPressed: _updateReservation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Update'),
                ),
                ElevatedButton(
                  onPressed: _deleteReservation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
