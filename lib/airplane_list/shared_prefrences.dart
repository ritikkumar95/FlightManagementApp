

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';


import 'airplane.dart';

class SharedPrefsHelper {
  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  Future<void> saveAirplaneData(Airplane airplane) async {
    await _prefs.setString('type', airplane.type);
    await _prefs.setInt('passengers', airplane.passengers);
    await _prefs.setDouble('maxSpeed', airplane.maxSpeed);
    await _prefs.setDouble('range', airplane.range);
  }

  Future<Airplane?> getSavedAirplaneData() async {
    final type = await _prefs.getString('type');
    final passengers = await _prefs.getInt('passengers');
    final maxSpeed = await _prefs.getDouble('maxSpeed');
    final range = await _prefs.getDouble('range');

    if (type != null && passengers != null && maxSpeed != null && range != null) {
      return Airplane(type: type, passengers: passengers, maxSpeed: maxSpeed, range: range);
    }
    return null;
  }
}
