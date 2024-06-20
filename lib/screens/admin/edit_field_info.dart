import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sportify_app/dto/fields.dart';
import 'package:sportify_app/endpoints/endpoints.dart';
import 'package:sportify_app/widgets/button.dart';
import 'package:sportify_app/widgets/flexible_form_input.dart';
import 'package:sportify_app/services/data_service.dart';

class EditFieldScreen extends StatefulWidget {
  final FieldDetail field;

  const EditFieldScreen({
    super.key,
    required this.field,
  });

  @override
  _EditFieldScreenState createState() => _EditFieldScreenState();
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
    _imagePath = widget.field.gambarLapangan ?? '';
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
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        debugPrint('Error posting data: ${response.statusCode}');
      }
    });
  }

  // void _saveField() async {
  //   FieldDetail updatedField = FieldDetail(
  //     idLapangan: widget.field.idLapangan,
  //     idJenisLapangan: widget.field.idJenisLapangan,
  //     courtName: _nameController.text,
  //     description: _descriptionController.text,
  //     location: _locationController.text,
  //     price: int.parse(_priceController.text),
  //     gambarLapangan: _imagePath,
  //   );

  //   try {
  //     await DataService.updateField(updatedField);
  //     // Show success message or navigate back
  //   } catch (e) {
  //     // Handle error
  //     print('Error updating field: $e');
  //     // Show error message
  //   }
  // }

  void _deleteField() async {
    try {
      await DataService.deleteField(widget.field.idLapangan);
      // Show success message or navigate back
    } catch (e) {
      // Handle error
      print('Error deleting field: $e');
      // Show error message
    }
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
              Row(
                children: [
                  galleryFile == null
                      ? FadeInImage.assetNetwork(
                          placeholder: 'assets/images/home_bg.jpg',
                          image: '${Endpoints.showImage}/$_imagePath',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                          placeholderErrorBuilder:
                              (context, error, stackTrace) {
                            debugPrint('Error loading image: $error');
                            return Container();
                          },
                          imageErrorBuilder: (context, error, stackTrace) {
                            debugPrint('Error: $error');
                            return Container();
                          },
                          fadeOutDuration: const Duration(seconds: 30),
                        )
                      : Image.file(
                          galleryFile!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      _showPicker(context: context);
                    },
                    child: const Text('Pick Image'),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    AppButton(
                      type: ButtonType.PRIMARY,
                      onPressed: () {
                        _postDataWithImage(context);
                      },
                      text: 'Save',
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                      type: ButtonType.PRIMARY,
                      onPressed: _deleteField,
                      text: 'Delete',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
