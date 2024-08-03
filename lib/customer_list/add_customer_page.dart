import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'customer_database_helper.dart';

// Page for adding a new customer
class AddCustomerPage extends StatefulWidget {
  @override
  _AddCustomerPageState createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  // Controllers for input fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthdayController = TextEditingController();

  late SharedPreferences _prefs;
  final _databaseHelper = CustomerDatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadPreviousCustomer(); // Load previous customer data if available
  }

  // Load previous customer data from shared preferences
  Future<void> _loadPreviousCustomer() async {
    _prefs = await SharedPreferences.getInstance();
    final encryptedPreviousCustomer = _prefs.getString('previousCustomer');
    if (encryptedPreviousCustomer != null) {
      final decryptedCustomer = _decrypt(encryptedPreviousCustomer);
      final customerDetails = decryptedCustomer.split('|');
      setState(() {
        _firstNameController.text = customerDetails[0];
        _lastNameController.text = customerDetails[1];
        _addressController.text = customerDetails[2];
        _birthdayController.text = customerDetails[3];
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

  // Add customer to the database and save data to shared preferences
  Future<void> _addCustomer() async {
    try {
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final address = _addressController.text;
      final birthday = _birthdayController.text;

      if (firstName.isNotEmpty && lastName.isNotEmpty && address.isNotEmpty && birthday.isNotEmpty) {
        final customer = {
          'firstName': firstName,
          'lastName': lastName,
          'address': address,
          'birthday': birthday,
        };

        final encryptedCustomer = _encrypt('$firstName|$lastName|$address|$birthday');
        await _prefs.setString('previousCustomer', encryptedCustomer);

        final id = await _databaseHelper.insertCustomer(customer);

        Navigator.of(context).pop(customer); // Return to the previous screen with the added customer
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('All fields must be filled out!')),
        );
      }
    } catch (e) {
      print('Error while adding customer: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while adding the customer.')),
      );
    }
  }

  // Clear all input fields
  void _clearFields() {
    setState(() {
      _firstNameController.clear();
      _lastNameController.clear();
      _addressController.clear();
      _birthdayController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Input field for first name
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            // Input field for last name
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            // Input field for address
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            // Input field for birthday
            TextField(
              controller: _birthdayController,
              decoration: InputDecoration(labelText: 'Birthday'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Button to submit the form and add a customer
                ElevatedButton(
                  onPressed: _addCustomer,
                  child: Text('Submit'),
                ),
                // Button to clear all input fields
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
