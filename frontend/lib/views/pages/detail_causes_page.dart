import 'package:flutter/material.dart';
import '../../config/predict_services.dart';

class CustomExpandableCard extends StatefulWidget {
  final String title;
  final List<String> content;
  const CustomExpandableCard({super.key, required this.title, required this.content});
  @override
  _CustomExpandableCardState createState() => _CustomExpandableCardState();
}

class _CustomExpandableCardState extends State<CustomExpandableCard> {
  bool _isExpanded = false;
  final Color _headerColor = const Color(0xFF3366FF);
  final Color _contentColor = const Color(0xFFDCE4FF);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Container(
                color: _headerColor,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Icon(_isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: Colors.white, size: 24),
                  ],
                ),
              ),
            ),
            _isExpanded
                ? Container(
                    color: _contentColor,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.content.length == 1
                          ? [
                              Text(widget.content[0], style: const TextStyle(color: Colors.black87, fontSize: 14)),
                            ]
                          : widget.content
                              .map((item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('• ', style: TextStyle(fontSize: 14, color: Colors.black87)),
                                        Expanded(child: Text(item, style: const TextStyle(color: Colors.black87, fontSize: 14))),
                                      ],
                                    ),
                                  ))
                              .toList(),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class DetailCausesPage extends StatefulWidget {
  final List<String> diseases;
  const DetailCausesPage({super.key, required this.diseases});
  @override
  _DetailCausesPageState createState() => _DetailCausesPageState();
}

class _DetailCausesPageState extends State<DetailCausesPage> {
  late Future<Map<String, dynamic>> _infoFuture;

  @override
  void initState() {
    super.initState();
    _infoFuture = PredictServices.getBatchDiseaseInfo(widget.diseases);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios, color: Color(0xFF3366FF), size: 20),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Detailed Information',
                      style: TextStyle(fontSize: 24, color: Color(0xFF3366FF), fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _infoFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data available'));
                  }
                  final data = snapshot.data!;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.diseases.map((disease) {
                        final info = data[disease] ?? {};
                        if (info.containsKey('message')) {
                          return CustomExpandableCard(
                            title: disease,
                            content: [info['message'].toString()],
                          );
                        }
                        final description = info['description']?.toString() ?? '';
                        final actions = info['how_to_feel_better'] is List
                            ? List<String>.from((info['how_to_feel_better'] as List).map((e) => e.toString()))
                            : info['how_to_feel_better'] != null
                                ? [info['how_to_feel_better'].toString()]
                                : <String>[];
                        final prevention = info['how_to_prevent'] is List
                            ? List<String>.from((info['how_to_prevent'] as List).map((e) => e.toString()))
                            : info['how_to_prevent'] != null
                                ? [info['how_to_prevent'].toString()]
                                : <String>[];
                        final emergency = info['when_to_seek_help'] is List
                            ? List<String>.from((info['when_to_seek_help'] as List).map((e) => e.toString()))
                            : info['when_to_seek_help'] != null
                                ? [info['when_to_seek_help'].toString()]
                                : <String>[];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomExpandableCard(
                              title: 'Possible Condition: $disease',
                              content: [description],
                            ),
                            CustomExpandableCard(
                              title: "Here's what you can do now to feel better:",
                              content: actions,
                            ),
                            CustomExpandableCard(
                              title: "Here's how to avoid it in the future:",
                              content: prevention,
                            ),
                            CustomExpandableCard(
                              title: "If the symptom is getting worse",
                              content: emergency,
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
