import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../customer_list/customer_database_helper.dart';


class AddReservationPage extends StatefulWidget {
  @override
  _AddReservationPageState createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {
  final _reservationNameController = TextEditingController();
  final _flightController = TextEditingController();
  late SharedPreferences _prefs;
  final _databaseHelper = CustomerDatabaseHelper.instance;
  List<Map<String, dynamic>> _customers = [];
  List<String> _customerNames = [];
  String? _selectedCustomer;

  @override
  void initState() {
    super.initState();
    _loadCustomers(); // Load customers when the page initializes
  }

  // Load customers from the database
  Future<void> _loadCustomers() async {
    final customers = await _databaseHelper.getAllCustomers();
    setState(() {
      _customers = customers;
      _customerNames = customers.map((c) => '${c['firstName']} ${c['lastName']}').toList();
    });
  }

  // Add reservation to the database
  Future<void> _addReservation() async {
    try {
      final reservationName = _reservationNameController.text;
      final flight = _flightController.text;
      final customerId = _customers.firstWhere(
            (c) => '${c['firstName']} ${c['lastName']}' == _selectedCustomer,
        orElse: () => {'_id': null},
      )['_id'];

      if (reservationName.isNotEmpty && flight.isNotEmpty && customerId != null) {
        final reservation = {
          'reservationName': reservationName,
          'customerId': customerId,
          'flight': flight,
        };

        await _databaseHelper.insertReservation(reservation);

        Navigator.of(context).pop(reservation); // Return to the previous screen with the added reservation
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('All fields must be filled out!')),
        );
      }
    } catch (e) {
      print('Error while adding reservation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while adding the reservation.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Input field for reservation name
            TextField(
              controller: _reservationNameController,
              decoration: InputDecoration(labelText: 'Reservation Name'),
            ),
            // Input field for flight details
            TextField(
              controller: _flightController,
              decoration: InputDecoration(labelText: 'Flight'),
            ),
            // Dropdown menu for selecting customer
            DropdownButton<String>(
              value: _selectedCustomer,
              hint: Text('Select Customer'),
              onChanged: (newValue) {
                setState(() {
                  _selectedCustomer = newValue;
                });
              },
              items: _customerNames.map((name) {
                return DropdownMenuItem(
                  value: name,
                  child: Text(name),
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Button to submit the form and add a reservation
                ElevatedButton(
                  onPressed: _addReservation,
                  child: Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
