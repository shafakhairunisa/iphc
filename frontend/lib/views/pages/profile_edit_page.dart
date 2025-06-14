import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipho/config/services.dart';
import 'package:ipho/config/user_preferences.dart';

class ProfileEditPage extends StatefulWidget {
 const ProfileEditPage({super.key});

 @override
 _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
 final _formKey = GlobalKey<FormState>();
 late TextEditingController _fullNameController;
 late TextEditingController _nicknameController;
 late TextEditingController _emailController;
 late TextEditingController _birthdateController;
 late TextEditingController _weightController;
 late TextEditingController _heightController;
 late TextEditingController _genderController;
 late TextEditingController _bloodTypeController;
 String? _selectedGender;
 final List<String> _genderOptions = ['Male', 'Female', 'Other'];
 final List<String> _bloodTypeOptions = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
 File? _image;
 final ImagePicker _picker = ImagePicker();
 late Map<String, dynamic> _userData;
 bool _isLoading = true;
 bool _isSaving = false;
 String? _userAllergies;

 @override
 void initState() {
   super.initState();
   _loadUserData();
 }

 Future<void> _loadUserData() async {
   _userData = await UserPreferences.getUser();
   setState(() {
     _fullNameController = TextEditingController(text: _userData['name'] ?? '');
     _nicknameController = TextEditingController(text: _userData['username'] ?? '');
     _emailController = TextEditingController(text: _userData['email'] ?? '');
     _birthdateController = TextEditingController(text: _userData['birthday'] ?? '');
     
     // FIXED: Safe numeric value handling
     double? weight = _userData['weight'];
     double? height = _userData['height'];
     
     _weightController = TextEditingController(
         text: weight != null && weight > 0 ? weight.toString() : '');
     _heightController = TextEditingController(
         text: height != null && height > 0 ? height.toString() : '');
         
     _selectedGender = _userData['gender'] ?? 'Female';
     _genderController = TextEditingController(text: _selectedGender);
     _userAllergies = _userData['allergies'] ?? '';
     _bloodTypeController = TextEditingController(text: _userData['blood_type'] ?? '');
     _isLoading = false;
   });
 }

 Future<void> _selectDate(BuildContext context) async {
   final DateTime? picked = await showDatePicker(
     context: context,
     initialDate: DateTime.now(),
     firstDate: DateTime(1900),
     lastDate: DateTime.now(),
   );
   if (picked != null) {
     setState(() {
       _birthdateController.text = '${picked.day}/${picked.month}/${picked.year}';
     });
   }
 }

 Future<void> _pickImage() async {
   final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
   if (pickedFile != null) {
     setState(() {
       _image = File(pickedFile.path);
     });
   }
 }

 @override
 void dispose() {
   _fullNameController.dispose();
   _nicknameController.dispose();
   _emailController.dispose();
   _birthdateController.dispose();
   _weightController.dispose();
   _heightController.dispose();
   _genderController.dispose();
   _bloodTypeController.dispose();
   super.dispose();
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: const Color(0xFF1A3D9C),
     appBar: AppBar(
       backgroundColor: Colors.transparent,
       elevation: 0,
       leading: IconButton(
         icon: const Icon(Icons.arrow_back, color: Colors.white),
         onPressed: () => Navigator.pop(context),
       ),
       title: const Text(
         'Change Profile',
         style: TextStyle(color: Colors.white),
       ),
     ),
     body: _isLoading
         ? const Center(child: CircularProgressIndicator(color: Colors.white))
         : Padding(
             padding: const EdgeInsets.all(16.0),
             child: Form(
               key: _formKey,
               child: SingleChildScrollView(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: [
                     const SizedBox(height: 16),
                     Center(
                       child: Stack(
                         children: [
                           CircleAvatar(
                             radius: 40,
                             backgroundColor: Colors.grey[300],
                             backgroundImage: _image != null
                                 ? FileImage(_image!)
                                 : (_userData['photo'] != null && _userData['photo'].isNotEmpty
                                     ? NetworkImage(_userData['photo']) as ImageProvider
                                     : null),
                             child: (_image == null && (_userData['photo'] == null || _userData['photo'].isEmpty))
                                 ? const Icon(
                                     Icons.person,
                                     size: 50,
                                     color: Colors.grey,
                                   )
                                 : null,
                           ),
                           Positioned(
                             bottom: 0,
                             right: 0,
                             child: CircleAvatar(
                               radius: 16,
                               backgroundColor: Colors.white,
                               child: IconButton(
                                 iconSize: 16,
                                 icon: const Icon(Icons.camera_alt, color: Color(0xFF1A3D9C)),
                                 onPressed: _pickImage,
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                     const SizedBox(height: 8),
                     const Center(
                       child: Text(
                         'Change Profile',
                         style: TextStyle(
                           color: Colors.white,
                           fontSize: 14,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                     ),
                     const SizedBox(height: 32),
                     TextFormField(
                       controller: _fullNameController,
                       style: const TextStyle(color: Colors.white),
                       decoration: InputDecoration(
                         labelText: 'Full name',
                         labelStyle: const TextStyle(color: Colors.white, fontSize: 14),
                         filled: true,
                         fillColor: Colors.white.withOpacity(0.2),
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(8),
                           borderSide: BorderSide.none,
                         ),
                       ),
                     ),
                     const SizedBox(height: 16),
                     TextFormField(
                       controller: _nicknameController,
                       style: const TextStyle(color: Colors.white),
                       decoration: InputDecoration(
                         labelText: 'Nickname',
                         labelStyle: const TextStyle(color: Colors.white, fontSize: 14),
                         filled: true,
                         fillColor: Colors.white.withOpacity(0.2),
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(8),
                           borderSide: BorderSide.none,
                         ),
                       ),
                     ),
                     const SizedBox(height: 16),
                     TextFormField(
                       controller: _emailController,
                       style: const TextStyle(color: Colors.white),
                       decoration: InputDecoration(
                         labelText: 'Your email address',
                         labelStyle: const TextStyle(color: Colors.white, fontSize: 14),
                         filled: true,
                         fillColor: Colors.white.withOpacity(0.2),
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(8),
                           borderSide: BorderSide.none,
                         ),
                       ),
                     ),
                     const SizedBox(height: 16),
                     Row(
                       children: [
                         Expanded(
                           child: TextFormField(
                             controller: _birthdateController,
                             readOnly: true,
                             onTap: () => _selectDate(context),
                             style: const TextStyle(color: Colors.white),
                             decoration: InputDecoration(
                               labelText: 'Birthdate',
                               labelStyle: const TextStyle(color: Colors.white, fontSize: 14),
                               filled: true,
                               fillColor: Colors.white.withOpacity(0.2),
                               border: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(8),
                                 borderSide: BorderSide.none,
                               ),
                               suffixIcon: IconButton(
                                 icon: const Icon(Icons.calendar_today, color: Colors.white),
                                 onPressed: () => _selectDate(context),
                               ),
                             ),
                           ),
                         ),
                       ],
                     ),
                     const SizedBox(height: 16),
                     DropdownButtonFormField<String>(
                       value: _selectedGender?.isNotEmpty == true && _genderOptions.contains(_selectedGender) ? _selectedGender : 'Female',
                       items: _genderOptions.map((String value) {
                         return DropdownMenuItem<String>(
                           value: value,
                           child: Text(value, style: const TextStyle(color: Colors.white)),
                         );
                       }).toList(),
                       onChanged: (String? newValue) {
                         setState(() {
                           _selectedGender = newValue ?? 'Female';
                           _genderController.text = newValue ?? 'Female';
                         });
                       },
                       decoration: InputDecoration(
                         labelText: 'Gender',
                         labelStyle: const TextStyle(color: Colors.white, fontSize: 14),
                         filled: true,
                         fillColor: Colors.white.withOpacity(0.2),
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(8),
                           borderSide: BorderSide.none,
                         ),
                       ),
                       dropdownColor: const Color(0xFF1A3D9C),
                     ),
                     const SizedBox(height: 16),
                     DropdownButtonFormField<String>(
                       value: _bloodTypeOptions.contains(_bloodTypeController.text) ? _bloodTypeController.text : null,
                       items: _bloodTypeOptions.map((String value) {
                         return DropdownMenuItem<String>(
                           value: value,
                           child: Text(value, style: const TextStyle(color: Colors.white)),
                         );
                       }).toList(),
                       onChanged: (String? newValue) {
                         setState(() {
                           _bloodTypeController.text = newValue ?? 'A+';
                         });
                       },
                       decoration: InputDecoration(
                         labelText: 'Blood Type',
                         labelStyle: const TextStyle(color: Colors.white, fontSize: 14),
                         filled: true,
                         fillColor: Colors.white.withOpacity(0.2),
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(8),
                           borderSide: BorderSide.none,
                         ),
                       ),
                       dropdownColor: const Color(0xFF1A3D9C),
                       hint: const Text('Select Blood Type', style: TextStyle(color: Colors.white70)),
                     ),
                     const SizedBox(height: 16),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Expanded(
                           child: TextFormField(
                             controller: _weightController,
                             keyboardType: TextInputType.number,
                             style: const TextStyle(color: Colors.white),
                             decoration: InputDecoration(
                               labelText: 'Weight (in Kg)',
                               labelStyle: const TextStyle(color: Colors.white, fontSize: 14),
                               filled: true,
                               fillColor: Colors.white.withOpacity(0.2),
                               border: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(8),
                                 borderSide: BorderSide.none,
                               ),
                             ),
                           ),
                         ),
                         const SizedBox(width: 8),
                         Expanded(
                           child: TextFormField(
                             controller: _heightController,
                             keyboardType: TextInputType.number,
                             style: const TextStyle(color: Colors.white),
                             decoration: InputDecoration(
                               labelText: 'Height (in Cm)',
                               labelStyle: const TextStyle(color: Colors.white, fontSize: 14),
                               filled: true,
                               fillColor: Colors.white.withOpacity(0.2),
                               border: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(8),
                                 borderSide: BorderSide.none,
                               ),
                             ),
                           ),
                         ),
                       ],
                     ),
                     const SizedBox(height: 32),
                     ElevatedButton(
                       onPressed: _isSaving
                           ? null
                           : () async {
                               if (_formKey.currentState!.validate()) {
                                 setState(() {
                                   _isSaving = true;
                                 });

                                 String? photoBase64;
                                 if (_image != null) {
                                   final bytes = await _image!.readAsBytes();
                                   photoBase64 = base64Encode(bytes);
                                 }

                                 try {
                                   // FIXED: Safe numeric parsing
                                   int weight = 0;
                                   int height = 0;
                                   
                                   if (_weightController.text.isNotEmpty) {
                                     weight = int.tryParse(_weightController.text) ?? 0;
                                   }
                                   
                                   if (_heightController.text.isNotEmpty) {
                                     height = int.tryParse(_heightController.text) ?? 0;
                                   }
                                   
                                   await Services.updateUser(
                                     userId: _userData['user_id'] ?? 0,
                                     name: _fullNameController.text.trim(),
                                     username: _nicknameController.text.trim(),
                                     email: _emailController.text.trim(),
                                     weight: weight,
                                     height: height,
                                     birthday: _birthdateController.text.trim(),
                                     photo: photoBase64,
                                     gender: _selectedGender ?? 'Female',
                                     allergies: _userAllergies ?? '',
                                     bloodType: _bloodTypeController.text.trim(),
                                   );
                                   
                                   ScaffoldMessenger.of(context).showSnackBar(
                                     const SnackBar(content: Text('Profile updated successfully')),
                                   );
                                   
                                   Navigator.pop(context, true);
                                 } catch (e) {
                                   ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(content: Text('Error: $e')),
                                   );
                                 } finally {
                                   setState(() {
                                     _isSaving = false;
                                   });
                                 }
                               }
                             },
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.white,
                         foregroundColor: const Color(0xFF1A3D9C),
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(30),
                         ),
                         elevation: 0,
                         minimumSize: const Size(double.infinity, 48),
                       ),
                       child: _isSaving
                           ? const SizedBox(
                               height: 20,
                               width: 20,
                               child: CircularProgressIndicator(
                                 color: Color(0xFF1A3D9C),
                                 strokeWidth: 3,
                               ),
                             )
                           : const Text(
                               'Save Changes',
                               style: TextStyle(
                                 fontSize: 18,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                     ),
                     const SizedBox(height: 16),
                   ],
                 ),
               ),
             ),
           ),
   );
 }
}