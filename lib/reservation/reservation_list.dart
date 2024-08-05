import 'package:flutter/material.dart';
import 'package:flight_management_app/reservation/reservation_detail.dart';
import '../customer_list/customer_database_helper.dart';
import 'reservation_database_helper.dart';

class ReservationListPage extends StatefulWidget {
  @override
  _ReservationListPageState createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  final _reservationDatabaseHelper = ReservationDatabaseHelper.instance;
  final _customerDatabaseHelper = CustomerDatabaseHelper.instance;
  List<Map<String, dynamic>> reservations = [];

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    final reservationsList = await _reservationDatabaseHelper.getAllReservations();
    setState(() {
      reservations = reservationsList;
    });
  }

  void _viewReservationDetails(Map<String, dynamic> reservation) async {
    final customerId = reservation[ReservationDatabaseHelper.columnCustomerIdFk];
    final customer = await _customerDatabaseHelper.getCustomerById(customerId);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReservationDetailsPage(
          reservation: reservation,
          customer: customer,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation List'),
      ),
      body: ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          final reservation = reservations[index];
          return ListTile(
            title: Text(reservation[ReservationDatabaseHelper.columnReservationName]),
            subtitle: Text('Flight: ${reservation[ReservationDatabaseHelper.columnFlight]}'),
            onTap: () => _viewReservationDetails(reservation),
          );
        },
      ),
    );
  }
}