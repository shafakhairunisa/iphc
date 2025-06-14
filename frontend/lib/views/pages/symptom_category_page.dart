import 'package:flutter/material.dart';
import 'package:ipho/views/pages/checker_second_page.dart';

class SymptomCategoryPage extends StatefulWidget {
  final Map<String, dynamic> category;

  const SymptomCategoryPage({super.key, required this.category});

  @override
  _SymptomCategoryPageState createState() => _SymptomCategoryPageState();
}

class _SymptomCategoryPageState extends State<SymptomCategoryPage> {
  String? selectedSymptom;

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2F67E8);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category['title'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  widget.category['icon'],
                  size: 32,
                  color: primaryColor,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Select your main symptom:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: widget.category['items'].length,
                itemBuilder: (context, index) {
                  final symptom = widget.category['items'][index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: RadioListTile<String>(
                      title: Text(
                        symptom,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: symptom,
                      groupValue: selectedSymptom,
                      onChanged: (value) {
                        setState(() {
                          selectedSymptom = value;
                        });
                      },
                      activeColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: selectedSymptom != null
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckerSecondPage(
                            selectedSymptoms: [selectedSymptom!],
                          ),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor:
                    selectedSymptom != null ? primaryColor : Colors.grey,
              ),
              child: const Text(
                'Continue',
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
    );
  }
}
