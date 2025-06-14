import 'package:flutter/material.dart';
import 'package:ipho/config/disease_services.dart';

class DiseaseDetailPage extends StatefulWidget {
  final String diseaseName;
  final double probability;

  const DiseaseDetailPage({
    super.key,
    required this.diseaseName,
    required this.probability,
  });

  @override
  _DiseaseDetailPageState createState() => _DiseaseDetailPageState();
}

class _DiseaseDetailPageState extends State<DiseaseDetailPage> {
  Map<String, dynamic>? diseaseInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDiseaseInfo();
  }

  Future<void> _loadDiseaseInfo() async {
    try {
      print("DEBUG: Loading disease info for: ${widget.diseaseName}");
      final info = await DiseaseServices.getDiseaseDetails(widget.diseaseName);
      print("DEBUG: Received disease info: $info");
      
      setState(() {
        diseaseInfo = info;
        isLoading = false;
      });
    } catch (e) {
      print("DEBUG: Error loading disease info: $e");
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to load disease information. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.diseaseName),
        backgroundColor: const Color(0xFF2F67E8),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : diseaseInfo == null
              ? const Center(child: Text("Failed to load disease information"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Probability Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "${(widget.probability).toStringAsFixed(1)}%",
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2F67E8),
                              ),
                            ),
                            const Text(
                              "Match probability",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2F67E8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Disease Information Sections
                      if (diseaseInfo!['disease']!['overview'] != null)
                        _buildInfoSection(
                          icon: Icons.info_outline,
                          title: "Overview",
                          content: diseaseInfo!['disease']!['overview']!,
                        ),
                      
                      if (diseaseInfo!['disease']!['causes'] != null)
                        _buildInfoSection(
                          icon: Icons.warning_amber_outlined,
                          title: "Causes",
                          content: diseaseInfo!['disease']!['causes']!,
                        ),
                      
                      if (diseaseInfo!['disease']!['symptoms'] != null)
                        _buildInfoSection(
                          icon: Icons.healing_outlined,
                          title: "Symptoms",
                          content: diseaseInfo!['disease']!['symptoms']!,
                        ),
                      
                      if (diseaseInfo!['disease']!['how_common'] != null || diseaseInfo!['disease']!['prevalence'] != null)
                        _buildInfoSection(
                          icon: Icons.bar_chart,
                          title: "How common is it?",
                          content: diseaseInfo!['disease']!['how_common'] ?? diseaseInfo!['disease']!['prevalence'] ?? "Prevalence information varies",
                        ),
                      
                      if (diseaseInfo!['disease']!['when_to_see_doctor'] != null)
                        _buildInfoSection(
                          icon: Icons.local_hospital_outlined,
                          title: "When to see a doctor",
                          content: diseaseInfo!['disease']!['when_to_see_doctor']!,
                        ),
                      
                      if (diseaseInfo!['disease']!['treatments'] != null)
                        _buildInfoSection(
                          icon: Icons.medication_outlined,
                          title: "Treatments",
                          content: diseaseInfo!['disease']!['treatments']!,
                        ),
                      
                      if (diseaseInfo!['disease']!['prevention'] != null)
                        _buildInfoSection(
                          icon: Icons.shield_outlined,
                          title: "Prevention",
                          content: diseaseInfo!['disease']!['prevention']!,
                        ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F67E8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildFormattedContent(content),
        ],
      ),
    );
  }

  Widget _buildFormattedContent(String content) {
    // Check if content contains line breaks for list formatting
    if (content.contains('\n-')) {
      List<String> items = content.split('\n').where((item) => item.trim().isNotEmpty).toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          if (item.trim().startsWith('-')) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("• ", style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
                  Expanded(
                    child: Text(
                      item.trim().substring(1).trim(),
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                item.trim(),
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
            );
          }
        }).toList(),
      );
    } else {
      return Text(
        content,
        style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
      );
    }
  }
}
