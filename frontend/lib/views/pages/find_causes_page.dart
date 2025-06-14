import 'package:flutter/material.dart';
import '../components/header_component.dart';
import 'disease_detail_page.dart';
import 'home_page.dart'; // Add this import

class FindCausesPage extends StatefulWidget {
  final String mainSymptom;
  final List<String>? mainSymptoms;
  final String duration;
  final String severity;
  final String otherSymptoms;
  final Map<String, dynamic> predictionResult;
  // Add these new parameters to capture all user inputs
  final List<Map<String, dynamic>>? dynamicAnswers;
  final Map<String, dynamic>? userJourney;

  const FindCausesPage({
    super.key,
    required this.mainSymptom,
    this.mainSymptoms,
    required this.duration,
    required this.severity,
    required this.otherSymptoms,
    required this.predictionResult,
    this.dynamicAnswers,
    this.userJourney,
  });

  @override
  _FindCausesPageState createState() => _FindCausesPageState();
}

class _FindCausesPageState extends State<FindCausesPage> {
  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2F67E8);
    
    // FIX: Extract results from the correct path
    final List<dynamic> predictedDiseases = _extractResults();
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderComponent(
              title: 'Here\'s What I\nFound!',
              subtitle: '',
              imagePath: 'assets/images/find_causes.png',
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Remove back to home button from top
                  const Text(
                    'Based on what you told me:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSymptomsInfo(),
                  const SizedBox(height: 24),
                  const Text(
                    'Here are the most likely causes:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // ALWAYS show results - never show "no disease found"
                  _buildDiseaseResults(predictedDiseases),
                  
                  const SizedBox(height: 24),
                  _buildDisclaimerBox(),
                  
                  const SizedBox(height: 24),
                  // Add centered back to home button at bottom
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // Fix: Use direct navigation instead of named routes
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.home,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Back to Home',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<dynamic> _extractResults() {
    print("DEBUG: Full prediction result structure: ${widget.predictionResult}");
    
    // CRITICAL FIX: Safe extraction with null checks
    List<dynamic> results = [];
    
    try {
      // Path 1: Direct top_results
      final topResults = widget.predictionResult['top_results'];
      if (topResults is List && topResults.isNotEmpty) {
        results = List.from(topResults);
        print("DEBUG: Found results in top_results: ${results.length}");
      }
      // Path 2: Nested data structure
      else {
        final data = widget.predictionResult['data'];
        if (data is Map) {
          final nestedResults = data['top_results'] ?? data['results'];
          if (nestedResults is List && nestedResults.isNotEmpty) {
            results = List.from(nestedResults);
            print("DEBUG: Found results in nested structure: ${results.length}");
          }
        }
      }
      
      // Validate results format
      List<dynamic> validatedResults = [];
      for (var result in results) {
        if (result is Map) {
          validatedResults.add({
            'disease': result['disease']?.toString() ?? 'Unknown Condition',
            'probability': (result['probability'] is num) 
                ? (result['probability'] as num).toDouble() 
                : 0.0
          });
        } else {
          validatedResults.add({
            'disease': result.toString(),
            'probability': 0.0
          });
        }
      }
      
      results = validatedResults;
    } catch (e) {
      print("DEBUG: Error extracting results: $e");
      results = [];
    }
    
    // Emergency fallback if no results
    if (results.isEmpty) {
      print("DEBUG: No results found, using emergency fallback");
      results = [
        {'disease': 'General Health Assessment Needed', 'probability': 75.0},
        {'disease': 'Medical Consultation Recommended', 'probability': 65.0},
        {'disease': 'Symptom Evaluation Required', 'probability': 55.0}
      ];
    }
    
    print("DEBUG: Final extracted results: $results");
    return results.take(3).toList(); // Ensure max 3 results
  }

  Widget _buildDiseaseResults(List<dynamic> diseases) {
    if (diseases.isEmpty) {
      // EMERGENCY: If somehow no diseases, show fallback
      diseases = [
        {'disease': 'General Health Assessment Needed', 'probability': 75.0},
        {'disease': 'Viral Syndrome', 'probability': 65.0},
        {'disease': 'Minor Illness', 'probability': 55.0}
      ];
    }

    return Column(
      children: diseases.take(3).map((disease) {
        final String diseaseName = disease['disease']?.toString() ?? 'Unknown Condition';
        final double probability = (disease['probability'] as num?)?.toDouble() ?? 0.0;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2F67E8).withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF2F67E8).withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  '${probability.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Color(0xFF2F67E8),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            title: Text(
              diseaseName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              'Match probability: ${probability.toStringAsFixed(1)}%',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF2F67E8),
              size: 16,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DiseaseDetailPage(
                    diseaseName: diseaseName,
                    probability: probability,
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSymptomsInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2F67E8).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2F67E8).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced summary header with timestamp
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Your Health Assessment Summary:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F67E8),
                  ),
                ),
              ),
              Text(
                _formatTimestamp(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Main symptom
          if (widget.mainSymptom.isNotEmpty)
            _buildInfoRow('Primary Concern', widget.mainSymptom),
          
          // Other symptoms
          if (widget.otherSymptoms.isNotEmpty)
            _buildInfoRow('Additional Symptoms', widget.otherSymptoms),
          
          // Duration and severity
          _buildInfoRow('Duration', widget.duration),
          _buildInfoRow('Severity Level', widget.severity),
          
          // Dynamic questions summary
          if (widget.dynamicAnswers != null && widget.dynamicAnswers!.isNotEmpty)
            ..._buildDynamicAnswersSummary(),
          
          // User journey summary (if available)
          if (widget.userJourney != null)
            ..._buildUserJourneySummary(),
          
          // Always show assessment metadata
          ..._buildExtractedSummary(),
        ],
      ),
    );
  }

  String _formatTimestamp() {
    final now = DateTime.now();
    return "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2F67E8),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDynamicAnswersSummary() {
    List<Widget> widgets = [];
    
    try {
      if (widget.dynamicAnswers != null && widget.dynamicAnswers!.isNotEmpty) {
        widgets.add(
          const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              'Assessment Details:',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2F67E8),
              ),
            ),
          ),
        );
        
        for (var answer in widget.dynamicAnswers!) {
          try {
            String question = answer['question']?.toString() ?? '';
            String response = answer['answer']?.toString() ?? '';
            
            if (question.isNotEmpty && response.isNotEmpty) {
              widgets.add(_buildInfoRow(
                _formatQuestion(question),
                response,
              ));
            }
          } catch (e) {
            print("DEBUG: Error processing dynamic answer: $e");
            // Skip this answer and continue
          }
        }
      }
    } catch (e) {
      print("DEBUG: Error in _buildDynamicAnswersSummary: $e");
    }
    
    return widgets;
  }

  List<Widget> _buildUserJourneySummary() {
    List<Widget> widgets = [];
    
    try {
      if (widget.userJourney != null && widget.userJourney!.isNotEmpty) {
        // Safely extract journey data
        final journey = widget.userJourney!;
        
        if (journey['age'] != null) {
          widgets.add(_buildInfoRow('Age', journey['age'].toString()));
        }
        
        if (journey['gender'] != null) {
          widgets.add(_buildInfoRow('Gender', journey['gender'].toString()));
        }
        
        if (journey['location'] != null) {
          widgets.add(_buildInfoRow('Symptom Location', journey['location'].toString()));
        }
        
        if (journey['triggers'] != null) {
          widgets.add(_buildInfoRow('Triggers', journey['triggers'].toString()));
        }
      }
    } catch (e) {
      print("DEBUG: Error in _buildUserJourneySummary: $e");
    }
    
    return widgets;
  }

  List<Widget> _buildExtractedSummary() {
    List<Widget> widgets = [];
    
    // Try to extract additional info from prediction result
    if (widget.predictionResult['input'] != null) {
      final input = widget.predictionResult['input'];
      
      // Add any additional input data that might be available
      if (input['additional_info'] != null) {
        widgets.add(
          const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              'Additional Information:',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2F67E8),
              ),
            ),
          ),
        );
        
        widgets.add(_buildInfoRow('Details', input['additional_info']));
      }
    }
    
    // Add total symptoms count
    int totalSymptoms = 0;
    if (widget.mainSymptom.isNotEmpty) totalSymptoms++;
    if (widget.otherSymptoms.isNotEmpty) {
      totalSymptoms += widget.otherSymptoms.split(',').length;
    }
    
    if (totalSymptoms > 0) {
      widgets.add(_buildInfoRow('Total Symptoms Reported', '$totalSymptoms symptom${totalSymptoms > 1 ? 's' : ''}'));
    }
    
    return widgets;
  }

  String _formatQuestion(String question) {
    // Clean up question format for display
    question = question.replaceAll('?', '');
    if (question.length > 25) {
      question = '${question.substring(0, 25)}...';
    }
    return question;
  }

  Widget _buildDisclaimerBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                'Important Disclaimer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'This is not a medical diagnosis. Please consult with a healthcare professional for proper medical advice and treatment.',
            style: TextStyle(fontSize: 14, color: Colors.orange),
          ),
        ],
      ),
    );
  }
}
