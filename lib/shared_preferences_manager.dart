import 'package:shared_preferences/shared_preferences.dart';

enum Mode {
  rejected("rejected"),
  accepted("accepted");

  final String value;
  const Mode(this.value);
}

Future<void> savePrefs(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();

  prefs.setStringList(key, (prefs.getStringList(key) ?? [])..add(value));
}

Future<List<String>> loadPrefs(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(key) ?? [];
}
