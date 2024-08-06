import 'package:flutter/material.dart';
import 'add_reservation_page.dart';
import 'reservation_details_page.dart';
import '../customer_list/customer_database_helper.dart';
import 'reservation_database_helper.dart';

class ReservationListPage extends StatefulWidget {
  const ReservationListPage({super.key});

  @override
  _ReservationListPageState createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  List<Map<String, dynamic>> reservations = [];
  final _reservationDatabaseHelper = ReservationDatabaseHelper.instance;
  final _customerDatabaseHelper = CustomerDatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    try {
      final reservationsList = await _reservationDatabaseHelper.getAllReservations();
      setState(() {
        reservations = reservationsList;
      });
    } catch (e) {
      print('Error loading reservations: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading reservations: $e')),
      );
    }
  }

  Future<void> _deleteReservation(int id) async {
    try {
      await _reservationDatabaseHelper.deleteReservation(id);
      _loadReservations();
    } catch (e) {
      print('Error deleting reservation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting reservation: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservations List'),
      ),
      body: ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          final reservation = reservations[index];
          return ListTile(
            title: Text(reservation[ReservationDatabaseHelper.columnReservationName]),
            subtitle: FutureBuilder(
              future: _customerDatabaseHelper.getCustomerById(reservation[ReservationDatabaseHelper.columnCustomerIdFk]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Text('Error loading customer');
                  }
                  final customer = snapshot.data as Map<String, dynamic>?;
                  return customer != null
                      ? Text('${customer[CustomerDatabaseHelper.columnFirstName]} ${customer[CustomerDatabaseHelper.columnLastName]}')
                      : const Text('Customer not found');
                } else {
                  return const Text('Loading...');
                }
              },
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteReservation(reservation[ReservationDatabaseHelper.columnReservationId]),
            ),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ReservationDetailsPage(reservation: reservation),
                ),
              );
              _loadReservations();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddReservationPage(onAddReservation: (reservation) => _loadReservations()),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
