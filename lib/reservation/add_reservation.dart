import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:shared_preferences/shared_preferences.dart';

class AddReservationPage extends StatefulWidget {
  @override
  _AddReservationPageState createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {
  final _nameController = TextEditingController();
  String? _selectedCustomer; // Use nullable type
  String? _selectedFlight; // Use nullable type
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Load preferences or default values
  }

  void _saveReservation() async {
    // Save reservation to database
    // For demonstration purposes, we're just printing to the console
    print('Saving Reservation');
    print('Customer: $_selectedCustomer');
    print('Flight: $_selectedFlight');
    print('Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}');
    print('Name: ${_nameController.text}');

    // Navigate back to the list page
    Navigator.pop(context);
  }

  void _selectDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ) ?? _selectedDate;

    setState(() {
      _selectedDate = picked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedCustomer,
              hint: Text('Select Customer'),
              items: <String>['Customer 1', 'Customer 2'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCustomer = newValue;
                });
              },
            ),
            DropdownButton<String>(
              value: _selectedFlight,
              hint: Text('Select Flight'),
              items: <String>['Flight 1', 'Flight 2'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFlight = newValue;
                });
              },
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Reservation Name'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: _selectDate,
              child: Text('Select Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveReservation,
              child: Text('Save Reservation'),
            ),
          ],
        ),
      ),
    );
  }
}
