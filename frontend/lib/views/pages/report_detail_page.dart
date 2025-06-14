import 'package:flutter/material.dart';

class ReportDetailPage extends StatelessWidget {
  final Map<String, dynamic> record;

  const ReportDetailPage({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2F67E8);
    final input = record['input'] as Map<String, dynamic>? ?? {};
    final mainSymptom = input['main_symptom']?.toString() ?? '';
    final otherSymptomsList = input['other_symptoms'] as List<dynamic>? ?? [];
    final otherSymptoms = otherSymptomsList.map((e) => e.toString()).join(', ');
    final duration = input['duration']?.toString() ?? '';
    final severity = input['severity']?.toString() ?? '';
    final topResults = record['top_results'] as List<dynamic>? ?? [];

    final resultsText = topResults.map((r) {
      final disease = r['disease']?.toString() ?? '';
      final probability = (r['probability'] as num?)?.toStringAsFixed(0) ?? '0';
      return '• $disease ($probability%)';
    }).join('\n');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Report Details',
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: primaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.insert_drive_file, color: primaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Prediction ID: ${record['predict_id']}\n\n'
                        'Main Symptom: $mainSymptom\n'
                        'Other Symptoms: ${otherSymptoms.isNotEmpty ? otherSymptoms : '-'}\n\n'
                        'Duration: $duration\n'
                        'Severity: $severity\n\n'
                        'Top Results:\n'
                        '$resultsText',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Image.asset(
              'assets/icons/ipho.png',
              width: 50,
              height: 50,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}