import 'package:flutter/material.dart';
import 'package:ipho/views/pages/symptom_category_page.dart';
import '../components/header_component.dart';

class CheckerFirstPage extends StatefulWidget {
  const CheckerFirstPage({super.key});

  @override
  _CheckerFirstPageState createState() => _CheckerFirstPageState();
}

class _CheckerFirstPageState extends State<CheckerFirstPage> {
  final List<Map<String, dynamic>> symptomCategories = [
    {
      'title': 'General Symptoms',
      'icon': Icons.local_hospital, // More medical-looking
      'items': ['Fever', 'Fatigue', 'Chills', 'Sweating', 'Weight loss', 'Weight gain', 'Lethargy', 'Malaise', 'Dehydration'],
    },
    {
      'title': 'Head and Neck',
      'icon': Icons.person, // Head/person icon
      'items': ['Headache', 'Sore throat', 'Difficulty swallowing', 'Neck pain', 'Stiff neck', 'Dizziness', 'Loss of smell'],
    },
    {
      'title': 'Respiratory Symptoms',
      'icon': Icons.coronavirus, // Lung/breathing icon
      'items': ['Cough', 'Shortness of breath', 'Nasal congestion', 'Chest pain', 'Throat irritation', 'Phlegm', 'Runny nose', 'Sinus pressure'],
    },
    {
      'title': 'Skin Symptoms',
      'icon': Icons.back_hand, // Hand represents skin
      'items': ['Itching', 'Skin rash', 'Yellowish skin', 'Red spots over body', 'Bruising', 'Skin peeling', 'Blister', 'Blackheads'],
    },
    {
      'title': 'Digestive Symptoms',
      'icon': Icons.set_meal, // Better stomach/food icon
      'items': ['Stomach pain', 'Nausea', 'Vomiting', 'Diarrhea', 'Constipation', 'Abdominal pain', 'Acidity', 'Indigestion', 'Loss of appetite'],
    },
    {
      'title': 'Neurological Symptoms',
      'icon': Icons.psychology_alt, // Brain icon
      'items': ['Headache', 'Dizziness', 'Blurred vision', 'Spinning movements', 'Loss of balance', 'Unsteadiness', 'Slurred speech', 'Muscle weakness'],
    },
    {
      'title': 'Musculoskeletal Symptoms',
      'icon': Icons.accessibility_new, // Body/skeleton icon
      'items': ['Joint pain', 'Muscle pain', 'Back pain', 'Knee pain', 'Hip joint pain', 'Swelling joints', 'Movement stiffness', 'Muscle wasting'],
    },
    {
      'title': 'Urinary Symptoms',
      'icon': Icons.water_drop_outlined, // Water drop outline
      'items': ['Burning micturition', 'Frequent urination', 'Bladder discomfort', 'Foul smell of urine', 'Continuous feel of urine', 'Dark urine'],
    },
    {
      'title': 'Eye Symptoms',
      'icon': Icons.remove_red_eye, // Eye icon
      'items': ['Redness of eyes', 'Watering from eyes', 'Yellowing of eyes', 'Blurred and distorted vision', 'Pain behind the eyes', 'Visual disturbances'],
    },
    {
      'title': 'Mental Health',
      'icon': Icons.sentiment_satisfied_alt, // Happy face for mental health
      'items': ['Anxiety', 'Depression', 'Mood swings', 'Restlessness', 'Irritability', 'Lack of concentration'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2F67E8);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderComponent(
              title: 'Hi!\nLet me help you.',
              subtitle: '',
              imagePath: 'assets/images/checker_first.png',
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Which area describes your symptoms best?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: symptomCategories.length,
                    itemBuilder: (context, index) {
                      final category = symptomCategories[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SymptomCategoryPage(
                                  category: category,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  category['icon'],
                                  size: 40,
                                  color: primaryColor,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  category['title'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}