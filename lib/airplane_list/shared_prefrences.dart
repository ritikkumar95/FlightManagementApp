import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'airplane.dart';

class SharedPrefsHelper {
  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  Future<void> saveAirplaneData(Airplane airplane) async {
    await _prefs.setString('type', airplane.type);
    await _prefs.setString('passengers', airplane.passengers.toString());
    await _prefs.setString('maxSpeed', airplane.maxSpeed.toString());
    await _prefs.setString('range', airplane.range.toString());
  }

  Future<Airplane?> getSavedAirplaneData() async {
    final type = await _prefs.getString('type');
    final passengersStr = await _prefs.getString('passengers');
    final maxSpeedStr = await _prefs.getString('maxSpeed');
    final rangeStr = await _prefs.getString('range');

    if (type != null &&
        passengersStr != null &&
        maxSpeedStr != null &&
        rangeStr != null) {
      final passengers = int.tryParse(passengersStr);
      final maxSpeed = double.tryParse(maxSpeedStr);
      final range = double.tryParse(rangeStr);

      if (passengers != null && maxSpeed != null && range != null) {
        return Airplane(
          type: type,
          passengers: passengers,
          maxSpeed: maxSpeed,
          range: range,
        );
      }
    }
    return null;
  }
}
