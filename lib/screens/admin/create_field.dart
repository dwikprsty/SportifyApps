import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:sportify_app/endpoints/endpoints.dart';
import 'package:sportify_app/utils/constants.dart';
import 'package:sportify_app/widgets/button.dart';
import 'package:sportify_app/widgets/flexible_form_input.dart';

class CreateFieldScreen extends StatefulWidget {
  const CreateFieldScreen({super.key});

  @override
  State<CreateFieldScreen> createState() => _CreateFieldScreenState();
}

class _CreateFieldScreenState extends State<CreateFieldScreen> {
  late TextEditingController _idlapanganController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _locationController;
  String _selectedCourtType = 'JL1'; // Default to JL1 (Badminton)

  @override
  void initState() {
    super.initState();
    _idlapanganController = TextEditingController();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  void dispose() {
    _idlapanganController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  File? galleryFile;
  final picker = ImagePicker();

  _showPicker({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () async {
                  await getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  await getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(ImageSource img) async {
    final pickedFile = await picker.pickImage(source: img);
    setState(() {
      if (pickedFile != null) {
        galleryFile = File(pickedFile.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nothing is selected'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  Future<void> _postDataWithImage(BuildContext context) async {
    if (_idlapanganController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _locationController.text.isEmpty ||
        galleryFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields and image are required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    var request = http.MultipartRequest('POST', Uri.parse(Endpoints.createField));

    if (galleryFile != null) {
      var multipartFile = await http.MultipartFile.fromPath(
        'gambar_lapangan',
        galleryFile!.path,
      );
      request.files.add(multipartFile);
    }

    request.fields['id_lapangan'] = _idlapanganController.text;
    request.fields['id_jenislap'] = _selectedCourtType;
    request.fields['nama_lapangan'] = _nameController.text;
    request.fields['deskripsi'] = _descriptionController.text;
    request.fields['alamat_lapangan'] = _locationController.text;
    request.fields['harga_sewa'] = _priceController.text;

    try {
      var response = await request.send();

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Field created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating field: ${response.reasonPhrase}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error creating field: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating field: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Field'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlexibleInputWidget(
                topLabel: 'Field ID',
                controller: _idlapanganController,
                hintText: 'Input field ID',
              ),
              const SizedBox(height: 20),
              FlexibleInputWidget(
                topLabel: 'Field Name',
                controller: _nameController,
                hintText: 'Input field name',
              ),
              const SizedBox(height: 20),
              FlexibleInputWidget(
                topLabel: 'Description',
                controller: _descriptionController,
                hintText: 'Input field description',
              ),
              const SizedBox(height: 20),
              FlexibleInputWidget(
                topLabel: 'Price',
                controller: _priceController,
                hintText: 'Input hourly price',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              FlexibleInputWidget(
                topLabel: 'Location',
                controller: _locationController,
                hintText: 'Input field location',
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCourtType,
                onChanged: (value) {
                  setState(() {
                    _selectedCourtType = value!;
                  });
                },
                items: <String>[
                  'JL1 - Badminton',
                  'JL2 - Volleyball',
                  'JL3 - Basketball',
                  'JL4 - Futsal',
                  'JL5 - Tennis',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value.split(' ')[0], // Use only abbreviation as value
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Field Type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  galleryFile == null
                      ? Container(
                          width: 350,
                          height: 170,
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(Icons.image, size: 50),
                          ),
                        )
                      : Image.file(
                          galleryFile!,
                          width: 350,
                          height: 170,
                          fit: BoxFit.cover,
                        ),
                  Container(
                    width: 350,
                    height: 170,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Constants.activeMenu,
                      ),
                    ),
                    onPressed: () {
                      _showPicker(context: context);
                    },
                    child: const Text(
                      'Pick Image',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: AppButton(
                  type: ButtonType.PRIMARY,
                  onPressed: () {
                    _postDataWithImage(context);
                  },
                  text: 'Save',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
