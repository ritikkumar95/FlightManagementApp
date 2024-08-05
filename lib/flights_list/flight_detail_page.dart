import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'flight.dart';
import 'database.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';

class FlightDetailsPage extends StatefulWidget {
  final Flight? flight;
  final Function? onDelete;
  final Function? onUpdate;
  final Function? onAdd;

  FlightDetailsPage({this.flight, this.onDelete, this.onUpdate, this.onAdd});

  @override
  _FlightDetailsPageState createState() => _FlightDetailsPageState();
}

class _FlightDetailsPageState extends State<FlightDetailsPage> {
  late AppDatabase database;
  final _departureCityController = TextEditingController();
  final _destinationCityController = TextEditingController();
  final _departureTimeController = TextEditingController();
  final _arrivalTimeController = TextEditingController();
  late EncryptedSharedPreferences _encryptedSharedPreferences;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    _initializeSharedPreferences();
    if (widget.flight != null) {
      _departureCityController.text = widget.flight!.departureCity;
      _destinationCityController.text = widget.flight!.destinationCity;
      _departureTimeController.text = widget.flight!.departureTime;
      _arrivalTimeController.text = widget.flight!.arrivalTime;
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
    _departureCityController.text = await _encryptedSharedPreferences.getString('departureCity') ?? '';
    _destinationCityController.text = await _encryptedSharedPreferences.getString('destinationCity') ?? '';
    _departureTimeController.text = await _encryptedSharedPreferences.getString('departureTime') ?? '';
    _arrivalTimeController.text = await _encryptedSharedPreferences.getString('arrivalTime') ?? '';
  }

  void _saveText(String key, String value) {
    _encryptedSharedPreferences.setString(key, value);
  }

  void _onSubmit() async {
    if (_departureCityController.text.isNotEmpty &&
        _destinationCityController.text.isNotEmpty &&
        _departureTimeController.text.isNotEmpty &&
        _arrivalTimeController.text.isNotEmpty) {
      final int? flightId = widget.flight?.id;

      final flight = Flight(
        flightId,
        _departureCityController.text,
        _destinationCityController.text,
        _departureTimeController.text,
        _arrivalTimeController.text,
      );
      final flightDao = database.flightDao;
      if (widget.flight != null) {
        await flightDao.updateFlight(flight);
        widget.onUpdate?.call(flight);
      } else {
        await flightDao.insertFlight(flight);
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
    if (widget.flight != null) {
      final result = await _showDeleteDialog();
      if (result == 'Delete') {
        final flightDao = database.flightDao;
        await flightDao.deleteFlight(widget.flight!);
        widget.onDelete?.call(widget.flight);
        Navigator.pop(context);
      }
    }
  }

  Future<String?> _showDeleteDialog() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Delete'),
        content: Text('Are you sure you want to delete this flight?'),
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
        title: Text('Flight Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _departureCityController,
              decoration: InputDecoration(
                labelText: 'Departure City',
              ),
              onChanged: (text) => _saveText('departureCity', text),
            ),
            TextField(
              controller: _destinationCityController,
              decoration: InputDecoration(
                labelText: 'Destination City',
              ),
              onChanged: (text) => _saveText('destinationCity', text),
            ),
            TextField(
              controller: _departureTimeController,
              decoration: InputDecoration(
                labelText: 'Departure Time',
              ),
              onChanged: (text) => _saveText('departureTime', text),
            ),
            TextField(
              controller: _arrivalTimeController,
              decoration: InputDecoration(
                labelText: 'Arrival Time',
              ),
              onChanged: (text) => _saveText('arrivalTime', text),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _onSubmit,
                  child: Text(widget.flight != null ? 'Update Flight' : 'Add Flight'),
                ),
                if (widget.flight != null)
                  ElevatedButton(
                    onPressed: _onDelete,
                    child: Text('Delete Flight'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}