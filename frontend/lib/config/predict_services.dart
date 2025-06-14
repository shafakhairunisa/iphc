import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api.dart';
import 'user_preferences.dart';

class PredictServices {
  static Future<Map<String, dynamic>> predictDisease({
    required int userId,
    required List<String> symptoms,
    required String duration,
    required String severity,
    List<Map<String, dynamic>>? dynamicAnswers,
    Map<String, dynamic>? userJourney,
  }) async {
    // Fix: Use trailing slash to match backend expectation
    final url = '${Config.baseURL}/predict/';
    final requestBody = {
      "user_id": userId,
      "symptoms": symptoms,
      "duration": duration,
      "severity": severity,
      "dynamic_answers": dynamicAnswers ?? [],
      "user_journey": userJourney ?? {},
      "timestamp": DateTime.now().toIso8601String(),
    };
    
    print("DEBUG: Sending prediction request to: $url");
    print("DEBUG: Request body: $requestBody");
    
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      
      print("DEBUG: Response status code: ${response.statusCode}");
      print("DEBUG: Response body: ${response.body}");
      
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result;
      } else {
        throw Exception('Server error: ${response.statusCode} - ${response.body}');
      }
      
    } catch (e) {
      print("DEBUG: Prediction service error: $e");
      throw Exception('Failed to get prediction: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getUserPredictions(int userId) async {
    final url = '${Config.baseURL}/predict/$userId/';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 307 && response.headers.containsKey('location')) {
      final redirectUrl = response.headers['location']!;
      final redirectResponse = await http.get(
        Uri.parse(redirectUrl),
        headers: {'Content-Type': 'application/json'},
      );
      if (redirectResponse.body.isEmpty) {
        return [];
      }
      final data = jsonDecode(redirectResponse.body);
      if (data['success'] == true) {
        return (data['data'] as List).map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw Exception(data['message'] ?? 'Failed to get predictions');
      }
    }
    if (response.body.isEmpty) {
      return [];
    }
    final data = jsonDecode(response.body);
    if (data['success'] == true) {
      return (data['data'] as List).map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception(data['message'] ?? 'Failed to get predictions');
    }
  }

  static Future<Map<String, dynamic>> getPredictionByUserId(int userId) async {
    final url = '${Config.baseURL}/predict/$userId';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 307 && response.headers.containsKey('location')) {
      final redirectUrl = response.headers['location']!;
      final redirectResponse = await http.get(
        Uri.parse(redirectUrl),
        headers: {'Content-Type': 'application/json'},
      );
      if (redirectResponse.body.isEmpty) {
        throw Exception('Empty response from server after redirect');
      }
      return jsonDecode(redirectResponse.body);
    }
    if (response.body.isEmpty) {
      throw Exception('Empty response from server');
    }
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getBatchDiseaseInfo(List<String> diseases) async {
    final url = '${Config.baseURL}/info/batch';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'diseases': diseases}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? {};
    } else {
      throw Exception('Failed to fetch batch disease info');
    }
  }

  static Future<Map<String, dynamic>> testMedicalLogic() async {
    try {
      final response = await http.get(
        Uri.parse('${Config.baseURL}/predict/test-medical-logic'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to run medical logic test');
      }
    } catch (e) {
      throw Exception('Error running test: $e');
    }
  }

  static Future<Map<String, dynamic>> testSpecificSymptoms(List<String> symptoms) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.baseURL}/predict/test-symptoms'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'symptoms': symptoms}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to test symptoms');
      }
    } catch (e) {
      throw Exception('Error testing symptoms: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getUserPredictionHistory(int userId) async {
    try {
      final url = '${Config.baseURL}/predict/history/$userId';
      print("DEBUG: Fetching history from: $url");
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      
      print("DEBUG: History response status: ${response.statusCode}");
      print("DEBUG: History response body: ${response.body}");
      
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print("DEBUG: Parsed result: $result");
        
        // CRITICAL FIX: Handle multiple possible response structures
        if (result['success'] == true) {
          List<dynamic> predictionsList;
          
          // Try different possible field names
          if (result['predictions'] != null) {
            predictionsList = result['predictions'];
            print("DEBUG: Found predictions field with ${predictionsList.length} items");
          } else if (result['data'] != null) {
            predictionsList = result['data'];
            print("DEBUG: Found data field with ${predictionsList.length} items");
          } else {
            print("DEBUG: No predictions or data field found");
            return [];
          }
          
          // Convert to proper type
          final List<Map<String, dynamic>> predictions = predictionsList
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
          
          print("DEBUG: Successfully converted ${predictions.length} predictions");
          return predictions;
        } else {
          print("DEBUG: Response success was false: ${result['error'] ?? 'Unknown error'}");
        }
      } else {
        print("DEBUG: HTTP error ${response.statusCode}: ${response.body}");
      }
      
      // Return empty list if no history found
      return [];
      
    } catch (e) {
      print("DEBUG: Error fetching prediction history: $e");
      return [];
    }
  }

  static Future<Map<String, dynamic>> deletePrediction(int predictId, [int? userId]) async {
    try {
      final userData = await UserPreferences.getUser();
      final token = userData['access_token'] ?? '';

      final response = await http.delete(
        Uri.parse('${Config.baseURL}/predict/$predictId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Assessment deleted successfully',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to delete assessment',
        };
      }
    } catch (e) {
      print("DEBUG: Error deleting assessment: $e");
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
}
