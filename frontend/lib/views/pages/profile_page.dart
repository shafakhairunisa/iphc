import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:ipho/config/user_preferences.dart';
import 'package:ipho/config/user_services.dart';
import 'package:ipho/views/pages/allergies_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _birthdayController;
  late TextEditingController _allergiesController;

  // State variables
  Map<String, dynamic> _userData = {};
  bool _isLoading = true;
  String? _selectedGender;
  String? _selectedBloodType;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? _photoBase64;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadUserData();
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _weightController = TextEditingController();
    _heightController = TextEditingController();
    _birthdayController = TextEditingController();
    _allergiesController = TextEditingController();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await UserPreferences.getUser();
      setState(() {
        _userData = userData;
        // Always use the network image if photo exists in userData and is a valid URL
        if (_userData['photo'] != null &&
            _userData['photo'].toString().isNotEmpty &&
            (_userData['photo'].toString().startsWith('http') ||
             _userData['photo'].toString().startsWith('https'))) {
          _image = null;
          _photoBase64 = null;
        }
        _populateControllers();
        _isLoading = false;
      });
    } catch (e) {
      print("DEBUG: Error loading user data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _populateControllers() {
    _nameController.text = _userData['name'] ?? '';
    _usernameController.text = _userData['username'] ?? '';
    _emailController.text = _userData['email'] ?? '';
    _weightController.text = _userData['weight']?.toString() ?? '';
    _heightController.text = _userData['height']?.toString() ?? '';
    _birthdayController.text = _userData['birthday'] ?? '';
    
    // Handle allergies - show "None" if empty or null
    String allergiesText = _userData['allergies'] ?? '';
    if (allergiesText.isEmpty) {
      _allergiesController.text = 'None';
    } else {
      _allergiesController.text = allergiesText;
    }
    
    // Fix: Validate dropdown values exist in items list
    String userGender = _userData['gender'] ?? 'Female';
    String userBloodType = _userData['blood_type'] ?? 'A+';
    
    // Ensure gender value exists in dropdown items
    List<String> genderItems = ['Male', 'Female', 'Other'];
    _selectedGender = genderItems.contains(userGender) ? userGender : 'Female';
    
    // Ensure blood type value exists in dropdown items  
    List<String> bloodTypeItems = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
    _selectedBloodType = bloodTypeItems.contains(userBloodType) ? userBloodType : 'A+';
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      final bytes = await _image!.readAsBytes();
      _photoBase64 = base64Encode(bytes);
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Safe data preparation with proper null handling
      final updateData = {
        'name': _nameController.text.trim(),
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'weight': double.tryParse(_weightController.text) ?? (_userData['weight'] ?? 0.0),
        'height': double.tryParse(_heightController.text) ?? (_userData['height'] ?? 0.0),
        'birthday': _birthdayController.text.trim().isNotEmpty && _birthdayController.text.trim() != '0000-00-00' 
            ? _birthdayController.text.trim() 
            : (_userData['birthday'] ?? ''),
        'gender': _selectedGender ?? (_userData['gender'] ?? 'Female'),
        'allergies': _allergiesController.text.trim(),
        'blood_type': _selectedBloodType ?? (_userData['blood_type'] ?? 'A+'),
        // Always send photo if available in userData, or if picked
        if (_photoBase64 != null)
          'photo': _photoBase64
        else if (_userData['photo'] != null && _userData['photo'].toString().isNotEmpty)
          'photo': _userData['photo'],
      };

      print("DEBUG: Update data being sent: $updateData");

      // Get user ID safely
      int userId = _userData['user_id'] ?? _userData['id'] ?? 0;

      if (userId == 0) {
        throw Exception('Invalid user ID. Please login again.');
      }

      // Safe response handling
      final response = await UserServices.updateUser(userId, updateData);

      if (response['success'] == true) {
        // Safe user data extraction
        final updatedUser = response['user'];
        if (updatedUser != null && updatedUser is Map<String, dynamic>) {
          setState(() {
            _userData = Map<String, dynamic>.from(updatedUser);
            // Always use the network image if photo exists in userData
            if (_userData['photo'] != null && _userData['photo'].toString().isNotEmpty) {
              _image = null;
              _photoBase64 = null;
            }
            _populateControllers(); // Refresh the form with updated data
          });

          // Save to preferences so photo persists everywhere
          try {
            await UserPreferences.saveUser(_userData);
          } catch (e) {
            print("DEBUG: Failed to save to preferences: $e");
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Profile updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          throw Exception('Invalid user data received');
        }
      } else {
        throw Exception(response['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      print("DEBUG: Profile update error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)), // Default to 25 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2F67E8),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate = "${pickedDate.day.toString().padLeft(2, '0')}/"
          "${pickedDate.month.toString().padLeft(2, '0')}/"
          "${pickedDate.year}";
      setState(() {
        _birthdayController.text = formattedDate;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _birthdayController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    try {
      // Show confirmation dialog
      bool? confirmLogout = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Logout'),
              ),
            ],
          );
        },
      );

      if (confirmLogout == true) {
        // Clear user preferences
        await UserPreferences.clearUser();
        
        // Navigate to screen page and clear stack
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/',
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during logout: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2F67E8);

    String? photoUrl;
    if (_userData['photo'] != null && _userData['photo'].toString().isNotEmpty) {
      final String rawPhoto = _userData['photo'].toString();
      // If backend returns a relative path, prepend the server URL
      if (rawPhoto.startsWith('/')) {
        photoUrl = 'http://10.31.203.169:8000$rawPhoto';
      } else if (rawPhoto.startsWith('http') || rawPhoto.startsWith('https')) {
        photoUrl = rawPhoto;
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // Clean App Bar
                SliverAppBar(
                  backgroundColor: primaryColor,
                  expandedHeight: 200,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [primaryColor, primaryColor.withOpacity(0.8)],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                backgroundImage: _image != null
                                    ? FileImage(_image!)
                                    : (photoUrl != null
                                        ? NetworkImage(photoUrl)
                                        : null),
                                child: (_image == null && photoUrl == null)
                                    ? const Icon(
                                        Icons.person,
                                        color: primaryColor,
                                        size: 40,
                                      )
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: const CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: primaryColor,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _userData['name'] ?? 'User',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            _userData['email'] ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Personal Information Section
                          _buildSectionCard(
                            title: 'Personal Information',
                            icon: Icons.person_outline,
                            children: [
                              _buildCleanTextField(
                                controller: _nameController,
                                label: 'Full Name',
                                icon: Icons.person_outline,
                              ),
                              const SizedBox(height: 16),
                              _buildCleanTextField(
                                controller: _usernameController,
                                label: 'Username',
                                icon: Icons.account_circle_outlined,
                              ),
                              const SizedBox(height: 16),
                              _buildCleanTextField(
                                controller: _emailController,
                                label: 'Email Address',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),
                              _buildCleanTextField(
                                controller: _birthdayController,
                                label: 'Birthday',
                                icon: Icons.cake_outlined,
                                isDateField: true,
                              ),
                              const SizedBox(height: 16),
                              _buildCleanDropdown(
                                value: _selectedGender,
                                label: 'Gender',
                                icon: Icons.person_outline,
                                items: ['Male', 'Female', 'Other'],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value;
                                  });
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Physical Information Section
                          _buildSectionCard(
                            title: 'Physical Information',
                            icon: Icons.monitor_weight_outlined,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildCleanTextField(
                                      controller: _heightController,
                                      label: 'Height (cm)',
                                      icon: Icons.height,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildCleanTextField(
                                      controller: _weightController,
                                      label: 'Weight (kg)',
                                      icon: Icons.monitor_weight_outlined,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildCleanDropdown(
                                value: _selectedBloodType,
                                label: 'Blood Type',
                                icon: Icons.bloodtype,
                                items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedBloodType = value;
                                  });
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Medical Information Section
                          _buildSectionCard(
                            title: 'Medical Information',
                            icon: Icons.medical_information_outlined,
                            children: [
                              _buildAllergiesCard(),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // Update Button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _updateProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Update Profile',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Logout Button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: OutlinedButton(
                              onPressed: _isLoading ? null : _logout,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red, width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF2F67E8), size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2F67E8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildCleanTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool isDateField = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: isDateField,
      onTap: isDateField ? () => _selectDate(context) : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF2F67E8), size: 20),
        suffixIcon: isDateField 
            ? const Icon(Icons.calendar_today, color: Color(0xFF2F67E8), size: 20)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2F67E8), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  Widget _buildCleanDropdown({
    required String? value,
    required String label,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF2F67E8), size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2F67E8), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  Widget _buildAllergiesCard() {
    bool hasAllergies = _userData['allergies'] != null && _userData['allergies'].toString().isNotEmpty;
    
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AllergiesPage(),
          ),
        );
        if (result == true) {
          _loadUserData();
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: hasAllergies ? Colors.blue.shade50 : Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasAllergies ? Colors.blue.shade200 : Colors.orange.shade200,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  hasAllergies ? Icons.verified_user : Icons.warning_outlined,
                  color: hasAllergies ? Colors.blue.shade600 : Colors.orange.shade600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hasAllergies ? 'Allergies Recorded' : 'No Allergies Added',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: hasAllergies ? Colors.blue.shade700 : Colors.orange.shade700,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: hasAllergies ? Colors.blue.shade600 : Colors.orange.shade600,
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              hasAllergies 
                  ? _userData['allergies'].toString()
                  : 'Tap to add your allergies for safer healthcare',
              style: TextStyle(
                fontSize: 13,
                color: hasAllergies ? Colors.blue.shade600 : Colors.orange.shade600,
                fontStyle: hasAllergies ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
