import 'package:flight_management_app/reservation/reservation_list_page.dart';
import 'package:flutter/material.dart';

import 'airplane_list/airplane_list_page.dart';
import 'customer_list/customer_list_page.dart';
import 'flights_list/flight_list_page.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: HomePage(),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('fr', ''),
      ],
      routes: {
        '/customerList': (context) => CustomerListPage(),
        '/airplaneList': (context) => AirplaneListPage(),
        '/flightsList': (context) => FlightListPage(),
        '/reservation': (context) => ReservationListPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Management App'),
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              'assets/images/airplane.jpg',
              fit: BoxFit.cover, // Cover the entire background
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/customerList');
                  },
                  child: Text('Customer List Page'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/airplaneList');
                  },
                  child: Text('Airplane List Page'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/flightsList');
                  },
                  child: Text('Flights List Page'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/reservation');
                  },
                  child: Text('Reservation Page'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}