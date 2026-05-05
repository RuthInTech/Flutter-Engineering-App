import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chem_record.dart';

class StorageService {
  static const String _key = 'chem_history';

  static Future<void> saveRecord(ChemRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_key) ?? [];
    history.add(jsonEncode(record.toJson()));
    await prefs.setStringList(_key, history);
  }

  static Future<List<ChemRecord>> getRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_key) ?? [];
    return history
        .map((item) => ChemRecord.fromJson(jsonDecode(item)))
        .toList()
        .reversed
        .toList();
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}