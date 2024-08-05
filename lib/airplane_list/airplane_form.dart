import 'package:flutter/material.dart';

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import 'airplane.dart';
import 'database_helper.dart';

class AirplaneFormPage extends StatefulWidget {
  final Airplane? airplane;

  AirplaneFormPage({this.airplane});

  @override
  _AirplaneFormPageState createState() => _AirplaneFormPageState();
}

class _AirplaneFormPageState extends State<AirplaneFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _type;
  late int _passengers;
  late double _maxSpeed;
  late double _range;

  @override
  void initState() {
    super.initState();
    if (widget.airplane != null) {
      _type = widget.airplane!.type;
      _passengers = widget.airplane!.passengers;
      _maxSpeed = widget.airplane!.maxSpeed;
      _range = widget.airplane!.range;
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newAirplane = Airplane(
        id: widget.airplane?.id,
        type: _type,
        passengers: _passengers,
        maxSpeed: _maxSpeed,
        range: _range,
      );
      if (widget.airplane == null) {
        await DatabaseHelper.instance.insertAirplane(newAirplane);
      } else {
        await DatabaseHelper.instance.updateAirplane(newAirplane);
      }
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  void _deleteAirplane() async {
    if (widget.airplane != null) {
      await DatabaseHelper.instance.deleteAirplane(widget.airplane!.id);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.airplane == null ? 'Add Airplane' : 'Edit Airplane'),
        actions: [
          if (widget.airplane != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Confirm Delete'),
                    content: Text('Are you sure you want to delete this airplane?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _deleteAirplane();
                          Navigator.of(context).pop();
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.airplane?.type ?? '',
                decoration: InputDecoration(labelText: 'Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a type';
                  }
                  return null;
                },
                onSaved: (value) {
                  _type = value!;
                },
              ),
              TextFormField(
                initialValue: widget.airplane?.passengers.toString() ?? '',
                decoration: InputDecoration(labelText: 'Passengers'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of passengers';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _passengers = int.parse(value!);
                },
              ),
              TextFormField(
                initialValue: widget.airplane?.maxSpeed.toString() ?? '',
                decoration: InputDecoration(labelText: 'Max Speed'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter max speed';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _maxSpeed = double.parse(value!);
                },
              ),
              TextFormField(
                initialValue: widget.airplane?.range.toString() ?? '',
                decoration: InputDecoration(labelText: 'Range'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter range';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _range = double.parse(value!);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text(widget.airplane == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
