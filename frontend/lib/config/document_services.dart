import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api.dart';

class DocumentServices {
  static Future<Map<String, dynamic>> uploadDocument({
    required int userId,
    required String filename,
    required String fileContent,
    required String fileType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.baseURL}/documents/upload'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'filename': filename,
          'file_content': fileContent,
          'file_type': fileType,
        }),
      );

      print("DEBUG: Upload response status: ${response.statusCode}");
      print("DEBUG: Upload response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'document_id': data['document_id'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to upload document',
        };
      }
    } catch (e) {
      print("DEBUG: Error uploading document: $e");
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getUserDocuments(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${Config.baseURL}/documents/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final documents = json.decode(response.body);
        return {
          'success': true,
          'documents': documents,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch documents',
          'documents': [],
        };
      }
    } catch (e) {
      print("DEBUG: Error fetching documents: $e");
      return {
        'success': false,
        'message': e.toString(),
        'documents': [],
      };
    }
  }

  static Future<Map<String, dynamic>> deleteDocument(int documentId, int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('${Config.baseURL}/documents/$documentId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Document deleted successfully',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to delete document',
        };
      }
    } catch (e) {
      print("DEBUG: Error deleting document: $e");
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getDocument(int documentId) async {
    try {
      final response = await http.get(
        Uri.parse('${Config.baseURL}/documents/$documentId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'document': json.decode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch document',
        };
      }
    } catch (e) {
      print("DEBUG: Error fetching document: $e");
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
}
