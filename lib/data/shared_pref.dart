import 'package:shared_preferences/shared_preferences.dart';

stringSavePref(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

intSavePref(String key, int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(key, value);
}

boolSavePref(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
}

getStringValuesPref(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String stringValue = prefs.getString(key) ?? "";
  return stringValue;
}

getBoolValuesPref(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool boolValue = prefs.getBool(key) ?? false;
  return boolValue;
}

getIntValuesPref(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int intValue = prefs.getInt(key) ?? 0;
  return intValue;
}

isInPref(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool checkValue = prefs.containsKey(key);
  return checkValue;
}
