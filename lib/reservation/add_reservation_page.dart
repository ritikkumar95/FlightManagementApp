import 'package:flutter/material.dart';
import '../customer_list/customer_database_helper.dart';
import 'reservation_database_helper.dart';

class AddReservationPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddReservation;

  const AddReservationPage({super.key, required this.onAddReservation});

  @override
  _AddReservationPageState createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {
  String reservationName = '';
  String selectedCustomer = '';
  String selectedFlight = '';

  final _reservationDatabaseHelper = ReservationDatabaseHelper.instance;
  final _customerDatabaseHelper = CustomerDatabaseHelper.instance;

  List<Map<String, dynamic>> customers = [];
  List<String> flights = [
    'AC 456 - Toronto to Vancouver',
    'AC 457 - Toronto to Vancouver',
    'AC 458 - Toronto to Vancouver',
    'AC 459 - Toronto to Vancouver',
    'WS 100 - Toronto to Calgary',
    'WS 101 - Toronto to Calgary',
    'WS 102 - Toronto to Calgary',
    'WS 103 - Toronto to Calgary',
  ];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    try {
      final customersList = await _customerDatabaseHelper.getAllCustomers();
      setState(() {
        customers = customersList;
      });
    } catch (e) {
      print('Error loading customers: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading customers: $e')),
      );
    }
  }

  Future<void> _addReservation() async {
    if (reservationName.isEmpty || selectedCustomer.isEmpty || selectedFlight.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    final customerId = int.tryParse(selectedCustomer.split(' - ')[0]) ?? 0;

    if (customerId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid customer selected')),
      );
      return;
    }

    final reservation = {
      ReservationDatabaseHelper.columnReservationName: reservationName,
      ReservationDatabaseHelper.columnCustomerIdFk: customerId,
      ReservationDatabaseHelper.columnFlight: selectedFlight,
    };

    try {
      await _reservationDatabaseHelper.insertReservation(reservation);
      widget.onAddReservation(reservation);
      Navigator.of(context).pop();
    } catch (e) {
      print('Error adding reservation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding reservation: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Reservation Name'),
              onChanged: (value) {
                setState(() {
                  reservationName = value;
                });
              },
            ),
            DropdownButton<String>(
              hint: const Text('Select Customer'),
              value: selectedCustomer.isEmpty ? null : selectedCustomer,
              items: customers.map((customer) {
                return DropdownMenuItem<String>(
                  value: '${customer[CustomerDatabaseHelper.columnId]} - ${customer[CustomerDatabaseHelper.columnFirstName]} ${customer[CustomerDatabaseHelper.columnLastName]}',
                  child: Text('${customer[CustomerDatabaseHelper.columnFirstName]} ${customer[CustomerDatabaseHelper.columnLastName]}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCustomer = value ?? '';
                });
              },
            ),
            DropdownButton<String>(
              hint: const Text('Select Flight'),
              value: selectedFlight.isEmpty ? null : selectedFlight,
              items: flights.map((flight) {
                return DropdownMenuItem<String>(
                  value: flight,
                  child: Text(flight),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedFlight = value ?? '';
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addReservation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              child: const Text('Add Reservation'),
            ),
          ],
        ),
      ),
    );
  }
}
