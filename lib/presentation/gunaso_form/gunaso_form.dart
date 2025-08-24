import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';

class GunasoForm extends StatefulWidget {
  const GunasoForm({super.key});

  @override
  _GunasoFormState createState() => _GunasoFormState();
}

class _GunasoFormState extends State<GunasoForm> {
  final _formKey = GlobalKey<FormState>();
  final _memberIdController = TextEditingController(text: '159');
  final _gunashoPlaceController = TextEditingController(text: 'Budhanilkantha');
  final _popularPlaceController = TextEditingController(text: 'Budhanilkantha');
  final _fullNameController = TextEditingController(text: 'Sumit Kharel');
  final _headingController = TextEditingController(text: 'Random Complaint');
  final _messageController = TextEditingController(text: 'I want to report an issue.');
  final _phoneNumberController = TextEditingController(text: '9841473263');
  final _sakhaIdController = TextEditingController(text: '');
  final _orgIdController = TextEditingController(text: '16');

  bool _isLoading = false;
  String? _responseMessage;
  List<File> _selectedFiles = [];

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedFiles.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf', 'doc'],
    );

    if (result != null) {
      setState(() {
        _selectedFiles.addAll(
          result.paths.map((path) => File(path!)).toList(),
        );
      });
    }
  }

  Future<void> _submitGunaso(String url) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _responseMessage = null;
    });

    final request = http.MultipartRequest('POST', Uri.parse(url));

    // Add form fields
    request.fields['memberIdOrGUserFbId'] = _memberIdController.text;
    request.fields['gunashoPlace'] = _gunashoPlaceController.text;
    request.fields['popularPlace'] = _popularPlaceController.text;
    request.fields['fullName'] = _fullNameController.text;
    request.fields['heading'] = _headingController.text;
    request.fields['message'] = _messageController.text;
    request.fields['phoneNumber'] = _phoneNumberController.text;
    request.fields['sakhaId'] = _sakhaIdController.text;
    request.fields['orgId'] = _orgIdController.text;

    // Add files
    for (var file in _selectedFiles) {
      request.files.add(
        await http.MultipartFile.fromPath('files', file.path),
      );
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      setState(() {
        _isLoading = false;
        if (response.statusCode == 200) {
          _responseMessage = 'Gunaso submitted successfully!';
          _formKey.currentState!.reset();
          _memberIdController.clear();
          _gunashoPlaceController.clear();
          _popularPlaceController.clear();
          _fullNameController.clear();
          _headingController.clear();
          _messageController.clear();
          _phoneNumberController.clear();
          _sakhaIdController.clear();
          _orgIdController.clear();
          _selectedFiles.clear();
        } else {
          _responseMessage = 'Failed to submit Gunaso: ${response.statusCode}';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _responseMessage = 'Error: $e';
      });
    }
  }

  @override
  void dispose() {
    _memberIdController.dispose();
    _gunashoPlaceController.dispose();
    _popularPlaceController.dispose();
    _fullNameController.dispose();
    _headingController.dispose();
    _messageController.dispose();
    _phoneNumberController.dispose();
    _sakhaIdController.dispose();
    _orgIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Gunaso'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Form fields
                  TextFormField(
                    controller: _memberIdController,
                    decoration: const InputDecoration(
                      labelText: 'Member ID or User FB ID',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Member ID or User FB ID';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _gunashoPlaceController,
                    decoration: const InputDecoration(
                      labelText: 'Gunaso Place',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Gunaso Place';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _popularPlaceController,
                    decoration: const InputDecoration(
                      labelText: 'Popular Place',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Full Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _headingController,
                    decoration: const InputDecoration(
                      labelText: 'Heading',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Heading';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Message',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Message';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Phone Number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _sakhaIdController,
                    decoration: const InputDecoration(
                      labelText: 'Sakha ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _orgIdController,
                    decoration: const InputDecoration(
                      labelText: 'Organization ID',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Organization ID';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // File upload section
                  const Text(
                    'Attach Files:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library, size: 36),
                        tooltip: 'Gallery',
                      ),
                      IconButton(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt, size: 36),
                        tooltip: 'Camera',
                      ),
                      IconButton(
                        onPressed: _pickFile,
                        icon: const Icon(Icons.attach_file, size: 36),
                        tooltip: 'File',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (_selectedFiles.isNotEmpty)
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _selectedFiles.map((file) {
                        return Chip(
                          label: Text(file.path.split('/').last),
                          onDeleted: () {
                            setState(() {
                              _selectedFiles.remove(file);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 20),

                  // Submit button
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: _isLoading
                          ? null
                          : () => _submitGunaso(
                          'https://uat.nirc.com.np:8443/GWP/message/addGunashoFromMobile'),
                      child: const Text('Submit Gunaso'),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (_responseMessage != null)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    _responseMessage!,
                    style: TextStyle(
                      color: _responseMessage!.contains('successfully')
                          ? Colors.green
                          : Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}