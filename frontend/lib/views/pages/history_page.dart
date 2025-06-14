import 'package:flutter/material.dart';
import '../../../config/predict_services.dart';
import '../../config/document_services.dart';
import '../../../config/user_preferences.dart';
import 'find_causes_page.dart';
import 'document_detail_page.dart';
import '../../config/services.dart';


class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> predictions = [];
  List<Map<String, dynamic>> documents = [];
  bool isLoading = true;
  late TabController _tabController;
  String? selectedFilter = 'All'; // <-- Move filter state here

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadHistoryData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadHistoryData() async {
    try {
      setState(() => isLoading = true);
      
      final userData = await UserPreferences.getUser();
      final userId = userData['user_id'] ?? userData['id'] ?? 0;

      if (userId != 0) {
        // Load both predictions and documents
        final predictionHistory = await PredictServices.getUserPredictionHistory(userId);
        final documentHistory = await DocumentServices.getUserDocuments(userId);
        
        setState(() {
          predictions = predictionHistory;
          documents = documentHistory['success'] == true ? 
                     List<Map<String, dynamic>>.from(documentHistory['documents']) : [];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("DEBUG: Error loading history: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2F67E8);

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
          'History',
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: primaryColor,
          tabs: const [
            Tab(text: 'Assessments'),
            Tab(text: 'Documents'),
          ],
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading history...'),
                  ],
                ),
              )
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildAssessmentsTab(primaryColor),
                  _buildDocumentsTab(primaryColor),
                ],
              ),
      ),
    );
  }

  Widget _buildAssessmentsTab(Color primaryColor) {
    List<Map<String, dynamic>> filteredPredictions = selectedFilter == null || selectedFilter == 'All'
        ? predictions
        : predictions.where((record) {
            final input = record['input'] as Map<String, dynamic>? ?? {};
            final mainSymptom = input['main_symptom']?.toString() ?? '';
            return mainSymptom == selectedFilter;
          }).toList();

    // Collect all unique main symptoms for filter options
    final filterOptions = <String>{'All'};
    for (var record in predictions) {
      final input = record['input'] as Map<String, dynamic>? ?? {};
      final mainSymptom = input['main_symptom']?.toString() ?? '';
      if (mainSymptom.isNotEmpty) filterOptions.add(mainSymptom);
    }

    return Column(
      children: [
        if (predictions.isNotEmpty) ...[
          // Filter dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Filter by Main Symptom:',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedFilter ?? 'All',
                    isExpanded: true,
                    items: filterOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedFilter = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
        Expanded(
          child: filteredPredictions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.assessment, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'No assessment records found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Complete a health assessment to see your history',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadHistoryData,
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: filteredPredictions.length,
                  itemBuilder: (context, index) {
                    final record = filteredPredictions[index];
                    // ...existing assessment item building code...
                    final input = record['input'] as Map<String, dynamic>? ?? {};
                    final topResults = record['top_results'] as List<dynamic>? ?? [];
                    final mainSymptom = input['main_symptom']?.toString() ?? '';
                    final otherSymptoms = (input['other_symptoms'] as List<dynamic>?)
                            ?.map((e) => e.toString())
                            .join(', ') ??
                        '';
                    final duration = input['duration']?.toString() ?? '';
                    final severity = input['severity']?.toString() ?? '';
                    final summary = record['assessment_summary']?.toString() ?? '';
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: primaryColor),
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
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.assessment, color: primaryColor),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Assessment #${record['predict_id']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          summary.isNotEmpty
                                              ? summary
                                              : 'Main: $mainSymptom${otherSymptoms.isNotEmpty ? '\nOther: $otherSymptoms' : ''}\n$duration - $severity',
                                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                                        ),
                                        if (topResults.isNotEmpty) ...[
                                          const SizedBox(height: 8),
                                          const Text(
                                            'Top Results:',
                                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                          ),
                                          ...topResults.take(3).map((result) {
                                            final disease = result['disease']?.toString() ?? 'Unknown';
                                            final probability = result['probability']?.toString() ?? '0';
                                            return Text(
                                              '• $disease ($probability%)',
                                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                                            );
                                          }),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Navigate to details page
                                      List<Map<String, dynamic>>? dynamicAnswers;
                                      Map<String, dynamic>? userJourney;
                                      
                                      try {
                                        final rawDynamicAnswers = input['dynamic_answers'];
                                        if (rawDynamicAnswers is List) {
                                          dynamicAnswers = rawDynamicAnswers
                                              .map((e) => e is Map<String, dynamic> 
                                                  ? e 
                                                  : <String, dynamic>{
                                                      'question': 'Data',
                                                      'answer': e.toString(),
                                                      'category': 'general',
                                                      'timestamp': ''
                                                    })
                                              .toList();
                                        }
                                        
                                        final rawUserJourney = input['user_journey'];
                                        if (rawUserJourney is Map) {
                                          userJourney = Map<String, dynamic>.from(rawUserJourney);
                                        }
                                      } catch (e) {
                                        print("DEBUG: Error processing data for navigation: $e");
                                        dynamicAnswers = <Map<String, dynamic>>[];
                                        userJourney = <String, dynamic>{};
                                      }
                                      
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FindCausesPage(
                                            mainSymptom: mainSymptom,
                                            mainSymptoms: null,
                                            duration: duration,
                                            severity: severity,
                                            otherSymptoms: otherSymptoms,
                                            predictionResult: record,
                                            dynamicAnswers: dynamicAnswers,
                                            userJourney: userJourney,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      minimumSize: const Size(70, 32),
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                    ),
                                    child: const Text(
                                      'Details',
                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed: () => _deleteAssessment(record['predict_id']),
                                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.red.withOpacity(0.1),
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDocumentsTab(Color primaryColor) {
    return documents.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.description, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No documents found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Upload a document to see it here',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadHistoryData,
                  child: const Text('Refresh'),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              final uploadDate = DateTime.tryParse(document['upload_date'] ?? '');
              final fileSize = document['file_size'] ?? 0;
              final fileSizeKB = (fileSize / 1024).round();
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: primaryColor),
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
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.description,
                              color: primaryColor,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    document['filename'] ?? 'Unknown file',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Type: ${document['file_type']?.toUpperCase() ?? 'Unknown'} • Size: ${fileSizeKB}KB',
                                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                                  ),
                                  if (uploadDate != null) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      'Uploaded: ${uploadDate.day}/${uploadDate.month}/${uploadDate.year}',
                                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                                    ),
                                  ],
                                  if (document['extracted_text'] != null && document['extracted_text'].isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      document['extracted_text'],
                                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DocumentDetailPage(
                                      documentId: document['document_id'],
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                minimumSize: const Size(60, 32),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              child: const Text(
                                'View',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => _deleteDocument(document['document_id']),
                              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.red.withOpacity(0.1),
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Future<void> _deleteAssessment(int predictId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Assessment'),
        content: const Text('Are you sure you want to delete this assessment? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        print("DEBUG: Attempting to delete assessment $predictId");
        
        // Use Services.deletePrediction instead of PredictServices
        final result = await Services.deletePrediction(predictId);
        
        print("DEBUG: Delete result: $result");
        
        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Assessment deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          _loadHistoryData(); // Refresh the list
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete assessment: ${result['message'] ?? 'Unknown error'}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print("DEBUG: Error deleting assessment: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete assessment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteDocument(int documentId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: const Text('Are you sure you want to delete this file? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final userData = await UserPreferences.getUser();
      final userId = userData['user_id'] ?? userData['id'] ?? 0;

      final result = await DocumentServices.deleteDocument(documentId, userId);
      
      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File deleted'),
            backgroundColor: Colors.green,
          ),
        );
        _loadHistoryData(); // Refresh the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete file: ${result['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
