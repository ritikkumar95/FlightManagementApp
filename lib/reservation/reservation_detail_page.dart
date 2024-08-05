import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import '../customer_list/customer.dart';
import '../customer_list/customer_database_helper.dart';
import '../flights_list/database.dart';
import '../flights_list/flight.dart';
import 'reservation.dart';


class ReservationDetailsPage extends StatefulWidget {
  final Reservation? reservation;
  final Function? onDelete;
  final Function? onUpdate;
  final Function? onAdd;

  ReservationDetailsPage({this.reservation, this.onDelete, this.onUpdate, this.onAdd});

  @override
  _ReservationDetailsPageState createState() => _ReservationDetailsPageState();
}

class _ReservationDetailsPageState extends State<ReservationDetailsPage> {
  late AppDatabase database;
  late CustomerDatabaseHelper customerDatabaseHelper;
  final _reservationNameController = TextEditingController();
  Flight? selectedFlight;
  Customer? selectedCustomer;
  late List<Flight> flights = [];
  late List<Customer> customers = [];
  late EncryptedSharedPreferences _encryptedSharedPreferences;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    _initializeSharedPreferences();
    _loadInitialData();
  }

  Future<void> _initializeDatabase() async {
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }

  Future<void> _initializeSharedPreferences() async {
    _encryptedSharedPreferences = EncryptedSharedPreferences();
  }

  Future<void> _loadInitialData() async {
    final flightDao = database.flightDao;
    flights = await flightDao.findAllFlights();

    customerDatabaseHelper = CustomerDatabaseHelper.instance;
    final customerMaps = await customerDatabaseHelper.getAllCustomers();
    customers = customerMaps.map((map) => Customer.fromMap(map)).toList();

    if (widget.reservation != null) {
      _reservationNameController.text = widget.reservation!.reservationName;
      selectedFlight = flights.firstWhere((flight) => flight.id == widget.reservation!.flightId);
      selectedCustomer = customers.firstWhere((customer) => customer.id == widget.reservation!.customerId);
    }
  }

  void _onSubmit() async {
    if (selectedFlight != null && selectedCustomer != null && _reservationNameController.text.isNotEmpty) {
      final int? reservationId = widget.reservation?.id;

      final reservation = Reservation(
        reservationId,
        selectedFlight!.id!,
        selectedCustomer!.id!,
        _reservationNameController.text,
      );
      final reservationDao = database.reservationDao;
      if (widget.reservation != null) {
        await reservationDao.updateReservation(reservation);
        widget.onUpdate?.call(reservation);
      } else {
        await reservationDao.insertReservation(reservation);
        widget.onAdd?.call();
      }
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a value for all fields')),
      );
    }
  }

  void _onDelete() async {
    if (widget.reservation != null) {
      final result = await _showDeleteDialog();
      if (result == 'Delete') {
        final reservationDao = database.reservationDao;
        await reservationDao.deleteReservation(widget.reservation!);
        widget.onDelete?.call(widget.reservation);
        Navigator.pop(context);
      }
    }
  }

  Future<String?> _showDeleteDialog() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Delete'),
        content: Text('Are you sure you want to delete this reservation?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop('Cancel'),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop('Delete'),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<Flight>(
              value: selectedFlight,
              hint: Text('Select Flight'),
              items: flights.map((flight) {
                return DropdownMenuItem<Flight>(
                  value: flight,
                  child: Text('${flight.departureCity} ➔ ${flight.destinationCity}'),
                );
              }).toList(),
              onChanged: (flight) {
                setState(() {
                  selectedFlight = flight;
                });
              },
            ),
            DropdownButton<Customer>(
              value: selectedCustomer,
              hint: Text('Select Customer'),
              items: customers.map((customer) {
                return DropdownMenuItem<Customer>(
                  value: customer,
                  child: Text('${customer.firstName} ${customer.lastName}'),
                );
              }).toList(),
              onChanged: (customer) {
                setState(() {
                  selectedCustomer = customer;
                });
              },
            ),
            TextField(
              controller: _reservationNameController,
              decoration: InputDecoration(
                labelText: 'Reservation Name',
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _onSubmit,
                  child: Text(widget.reservation != null ? 'Update Reservation' : 'Add Reservation'),
                ),
                if (widget.reservation != null)
                  ElevatedButton(
                    onPressed: _onDelete,
                    child: Text('Delete Reservation'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
