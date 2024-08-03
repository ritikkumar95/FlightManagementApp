import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import '../customer_list/customer_database_helper.dart';

class AddReservationPage extends StatefulWidget {
  @override
  _AddReservationPageState createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {
  final _reservationNameController = TextEditingController();
  final _flightController = TextEditingController();

  List<Map<String, dynamic>> _customers = [];
  Map<String, dynamic>? _selectedCustomer;

  final _databaseHelper = CustomerDatabaseHelper.instance;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    _loadPreviousCustomer();
  }

  // Load customers from the database
  Future<void> _loadCustomers() async {
    final customers = await _databaseHelper.getAllCustomers();
    setState(() {
      _customers = customers;
    });
  }

  // Load previous customer data from shared preferences
  Future<void> _loadPreviousCustomer() async {
    _prefs = await SharedPreferences.getInstance();
    final encryptedPreviousCustomer = _prefs.getString('previousCustomer');
    if (encryptedPreviousCustomer != null) {
      final decryptedCustomer = _decrypt(encryptedPreviousCustomer);
      final customerDetails = decryptedCustomer.split('|');
      setState(() {
        _selectedCustomer = {
          'firstName': customerDetails[0],
          'lastName': customerDetails[1],
          'address': customerDetails[2],
          'birthday': customerDetails[3],
          '_id': int.parse(customerDetails[4]), // Ensure you store the ID as well
        };
      });
    }
  }

  // Encrypt data using AES encryption
  String _encrypt(String value) {
    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(value, iv: iv);
    return encrypted.base64;
  }

  // Decrypt data using AES encryption
  String _decrypt(String encryptedValue) {
    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(encryptedValue, iv: iv);
    return decrypted;
  }

  // Add reservation to the database
  Future<void> _addReservation() async {
    try {
      final reservationName = _reservationNameController.text;
      final flight = _flightController.text;

      if (_selectedCustomer != null && reservationName.isNotEmpty && flight.isNotEmpty) {
        final reservation = {
          'reservationName': reservationName,
          'customerId': _selectedCustomer!['_id'],
          'flight': flight,
        };

        final id = await _databaseHelper.insertReservation(reservation);

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
            DropdownButton<Map<String, dynamic>>(
              hint: Text('Select Customer'),
              value: _selectedCustomer,
              onChanged: (value) {
                setState(() {
                  _selectedCustomer = value;
                });
              },
              items: _customers.map((customer) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: customer,
                  child: Text('${customer['firstName']} ${customer['lastName']}'),
                );
              }).toList(),
            ),
            TextField(
              controller: _reservationNameController,
              decoration: InputDecoration(labelText: 'Reservation Name'),
            ),
            TextField(
              controller: _flightController,
              decoration: InputDecoration(labelText: 'Flight'),
            ),
            ElevatedButton(
              onPressed: _addReservation,
              child: Text('Add Reservation'),
            ),
          ],
        ),
      ),
    );
  }
}
