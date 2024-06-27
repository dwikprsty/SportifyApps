import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sportify_app/dto/fields.dart';
import 'package:sportify_app/endpoints/endpoints.dart';
import 'package:sportify_app/utils/constants.dart';
import 'package:sportify_app/widgets/button.dart';
import 'package:sportify_app/widgets/flexible_form_input.dart';

class EditFieldScreen extends StatefulWidget {
  final FieldDetail field;

  const EditFieldScreen({
    super.key,
    required this.field,
  });

  @override
  State<EditFieldScreen> createState() => _EditFieldScreenState();
}

class _EditFieldScreenState extends State<EditFieldScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _locationController;
  late String _imagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.field.courtName);
    _descriptionController =
        TextEditingController(text: widget.field.description);
    _priceController =
        TextEditingController(text: widget.field.price.toString());
    _imagePath = widget.field.gambarLapangan;
    _locationController = TextEditingController(text: widget.field.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  File? galleryFile;
  final picker = ImagePicker();

  _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Nothing is selected'),
            backgroundColor: Colors.red,
          ));
        }
      },
    );
  }

  Future<void> _postDataWithImage(BuildContext context) async {
    var request = MultipartRequest('PUT', Uri.parse(Endpoints.updateField));
    request.fields['id_lapangan'] = widget.field.idLapangan;
    request.fields['nama_lapangan'] = _nameController.text;
    request.fields['deskripsi'] = _descriptionController.text;
    request.fields['harga_sewa'] = _priceController.text;

    if (galleryFile != null) {
      var multipartFile = await MultipartFile.fromPath(
        'gambar_lapangan',
        galleryFile!.path,
      );
      request.files.add(multipartFile);
    }

    request.send().then((response) {
      // Handle response (success or error)
      if (response.statusCode == 201) {
        debugPrint('Data and image posted successfully!');
        Navigator.pop(context, true);
      } else {
        debugPrint('Error posting data: ${response.statusCode}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Field'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlexibleInputWidget(
                topLabel: 'Name',
                controller: _nameController,
                hintText: 'Enter field name',
              ),
              const SizedBox(height: 20),
              FlexibleInputWidget(
                topLabel: 'Description',
                controller: _descriptionController,
                hintText: 'Enter field description',
              ),
              const SizedBox(height: 20),
              FlexibleInputWidget(
                topLabel: 'Price',
                controller: _priceController,
                hintText: 'Enter price per hour',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  galleryFile == null
                      ? FadeInImage.assetNetwork(
                          placeholder: 'assets/images/loading_image.png',
                          image: '${Endpoints.showImage}/$_imagePath',
                          fit: BoxFit.cover,
                          width: 350,
                          height: 170,
                          placeholderErrorBuilder:
                              (context, error, stackTrace) {
                            debugPrint('Error loading image: $error');
                            return Image.asset(
                              'assets/images/failed_placeholder.png',
                              fit: BoxFit.cover,
                            );
                          },
                          imageErrorBuilder: (context, error, stackTrace) {
                            debugPrint('Error: $error');
                            return Image.asset(
                              'assets/images/failed_image.png',
                              fit: BoxFit.cover,
                            );
                          },
                          fadeOutDuration: const Duration(seconds: 30),
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
                    color: Colors.black.withOpacity(0.5), // Opacity 0.5
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Constants.activeMenu)),
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
