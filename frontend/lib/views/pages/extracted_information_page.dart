// frontend/lib/views/pages/extracted_information_page.dart
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import '../../config/user_preferences.dart';
import '../../config/document_services.dart';

class ExtractedInformationPage extends StatelessWidget {
  final String filePath;

  const ExtractedInformationPage({super.key, required this.filePath});

  static Future<void> saveUploadedFileHistory({
    required String filePath,
    required String extractedText,
  }) async {
    try {
      // Get user data for user_id
      final userData = await UserPreferences.getUser();
      final userId = userData['user_id'] ?? userData['id'] ?? 1;
      
      // Extract filename and file type
      final filename = filePath.split(Platform.pathSeparator).last;
      final fileType = filename.split('.').last.toLowerCase();
      
      print("DEBUG: Saving document - User ID: $userId, Filename: $filename");
      
      // Save to backend
      final result = await DocumentServices.uploadDocument(
        userId: userId,
        filename: filename,
        fileContent: extractedText,
        fileType: fileType,
      );
      
      if (result['success'] == true) {
        print("DEBUG: Document saved successfully with ID: ${result['document_id']}");
      } else {
        print("DEBUG: Failed to save document: ${result['message']}");
      }
      
      // Also save to local storage for backward compatibility
      final history = await UserPreferences.getStringList('uploaded_files_history') ?? [];
      final entry = {
        'type': 'file',
        'filePath': filePath,
        'fileName': filename,
        'extractedText': extractedText,
        'uploadedAt': DateTime.now().toIso8601String(),
        'document_id': result['document_id'], // Add document ID for reference
      };
      history.add(jsonEncode(entry));
      await UserPreferences.setStringList('uploaded_files_history', history);
      
      print("DEBUG: Document saved to both backend and local storage");
    } catch (e) {
      print("DEBUG: Error saving file history: $e");
    }
  }

  Future<String> _readFileContent() async {
    final ext = filePath.split('.').last.toLowerCase();
    try {
      if (ext == 'txt') {
        return await File(filePath).readAsString();
      }
      return 'Unsupported file format - only TXT files are supported';
    } catch (e) {
      return 'Error reading file: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F67E8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Extracted Information',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<String>(
        future: _readFileContent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final extractedText = snapshot.data ?? 'No content extracted';
          
          // Auto-save the document when content is loaded
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await saveUploadedFileHistory(
              filePath: filePath,
              extractedText: extractedText,
            );
          });
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.description, color: Color(0xFF2F67E8), size: 24),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              filePath.split(Platform.pathSeparator).last,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Extracted Content:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2F67E8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        extractedText,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Document saved successfully! You can view it in the History page.',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}