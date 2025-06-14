import 'package:flutter/material.dart';
import 'package:ipho/config/services.dart';
import 'package:ipho/config/user_preferences.dart';

class AllergiesAddPage extends StatefulWidget {
  const AllergiesAddPage({super.key});

  @override
  _AllergiesAddPageState createState() => _AllergiesAddPageState();
}

class _AllergiesAddPageState extends State<AllergiesAddPage> {
  final TextEditingController _customController = TextEditingController();
  List<String> selectedAllergies = [];
  List<Map<String, dynamic>> allergiesList = [];
  bool isLoading = true;
  bool isSaving = false;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Load user data
      userData = await UserPreferences.getUser();
      
      // Load existing allergies from user data
      if (userData != null && userData!['allergies'] != null) {
        String allergiesStr = userData!['allergies'];
        if (allergiesStr.isNotEmpty) {
          selectedAllergies = allergiesStr.split(',').map((e) => e.trim()).toList();
        }
      }
      
      // Load allergies list from API
      print("DEBUG: Loading allergies from API...");
      final allergies = await Services.getAllergies();
      print("DEBUG: Loaded ${allergies.length} allergies: $allergies");
      
      setState(() {
        allergiesList = allergies;
        isLoading = false;
      });
    } catch (e) {
      print("DEBUG: Error loading allergies: $e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  Future<void> _saveAllergies() async {
    if (userData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data not available')),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      // Add custom allergy if entered
      if (_customController.text.isNotEmpty) {
        String customAllergy = _customController.text.trim();
        if (!selectedAllergies.contains(customAllergy)) {
          selectedAllergies.add(customAllergy);
        }
      }

      // Join selected allergies with comma, or empty string if no allergies
      String allergiesString = selectedAllergies.isEmpty ? '' : selectedAllergies.join(', ');

      // Fix: Get correct user ID - try different field names
      int userId = 0;
      if (userData!['user_id'] != null) {
        userId = userData!['user_id'];
      } else if (userData!['id'] != null) {
        userId = userData!['id'];
      }

      print("DEBUG: User ID for update: $userId");
      print("DEBUG: User data keys: ${userData!.keys.toList()}");

      if (userId == 0) {
        throw Exception('Invalid user ID. Please login again.');
      }

      // Fix: Properly handle weight and height conversion with safe defaults
      double weight = 0.0;
      double height = 0.0;
      
      if (userData!['weight'] != null) {
        if (userData!['weight'] is double) {
          weight = userData!['weight'];
        } else if (userData!['weight'] is int) {
          weight = userData!['weight'].toDouble();
        } else if (userData!['weight'] is String) {
          weight = double.tryParse(userData!['weight']) ?? 0.0;
        }
      }
      
      if (userData!['height'] != null) {
        if (userData!['height'] is double) {
          height = userData!['height'];
        } else if (userData!['height'] is int) {
          height = userData!['height'].toDouble();
        } else if (userData!['height'] is String) {
          height = double.tryParse(userData!['height']) ?? 0.0;
        }
      }

      // Update user with selected allergies (can be empty)
      await Services.updateUser(
        userId: userId,
        name: userData!['name'] ?? '',
        username: userData!['username'] ?? '',
        email: userData!['email'] ?? '',
        weight: weight.toInt(),
        height: height.toInt(),
        birthday: userData!['birthday'] ?? '',
        photo: null,
        gender: userData!['gender'] ?? '',
        allergies: allergiesString,
        bloodType: userData!['blood_type'] ?? '',
      );

      String message = selectedAllergies.isEmpty 
          ? 'Allergies cleared successfully' 
          : 'Allergies saved successfully';
      
      // CRITICAL: Update UserPreferences with new allergy data
      userData!['allergies'] = allergiesString;
      await UserPreferences.saveUser(userData!);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving allergies: $e')),
      );
    } finally {
      setState(() {
        isSaving = false;
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
        title: const Text(
          'Manage Allergies',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Allergies',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F67E8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  selectedAllergies.isEmpty
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: const Text(
                            'No allergies selected yet.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: selectedAllergies.map((allergy) {
                            return Chip(
                              label: Text(
                                allergy,
                                style: const TextStyle(
                                  color: Color(0xFF2F67E8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              backgroundColor: const Color(0xFFEBF2FF),
                              deleteIcon: const Icon(Icons.close, size: 18, color: Color(0xFF2F67E8)),
                              onDeleted: () {
                                setState(() {
                                  selectedAllergies.remove(allergy);
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(color: Color(0xFF2F67E8)),
                              ),
                            );
                          }).toList(),
                        ),
                  const SizedBox(height: 24),
                  const Text(
                    'Add from Common Allergies',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2F67E8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Show loading or error state for common allergies
                  allergiesList.isEmpty
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'No common allergies loaded.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: _loadData,
                                child: const Text(
                                  'Retry Loading',
                                  style: TextStyle(color: Color(0xFF2F67E8)),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: allergiesList.map((allergy) {
                            final allergyName = allergy['name'].toString();
                            final isSelected = selectedAllergies.contains(allergyName);
                            return FilterChip(
                              label: Text(
                                allergyName,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFF2F67E8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: const Color(0xFF2F67E8),
                              backgroundColor: Colors.white,
                              checkmarkColor: Colors.white,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    if (!selectedAllergies.contains(allergyName)) {
                                      selectedAllergies.add(allergyName);
                                    }
                                  } else {
                                    selectedAllergies.remove(allergyName);
                                  }
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected ? const Color(0xFF2F67E8) : Colors.grey.shade300,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                  const SizedBox(height: 18),
                  const Text(
                    'Add Custom Allergy',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2F67E8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _customController,
                          decoration: InputDecoration(
                            hintText: 'Type allergy name...',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Color(0xFF2F67E8)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          final custom = _customController.text.trim();
                          if (custom.isNotEmpty && !selectedAllergies.contains(custom)) {
                            setState(() {
                              selectedAllergies.add(custom);
                              _customController.clear();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F67E8),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                          elevation: 0,
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSaving ? null : _saveAllergies,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F67E8),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: const Size(200, 48),
                      ),
                      child: isSaving
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildAllergyButton(String name, {bool isSelected = false}) {
    const selectedColor = Color(0xFFEBF2FF);
    const mainBlue = Color(0xFF2F67E8);
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (isSelected) {
            selectedAllergies.remove(name);
          } else {
            selectedAllergies.add(name);
          }
        });
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: isSelected ? selectedColor : Colors.white,
        foregroundColor: mainBlue,
        side: const BorderSide(color: mainBlue, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected) ...[
            const Icon(Icons.check, size: 16, color: mainBlue),
            const SizedBox(width: 6),
          ],
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: mainBlue,
            ),
          ),
        ],
      ),
    );
  }
}