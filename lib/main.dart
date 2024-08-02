import 'package:flutter/material.dart';
import 'customer_list/customer_list_page.dart';
import 'airplane_list/airplane_list_page.dart';
import 'flights_list/flights_list_page.dart';
import 'reservation/reservation_page.dart';

void main() {
  // Entry point of the application
  runApp(MyApp());
}

// The main application widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application title
      title: 'Flight Management App',
      // Application theme
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Home page of the application
      home: HomePage(),
      // Define the routes for navigation
      routes: {
        '/customerList': (context) => CustomerListPage(),
        '/airplaneList': (context) => AirplaneListPage(),
        '/flightsList': (context) => FlightsListPage(),
        '/reservation': (context) => ReservationPage(),
      },
    );
  }
}

// The home page of the application
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with the title
      appBar: AppBar(
        title: Text('Flight Management App'),
      ),
      // Main body content
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Button to navigate to Customer List Page
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/customerList');
              },
              child: Text('Customer List Page'),
            ),
            // Button to navigate to Airplane List Page
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/airplaneList');
              },
              child: Text('Airplane List Page'),
            ),
            // Button to navigate to Flights List Page
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/flightsList');
              },
              child: Text('Flights List Page'),
            ),
            // Button to navigate to Reservation Page
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/reservation');
              },
              child: Text('Reservation Page'),
            ),
          ],
        ),
      ),
    );
  }
}
