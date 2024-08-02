import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_customer_page.dart';
import 'customer_detail_page.dart';
import 'customer_database_helper.dart';

// Page for displaying and managing the list of customers
class CustomerListPage extends StatefulWidget {
  @override
  _CustomerListPageState createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final List<Map<String, dynamic>> _customers = []; // List to hold customer data
  final _databaseHelper = CustomerDatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadCustomers(); // Load customers from the database on initialization
  }

  // Load customers from the database
  Future<void> _loadCustomers() async {
    final customers = await _databaseHelper.getAllCustomers();
    setState(() {
      _customers.addAll(customers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer List'),
        actions: [
          // Info button to show instructions
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Instructions'),
                    content: Text('Manage your customer list by adding, updating, or deleting customers.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Button to navigate to the page for adding a new customer
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCustomerPage()),
              );
              if (result != null) {
                setState(() {
                  _customers.add(result); // Add new customer to the list
                });
              }
            },
            child: Text('Add Customer'),
          ),
          Expanded(
            // List view to display the list of customers
            child: ListView.builder(
              itemCount: _customers.length,
              itemBuilder: (context, index) {
                final customer = _customers[index];
                return ListTile(
                  title: Text('${customer['firstName']} ${customer['lastName']}'),
                  subtitle: Text(customer['address']),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerDetailPage(customer: customer),
                      ),
                    );
                    if (result == 'deleted') {
                      setState(() {
                        _customers.removeAt(index); // Remove customer from the list if deleted
                      });
                    } else if (result != null) {
                      setState(() {
                        _customers[index] = result; // Update customer details in the list
                      });
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
