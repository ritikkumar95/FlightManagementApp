import 'package:flutter/material.dart';

import 'airplane.dart';
import 'airplane_form.dart';
import 'database_helper.dart';

class AirplaneListPage extends StatefulWidget {
  const AirplaneListPage({super.key});

  @override
  _AirplaneListPageState createState() => _AirplaneListPageState();
}

class _AirplaneListPageState extends State<AirplaneListPage> {
  late Future<List<Airplane>> _airplanesFuture;

  @override
  void initState() {
    super.initState();
    _loadAirplanes();
  }

  void _loadAirplanes() {
    setState(() {
      _airplanesFuture = DatabaseHelper.instance.getAirplanes();
    });
  }

  void _navigateToFormPage([Airplane? airplane]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AirplaneFormPage(airplane: airplane),
      ),
    ).then((_) => _loadAirplanes());
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Instructions'),
          content: const Text('Instructions on how to use the interface...'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Airplane List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: _showInstructions,
          ),
        ],
      ),
      body: FutureBuilder<List<Airplane>>(
        future: _airplanesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No airplanes available.'));
          } else {
            final airplanes = snapshot.data!;
            return ListView.builder(
              itemCount: airplanes.length,
              itemBuilder: (context, index) {
                final airplane = airplanes[index];
                return ListTile(
                  title: Text(airplane.type),
                  subtitle: Text('Passengers: ${airplane.passengers}'),
                  onTap: () => _navigateToFormPage(airplane),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToFormPage(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
