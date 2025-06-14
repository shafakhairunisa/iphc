// frontend\lib\config\user_preferences.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _userKey = 'user_data';

  static Future<void> saveUser(Map<String, dynamic> user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user);
      await prefs.setString(_userKey, userJson);
      print("DEBUG: Successfully saved user to preferences");
    } catch (e) {
      print("DEBUG: Error saving user preferences: $e");
    }
  }

  static Future<Map<String, dynamic>> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      
      if (userJson != null && userJson.isNotEmpty) {
        final Map<String, dynamic> userData = Map<String, dynamic>.from(jsonDecode(userJson));
        return userData;
      } else {
        // Return default user data if none exists
        return {
          'user_id': 1,
          'name': 'User',
          'username': 'user',
          'email': 'user@example.com',
          'birthday': '01/01/2000',
          'gender': 'Female',
          'height': '170',
          'weight': '50',
          'blood_type': 'A+',
          'allergies': '',
        };
      }
    } catch (e) {
      print("DEBUG: Error getting user preferences: $e");
      // Return default user data on error
      return {
        'user_id': 1,
        'name': 'User',
        'username': 'user',
        'email': 'user@example.com',
        'birthday': '01/01/2000',
        'gender': 'Female',
        'height': '170',
        'weight': '50',
        'blood_type': 'A+',
        'allergies': '',
      };
    }
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  static Future<List<String>?> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(key, value);
  }
}