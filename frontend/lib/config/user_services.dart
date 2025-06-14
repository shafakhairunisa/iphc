import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api.dart';
import 'user_preferences.dart'; // ADDED: Missing import

class UserService {
  Future<bool> login(String username, String password) async {
    try {
      // Use Config.baseURL so you only need to change IP in one place
      final response = await http.post(
        Uri.parse('${Config.baseURL}/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": username, "password": password}),
      );

      print("DEBUG: Login URL: ${Config.baseURL}/users/login");
      print("DEBUG: Response status: ${response.statusCode}");
      print("DEBUG: Response body: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("DEBUG: Login error: $e");
      return false;
    }
  }
}

class UserServices {
  static Future<Map<String, dynamic>> updateUser(
    int userId,
    Map<String, dynamic> userData,
  ) async {
    try {
      print("DEBUG: Updating user $userId");
      print("DEBUG: Request body keys: ${userData.keys.toList()}");

      final response = await http.put(
        Uri.parse('${Config.baseURL}/users/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      print("DEBUG: Response status: ${response.statusCode}");
      print("DEBUG: Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);

        // FIXED: Safe null checking for nested user data
        if (result['success'] == true && result['user'] != null) {
          // Update local user preferences with the returned user data
          final Map<String, dynamic> updatedUser = Map<String, dynamic>.from(result['user']);
          await UserPreferences.saveUser(updatedUser);
          print("DEBUG: Successfully updated local user preferences");

          return {
            'success': true,
            'message': result['message'] ?? 'Profile updated successfully',
            'user': updatedUser
          };
        } else {
          return {
            'success': false,
            'message': result['message'] ?? 'Update failed',
            'user': null
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
          'user': null
        };
      }
    } catch (e) {
      print("DEBUG: Update user error: $e");
      return {
        'success': false,
        'message': 'Network error: $e',
        'user': null
      };
    }
  }

  // ...existing code...
}