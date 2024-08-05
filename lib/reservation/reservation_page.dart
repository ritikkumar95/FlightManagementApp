import 'package:flight_management_app/reservation/reservation.dart';
import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import '../customer_list/customer.dart';
import '../flights_list/database.dart';
import '../flights_list/flight.dart';


class ReservationPage extends StatefulWidget {
  final Reservation? reservation;
  final Function? onAdd;
  final Function? onUpdate;
  final Function? onDelete;

  ReservationPage({this.reservation, this.onAdd, this.onUpdate, this.onDelete});

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  late AppDatabase database;
  final _nameController = TextEditingController();
  Flight? selectedFlight;
  Customer? selectedCustomer;
  final _reservationDateController = TextEditingController();
  late EncryptedSharedPreferences _encryptedSharedPreferences;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    _initializeSharedPreferences();
    if (widget.reservation != null) {
      _nameController.text = widget.reservation!.name;
      _reservationDateController.text = widget.reservation!.reservationDate;
    } else {
      _loadSavedText();
    }
  }

  Future<void> _initializeDatabase() async {
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }

  Future<void> _initializeSharedPreferences() async {
    _encryptedSharedPreferences = EncryptedSharedPreferences();
  }

  Future<void> _loadSavedText() async {
    _nameController.text = await _encryptedSharedPreferences.getString('reservationName') ?? '';
  }

  void _saveText(String key, String value) {
    _encryptedSharedPreferences.setString(key, value);
  }

  void _onSubmit() async {
    if (_nameController.text.isNotEmpty &&
        selectedFlight != null &&
        selectedCustomer != null &&
        _reservationDateController.text.isNotEmpty) {
      final int? reservationId = widget.reservation?.id;

      final reservation = Reservation(
        reservationId,
        _nameController.text,
        selectedFlight!.id!,
        selectedCustomer!.id!,
        _reservationDateController.text,
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
        SnackBar(content: Text('Please fill out all fields')),
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
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Reservation Name',
              ),
              onChanged: (text) => _saveText('reservationName', text),
            ),
            // You should add widgets for selecting flight and customer.
            TextField(
              controller: _reservationDateController,
              decoration: InputDecoration(
                labelText: 'Reservation Date',
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
