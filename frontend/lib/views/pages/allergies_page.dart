import 'package:flutter/material.dart';
import 'package:ipho/views/pages/allergies_add_page.dart';
import 'package:ipho/config/user_preferences.dart';

class AllergiesPage extends StatefulWidget {
  const AllergiesPage({super.key});

  @override
  _AllergiesPageState createState() => _AllergiesPageState();
}

class _AllergiesPageState extends State<AllergiesPage> {
  List<String> userAllergies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserAllergies();
  }

  Future<void> _loadUserAllergies() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Load user data to get allergies
      final userData = await UserPreferences.getUser();
      
      if (userData['allergies'] != null) {
        String allergiesString = userData['allergies'] as String;
        if (allergiesString.isNotEmpty) {
          // Split allergies by comma and trim whitespace
          userAllergies = allergiesString.split(',').map((e) => e.trim()).toList();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading allergies: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
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
          'Allergies',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF2F67E8),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/extracted.png',
                  height: 60,
                  width: 60,
                ),
                const SizedBox(width: 18),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stay Safe – Avoid These',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'The information on this page is not being used for your assessment',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFBFD6FF),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 18),
                          userAllergies.isEmpty
                              ? Expanded(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.sentiment_dissatisfied,
                                            color: Colors.grey[400], size: 48),
                                        const SizedBox(height: 12),
                                        Text(
                                          'No allergies added yet',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Tap the + button below to add your allergies.',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF2F67E8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: ListView.separated(
                                    itemCount: userAllergies.length,
                                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18, vertical: 14),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: const Color(0xFF2F67E8), width: 1),
                                          borderRadius: BorderRadius.circular(14),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.blue.withOpacity(0.04),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.warning_amber_rounded,
                                                color: Color(0xFF2F67E8), size: 22),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                userAllergies[index],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF2F67E8),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                          const SizedBox(height: 18),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: FloatingActionButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AllergiesAddPage(),
                                    ),
                                  );
                                  if (result == true) {
                                    _loadUserAllergies();
                                  }
                                },
                                backgroundColor: const Color(0xFF2F67E8),
                                elevation: 2,
                                child: const Icon(Icons.add, color: Colors.white, size: 28),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}