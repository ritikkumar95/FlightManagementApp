import 'package:flutter/material.dart';
import 'package:flight_management_app/customer_list/customer_database_helper.dart';

class ReservationListPage extends StatefulWidget {
  @override
  _ReservationListPageState createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  List<Map<String, dynamic>> _reservations = [];
  List<Map<String, dynamic>> _filteredReservations = [];
  final _databaseHelper = CustomerDatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  // Load reservations from the database
  Future<void> _loadReservations() async {
    final reservations = await _databaseHelper.getAllReservations();
    setState(() {
      _reservations = reservations;
      _filteredReservations = reservations;
    });
  }

  // Filter reservations by customer ID
  void _filterReservationsByCustomer(int customerId) {
    setState(() {
      _filteredReservations = _reservations.where((reservation) => reservation['customerId'] == customerId).toList();
    });
  }

  // Delete a reservation from the database
  Future<void> _deleteReservation(int id) async {
    await _databaseHelper.deleteReservation(id);
    _loadReservations(); // Reload reservations after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservations'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () async {
              final selectedCustomer = await _showCustomerFilterDialog();
              if (selectedCustomer != null) {
                _filterReservationsByCustomer(selectedCustomer['_id']);
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _filteredReservations.length,
        itemBuilder: (context, index) {
          final reservation = _filteredReservations[index];
          return ListTile(
            title: Text(reservation['reservationName']),
            subtitle: Text('Flight: ${reservation['flight']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteReservation(reservation['_id']),
            ),
          );
        },
      ),
    );
  }

  // Show dialog to select customer for filtering
  Future<Map<String, dynamic>?> _showCustomerFilterDialog() async {
    final customers = await _databaseHelper.getAllCustomers();
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        Map<String, dynamic>? selectedCustomer;
        return AlertDialog(
          title: Text('Select Customer'),
          content: DropdownButton<Map<String, dynamic>>(
            hint: Text('Select Customer'),
            value: selectedCustomer,
            onChanged: (value) {
              setState(() {
                selectedCustomer = value;
              });
            },
            items: customers.map((customer) {
              return DropdownMenuItem<Map<String, dynamic>>(
                value: customer,
                child: Text('${customer['firstName']} ${customer['lastName']}'),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(selectedCustomer),
              child: Text('Filter'),
            ),
          ],
        );
      },
    );
  }
}