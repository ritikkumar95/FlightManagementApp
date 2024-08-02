import 'package:flutter/material.dart';
import 'customer_database_helper.dart';


class CustomerDetailPage extends StatefulWidget {
  final Map<String, dynamic> customer;

  CustomerDetailPage({required this.customer});

  @override
  _CustomerDetailPageState createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _databaseHelper = CustomerDatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.customer['firstName'];
    _lastNameController.text = widget.customer['lastName'];
    _addressController.text = widget.customer['address'];
    _birthdayController.text = widget.customer['birthday'];
  }

  Future<void> _updateCustomer() async {
    final updatedCustomer = {
      '_id': widget.customer['_id'],
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'address': _addressController.text,
      'birthday': _birthdayController.text,
    };

    if (updatedCustomer['_id'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Customer ID is null')),
      );
      return;
    }

    await _databaseHelper.updateCustomer(updatedCustomer);

    Navigator.of(context).pop(updatedCustomer);
  }

  Future<void> _deleteCustomer() async {
    await _databaseHelper.deleteCustomer(widget.customer['_id']);
    Navigator.of(context).pop('deleted');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _birthdayController,
              decoration: InputDecoration(labelText: 'Birthday'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _updateCustomer,
                  child: Text('Update'),
                ),
                ElevatedButton(
                  onPressed: _deleteCustomer,
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
