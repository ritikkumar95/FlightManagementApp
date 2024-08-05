import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import '../customer_list/customer_database_helper.dart';


class AddReservationPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddReservation;

  AddReservationPage({required this.onAddReservation});

  @override
  _AddReservationPageState createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {
  String reservationName = '';
  String selectedCustomer = '';
  String selectedFlight = '';

  late SharedPreferences _prefs;
  final _databaseHelper = CustomerDatabaseHelper.instance;

  List<Map<String, dynamic>> customers = [];
  List<String> flights = [
    'AC 456 - Toronto to Vancouver',
    'AC 457 - Toronto to Vancouver',
    'AC 458 - Toronto to Montreal',
    'AC 459 - Toronto to New York'
  ];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    _loadPreviousReservation();
  }

  Future<void> _loadCustomers() async {
    final customerList = await _databaseHelper.getAllCustomers();
    setState(() {
      customers = customerList;
    });
  }

  Future<void> _loadPreviousReservation() async {
    _prefs = await SharedPreferences.getInstance();
    final encryptedPreviousReservation = _prefs.getString('previousReservation');
    if (encryptedPreviousReservation != null) {
      final decryptedReservation = _decrypt(encryptedPreviousReservation);
      final reservationDetails = decryptedReservation.split('|');
      setState(() {
        reservationName = reservationDetails[0];
        selectedCustomer = reservationDetails[1];
        selectedFlight = reservationDetails[2];
      });
    }
  }

  String _encrypt(String value) {
    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(value, iv: iv);
    return encrypted.base64;
  }

  String _decrypt(String encryptedValue) {
    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(encryptedValue, iv: iv);
    return decrypted;
  }

  Future<void> _addReservation() async {
    try {
      if (reservationName.isNotEmpty && selectedCustomer.isNotEmpty && selectedFlight.isNotEmpty) {
        final reservation = {
          'reservationName': reservationName,
          'customerId': selectedCustomer,
          'flight': selectedFlight,
        };

        final encryptedReservation = _encrypt('$reservationName|$selectedCustomer|$selectedFlight');
        await _prefs.setString('previousReservation', encryptedReservation);

        final id = await _databaseHelper.insertReservation(reservation);

        Navigator.of(context).pop(reservation);
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

  void _clearFields() {
    setState(() {
      reservationName = '';
      selectedCustomer = '';
      selectedFlight = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Reservation'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Reservation Name'),
              onChanged: (value) {
                setState(() {
                  reservationName = value;
                });
              },
              controller: TextEditingController(text: reservationName),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCustomer.isEmpty ? null : selectedCustomer,
              hint: Text('Select Customer'),
              items: customers.map((customer) {
                return DropdownMenuItem<String>(
                  value: customer['_id'].toString(),
                  child: Text('${customer['firstName']} ${customer['lastName']}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCustomer = value!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
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
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _addReservation,
                  child: Text('Submit'),
                ),
                ElevatedButton(
                  onPressed: _clearFields,
                  child: Text('Clear'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
