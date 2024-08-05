import 'package:flutter/material.dart';
import 'flight_detail_page.dart';
import 'flight.dart';
import 'database.dart';

class FlightListPage extends StatefulWidget {
  @override
  _FlightListPageState createState() => _FlightListPageState();
}

class _FlightListPageState extends State<FlightListPage> {
  late AppDatabase database;
  List<Flight> flights = [];
  Flight? selectedFlight;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _showFlights();
  }

  Future<void> _showFlights() async {
    final flightDao = database.flightDao;
    final flightList = await flightDao.findAllFlights();
    setState(() {
      flights = flightList;
    });
  }

  void _showInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Instructions'),
          content: Text(
              '1. Click on the "Add a Flight" button to enter details of a new flight.\n'
                  '2. To view flight details, tap on a flight from the list.\n'
                  '3. On a wide screen, flight details will be shown beside the list of flights.\n'
                  '4. Use the update and delete options in the details page to manage flights.'
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var isWideScreen = size.width > 720;

    return Scaffold(
      appBar: AppBar(
        title: Text('Flights List'),
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () => _showInstructions(context),
          ),
        ],
      ),
      body: isWideScreen
          ? Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildFlightList(context),
          ),
          if (selectedFlight != null)
            Expanded(
              flex: 2,
              child: FlightDetailsPage(
                flight: selectedFlight,
                onDelete: _onFlightDeleted,
                onUpdate: _onFlightUpdated,
              ),
            ),
        ],
      )
          : _buildFlightList(context),
      floatingActionButton: null,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FlightDetailsPage(onAdd: _onFlightAdded),
              ),
            ).then((_) => _showFlights());
          },
          child: Text('Add a Flight'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ),
    );
  }

  void _onFlightSelected(Flight flight) {
    setState(() {
      selectedFlight = flight;
    });
  }

  void _onFlightDeleted(Flight flight) async {
    await _showFlights();
    setState(() {
      selectedFlight = null;
    });
  }

  void _onFlightUpdated(Flight flight) async {
    await _showFlights();
    setState(() {
      selectedFlight = flight;
    });
  }

  void _onFlightAdded() async {
    await _showFlights();
    setState(() {
      selectedFlight = flights.last;
    });
  }

  Widget _buildFlightList(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: flights.length,
            itemBuilder: (context, index) {
              final flight = flights[index];
              return ListTile(
                leading: Text('${index + 1}'),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Departure City: ${flight.departureCity} ➔ Destination City: ${flight.destinationCity}'),
                    SizedBox(height: 4),
                    Text('Departure Time: ${flight.departureTime}'),
                    SizedBox(height: 4),
                    Text('Arrival Time: ${flight.arrivalTime}'),
                  ],
                ),
                onTap: () {
                  if (MediaQuery.of(context).size.width > 720) {
                    _onFlightSelected(flight);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlightDetailsPage(
                          flight: flight,
                          onDelete: _onFlightDeleted,
                          onUpdate: _onFlightUpdated,
                        ),
                      ),
                    ).then((_) => _showFlights());
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}