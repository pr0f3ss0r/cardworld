import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/upload_bloc.dart';
import '../../blocs/upload_event.dart';
import '../../blocs/upload_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_flutter/cloudinary_object.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  String? _selectedCardType;
  String? _selectedSubCategory;
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false; // Loading state

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _deleteImage() {
    setState(() {
      _image = null;
    });
  }

  Future<void> _uploadCard() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_image != null) {
        setState(() {
          _isLoading = true; // Start loading
        });
        try {
          // Initialize Cloudinary
          final cloudinary = Cloudinary.unsignedConfig(
            cloudName: 'daj1zigmo',
          );

          // Use the Cloudinary preset you created
          CloudinaryResponse response = await cloudinary.unsignedUpload(
            uploadPreset:
                'giftcard_uploads_preset', // Set your upload preset here
            file: _image!.path,
            resourceType: CloudinaryResourceType.image,
          );

          // Get the secure URL of the uploaded image
          String? imageUrl = response.secureUrl;

          // Store the image URL and other details in Firestore
          await FirebaseFirestore.instance.collection('giftcards').add({
            'cardType': _selectedCardType,
            'subCategory': _selectedSubCategory,
            'amount': _amountController.text,
            'imageUrl': imageUrl,
            'timestamp': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gift card uploaded successfully!')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        } finally {
          setState(() {
            _isLoading = false; // End loading
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Gift Card'),
      ),
      body: BlocListener<UploadBloc, UploadState>(
        listener: (context, state) {
          if (state is UploadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Upload Successful!')),
            );
          } else if (state is UploadFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Gift Card Type',
                  ),
                  items: ['Amazon', 'iTunes', 'Google Play', 'Steam']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCardType = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a gift card type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Sub Category',
                  ),
                  items: ['Physical', 'Digital'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSubCategory = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a sub category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                _image == null
                    ? const Text('No image selected.')
                    : Column(
                        children: [
                          Image.file(_image!, height: 150.0),
                          const SizedBox(height: 8.0),
                          TextButton.icon(
                            onPressed: _deleteImage,
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: const Text(
                              'Delete Image',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Select Image'),
                ),
                const SizedBox(height: 16.0),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  BlocBuilder<UploadBloc, UploadState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: _uploadCard,
                        child: const Text('Upload Gift Card'),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
