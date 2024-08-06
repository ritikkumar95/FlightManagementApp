import 'package:flight_management_app/reservation/reservation_database_helper.dart';
import 'package:flight_management_app/reservation/reservation_list_page.dart';
import 'package:flutter/material.dart';

import 'airplane_list/airplane_list_page.dart';
import 'customer_list/customer_database_helper.dart';
import 'customer_list/customer_list_page.dart';
import 'flights_list/flight_list_page.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CustomerDatabaseHelper.instance.database;
  await ReservationDatabaseHelper.instance.database;
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: const HomePage(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('fr', ''),
      ],
      routes: {
        '/customerList': (context) => const CustomerListPage(),
        '/airplaneList': (context) => const AirplaneListPage(),
        '/flightsList': (context) => const FlightListPage(),
        '/reservation': (context) => const ReservationListPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  //String _imageSource = 'images/airplane.jpg';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Management App'),
      ),
      body: Stack(
        children: [
          // Container(
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage (_imageSource),
          //      fit: BoxFit.cover,
          //     )
          //   ),
          // ),


          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/customerList');
                  },
                  child: const Text('Customer List Page'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/airplaneList');
                  },
                  child: const Text('Airplane List Page'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/flightsList');
                  },
                  child: const Text('Flights List Page'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/reservation');
                  },
                  child: const Text('Reservation Page'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}