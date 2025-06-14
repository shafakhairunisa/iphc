import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api.dart';
import 'user_preferences.dart';

class Services {
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print("DEBUG: Attempting login with email: $email");
      
      final response = await http.post(
        Uri.parse('${Config.baseURL}/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("DEBUG: Login response status: ${response.statusCode}");
      print("DEBUG: Login response body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Your backend returns the user data in 'user' field, not 'data'
        final userData = data['user'];
        if (userData != null) {
          await UserPreferences.saveUser(userData);
          print("DEBUG: User data saved successfully");
          return data;
        } else {
          throw Exception('No user data received from server');
        }
      } else {
        throw Exception(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      print("DEBUG: Login error: $e");
      throw Exception('Login failed: $e');
    }
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.baseURL}/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name,
          "username": username,
          "email": email,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Handle both 'data' and 'user' response formats
        final userData = data['user'] ?? data['data'];
        if (userData != null) {
          await UserPreferences.saveUser(userData);
          return data;
        } else {
          throw Exception('No user data received from server');
        }
      } else {
        throw Exception(data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      print("DEBUG: Registration error: $e");
      throw Exception('Registration failed: $e');
    }
  }

  static Future<Map<String, dynamic>> getUserById(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${Config.baseURL}/users/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Handle both 'data' and 'user' response formats
        final userData = data['user'] ?? data['data'];
        if (userData != null) {
          await UserPreferences.saveUser(userData);
          return data;
        } else {
          throw Exception('No user data received from server');
        }
      } else {
        throw Exception(data['message'] ?? 'Failed to retrieve user data');
      }
    } catch (e) {
      print("DEBUG: Get user error: $e");
      throw Exception('Failed to retrieve user data: $e');
    }
  }

  static Future<Map<String, dynamic>> updateUser({
    required int userId,
    required String name,
    required String username,
    required String email,
    required int weight,
    required int height,
    required String birthday,
    String? photo,
    String? gender,
    String? allergies,
    String? bloodType,
  }) async {
    try {
      print("DEBUG: Updating user $userId");
      
      final requestBody = {
        "name": name,
        "username": username,
        "email": email,
        "weight": weight,
        "height": height,
        "birthday": birthday,
        "gender": gender,
        "allergies": allergies,
        "blood_type": bloodType,
      };
      
      if (photo != null && photo.isNotEmpty) {
        requestBody["photo"] = photo;
        print("DEBUG: Adding photo to request (${photo.length} characters)");
      }
      
      print("DEBUG: Request body keys: ${requestBody.keys.toList()}");
      
      final response = await http.put(
        Uri.parse('${Config.baseURL}/users/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      
      print("DEBUG: Response status: ${response.statusCode}");
      print("DEBUG: Response body: ${response.body}");
      
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Handle both 'data' and 'user' response formats
        final userData = data['user'] ?? data['data'];
        if (userData != null) {
          await UserPreferences.saveUser(userData);
          return data;
        } else {
          throw Exception('No user data received from server');
        }
      } else {
        throw Exception(data['message'] ?? 'Failed to update user data');
      }
    } catch (e) {
      print("DEBUG: Update user error: $e");
      throw Exception('Failed to update user data: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllergies() async {
    try {
      final response = await http.get(
        Uri.parse('${Config.baseURL}/allergies'),
        headers: {'Content-Type': 'application/json'},
      );

      print("DEBUG: Allergies response status: ${response.statusCode}");
      print("DEBUG: Allergies response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Handle both response formats
        if (data is List) {
          // Direct array response
          return data.map((allergy) => allergy as Map<String, dynamic>).toList();
        } else if (data is Map && data['success'] == true && data['data'] != null) {
          // Wrapped response
          List<dynamic> allergiesData = data['data'];
          return allergiesData.map((allergy) => allergy as Map<String, dynamic>).toList();
        } else {
          print("DEBUG: Invalid response format: $data");
          return [];
        }
      } else {
        print("DEBUG: HTTP error ${response.statusCode}: ${response.body}");
        return [];
      }
    } catch (e) {
      print("DEBUG: Exception in getAllergies: $e");
      return [];
    }
  }

  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      print("DEBUG: Sending forgot password request for: $email");
      
      final response = await http.post(
        Uri.parse('${Config.baseURL}/users/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email}),
      );

      print("DEBUG: Forgot password response status: ${response.statusCode}");
      print("DEBUG: Forgot password response body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Print OTP in debug mode for testing
        if (data.containsKey('otp')) {
          print('DEBUG: OTP received: ${data['otp']}');
        }
        return data;
      } else {
        throw Exception(data['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      print("DEBUG: Forgot password error: $e");
      throw Exception('Failed to send OTP: $e');
    }
  }

  static Future<Map<String, dynamic>> verifyOTP({
    required String email,
    required String otpCode,
  }) async {
    try {
      print("DEBUG: Verifying OTP for: $email");
      
      final response = await http.post(
        Uri.parse('${Config.baseURL}/users/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "otp_code": otpCode,
        }),
      );

      print("DEBUG: Verify OTP response status: ${response.statusCode}");
      print("DEBUG: Verify OTP response body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Invalid or expired OTP');
      }
    } catch (e) {
      print("DEBUG: Verify OTP error: $e");
      throw Exception('OTP verification failed: $e');
    }
  }

  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      print("DEBUG: Resetting password for: $email");
      
      final response = await http.post(
        Uri.parse('${Config.baseURL}/users/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "new_password": newPassword,
        }),
      );

      print("DEBUG: Reset password response status: ${response.statusCode}");
      print("DEBUG: Reset password response body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Failed to reset password');
      }
    } catch (e) {
      print("DEBUG: Reset password error: $e");
      throw Exception('Password reset failed: $e');
    }
  }

  // Prediction-related methods
  static Future<Map<String, dynamic>> createPrediction({
    required Map<String, dynamic> predictionData,
  }) async {
    try {
      print("DEBUG: Creating prediction with data: ${predictionData.keys}");
      
      final response = await http.post(
        Uri.parse('${Config.baseURL}/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(predictionData),
      );

      print("DEBUG: Create prediction response status: ${response.statusCode}");
      print("DEBUG: Create prediction response body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Failed to create prediction');
      }
    } catch (e) {
      print("DEBUG: Create prediction error: $e");
      throw Exception('Failed to create prediction: $e');
    }
  }

  static Future<Map<String, dynamic>> getPrediction(int predictionId) async {
    try {
      final response = await http.get(
        Uri.parse('${Config.baseURL}/predict/$predictionId'),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Failed to get prediction');
      }
    } catch (e) {
      print("DEBUG: Get prediction error: $e");
      throw Exception('Failed to get prediction: $e');
    }
  }

  static Future<Map<String, dynamic>> updatePrediction({
    required int predictionId,
    required Map<String, dynamic> predictionData,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${Config.baseURL}/predict/$predictionId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(predictionData),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Failed to update prediction');
      }
    } catch (e) {
      print("DEBUG: Update prediction error: $e");
      throw Exception('Failed to update prediction: $e');
    }
  }

  static Future<Map<String, dynamic>> deletePrediction(int predictionId) async {
    try {
      print("DEBUG: Deleting prediction $predictionId");
      
      final response = await http.delete(
        Uri.parse('${Config.baseURL}/predict/$predictionId'),
        headers: {'Content-Type': 'application/json'},
      );

      print("DEBUG: Delete prediction response status: ${response.statusCode}");
      print("DEBUG: Delete prediction response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Failed to delete prediction');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: Failed to delete prediction');
      }
    } catch (e) {
      print("DEBUG: Delete prediction error: $e");
      throw Exception('Failed to delete prediction: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllPredictions() async {
    try {
      final response = await http.get(
        Uri.parse('${Config.baseURL}/predict'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          return data.map((prediction) => prediction as Map<String, dynamic>).toList();
        } else if (data is Map && data['success'] == true && data['data'] != null) {
          List<dynamic> predictionsData = data['data'];
          return predictionsData.map((prediction) => prediction as Map<String, dynamic>).toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      print("DEBUG: Get all predictions error: $e");
      return [];
    }
  }

  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.baseURL}/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print("DEBUG: Login response status: ${response.statusCode}");
      print("DEBUG: Login response body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Login failed with status ${response.statusCode}'
        };
      }
    } catch (e) {
      print("DEBUG: Login error: $e");
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }
}