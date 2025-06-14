import 'package:flutter/material.dart';
import 'package:ipho/views/pages/find_causes_page.dart';
import '../components/header_component.dart';
import '../../config/predict_services.dart';
import '../../config/user_preferences.dart';
import '../../config/symptom_questions.dart';

class CheckerSecondPage extends StatefulWidget {
  final List<String> selectedSymptoms;

  const CheckerSecondPage({super.key, required this.selectedSymptoms});

  @override
  _CheckerSecondPageState createState() => _CheckerSecondPageState();
}

class _CheckerSecondPageState extends State<CheckerSecondPage> {
  Map<String, String?> selectedAnswers = {};
  Set<String> selectedOtherSymptoms = {}; // New: for multiple other symptoms
  bool isLoading = false;
  late List<Map<String, dynamic>> questionCategories;

  @override
  void initState() {
    super.initState();
    // Load dynamic questions based on main symptom
    String mainSymptom = widget.selectedSymptoms.isNotEmpty
        ? widget.selectedSymptoms[0]
        : '';
    questionCategories = SymptomQuestions.getQuestionsForSymptom(mainSymptom);
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2F67E8);
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const HeaderComponent(
                  title: "Great!\nlet's narrow\nthings down.",
                  subtitle: '',
                  imagePath: 'assets/images/checker_first.png',
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selected Symptoms:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.selectedSymptoms.map((symptom) {
                          return Chip(
                            label: Text(symptom),
                            backgroundColor: primaryColor.withOpacity(0.1),
                            labelStyle: const TextStyle(color: primaryColor),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Select the factors that apply to you.',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...questionCategories.asMap().entries.map((entry) {
                        Map<String, dynamic> category = entry.value;
                        String categoryTitle = category['title'];
                        
                        // Check if this is the "other symptoms" question
                        bool isOtherSymptomsQuestion = categoryTitle.startsWith('Do you experience any of these alongside');
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              categoryTitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            
                            // Use checkboxes for other symptoms, radio buttons for everything else
                            if (isOtherSymptomsQuestion) ...[
                              ...category['items'].map((item) {
                                return CheckboxListTile(
                                  title: Text(item),
                                  value: selectedOtherSymptoms.contains(item),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedOtherSymptoms.add(item);
                                      } else {
                                        selectedOtherSymptoms.remove(item);
                                      }
                                    });
                                  },
                                  activeColor: primaryColor,
                                  controlAffinity: ListTileControlAffinity.leading,
                                );
                              }).toList(),
                            ] else ...[
                              ...category['items'].map((item) {
                                return RadioListTile<String>(
                                  title: Text(item),
                                  value: item,
                                  groupValue: selectedAnswers[categoryTitle],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedAnswers[categoryTitle] = value;
                                    });
                                  },
                                  activeColor: primaryColor,
                                );
                              }).toList(),
                            ],
                            const SizedBox(height: 16),
                          ],
                        );
                      }),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _areAllQuestionsAnswered()
                            ? () {
                                _predictDisease();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: _areAllQuestionsAnswered()
                              ? primaryColor
                              : Colors.grey,
                        ),
                        child: const Text(
                          'Find Causes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Analyzing your symptoms...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool _areAllQuestionsAnswered() {
    // Check if all non-other-symptoms questions are answered
    return questionCategories.where((category) => 
        !category['title'].toString().startsWith('Do you experience any of these alongside')
    ).every((category) => 
        selectedAnswers[category['title']] != null
    );
    // Note: Other symptoms are optional, so we don't require them
  }

  String? _getDuration() {
    return selectedAnswers['How long have you been feeling this way?'];
  }

  String? _getSeverity() {
    return selectedAnswers['How bad does it feel right now?'];
  }

  String? _getOtherSymptoms() {
    // Convert set to comma-separated string for backend compatibility
    return selectedOtherSymptoms.isNotEmpty 
        ? selectedOtherSymptoms.join(', ') 
        : null;
  }

  Future<void> _predictDisease() async {
    List<String> allSymptoms = [...widget.selectedSymptoms];

    // Add selected other symptoms
    if (selectedOtherSymptoms.isNotEmpty) {
      for (String symptom in selectedOtherSymptoms) {
        if (!allSymptoms.contains(symptom)) {
          allSymptoms.add(symptom);
        }
      }
    }

    String? duration = _getDuration();
    String formattedDuration = duration!;
    if (duration == '1–3 days') {
      formattedDuration = '1-3 days';
    } else if (duration == '4–7 days') {
      formattedDuration = '4-7 days';
    }

    setState(() {
      isLoading = true;
    });

    try {
      final userData = await UserPreferences.getUser();
      final userId = userData['user_id'] ?? 0;

      if (userId == 0) {
        throw Exception('User not logged in');
      }

      final predictionResult = await PredictServices.predictDisease(
        userId: userId,
        symptoms: allSymptoms.map((s) => s.toLowerCase()).toList(),
        duration: formattedDuration,
        severity: _getSeverity()!,
      );

      if (mounted) {
        setState(() {
          isLoading = false;
        });

        if (predictionResult['success'] == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FindCausesPage(
                mainSymptom: widget.selectedSymptoms.isNotEmpty
                    ? widget.selectedSymptoms[0]
                    : "",
                mainSymptoms: widget.selectedSymptoms,
                duration: duration,
                severity: _getSeverity()!,
                otherSymptoms: _getOtherSymptoms() ?? '',
                predictionResult: predictionResult,
              ),
            ),
          );
        } else {
          throw Exception(predictionResult['message'] ??
              'Failed to get prediction results');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
}