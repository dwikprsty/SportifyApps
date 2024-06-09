import 'dart:io';
import 'package:sportify_app/endpoints/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:sportify_app/dto/cs.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sportify_app/utils/constants.dart';
import 'package:sportify_app/widgets/button.dart';
import 'package:sportify_app/widgets/form.dart';

class CSFormScreen extends StatefulWidget {
  final CustomerService? item;

  const CSFormScreen({this.item, Key? key}) : super(key: key);

  @override
  _CSFormScreenState createState() => _CSFormScreenState();
}

class _CSFormScreenState extends State<CSFormScreen> {
  final _titleController = TextEditingController();
  String _title = "";
  final _deskripsiController = TextEditingController();
  String _deskripsi = "";
  int _rating = 0;
  File? galleryFile;
  final picker = ImagePicker();
  String _selectedDivision = 'Dailing'; 
  double _priority = 0; 

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      // Inisialisasi nilai default berdasarkan item
      // _selectedDivision = widget.item!.division ?? 'Dailing';
      // _priority = widget.item!.priority ?? 0;
      _titleController.text = widget.item!.title ?? '-';
      _deskripsiController.text = widget.item!.description ?? '-';
      _rating = widget.item!.rating ?? 0;
      print('Item: ${widget.item?.idCustomerService}');
    } else {
      print('Item is null');
    }
  }

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

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  saveData() {
    // Validasi input
    if (_titleController.text.isEmpty ||
        _deskripsiController.text.isEmpty ||
        _rating == 0 ||
        galleryFile == null) {
      // Tampilkan snackbar peringatan jika ada field yang kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Hentikan fungsi saveData() jika ada field yang kosong
    }

    // Lanjutkan menyimpan data jika semua field telah diisi
    debugPrint(_title);
  }

  Future<void> _postDataWithImage(BuildContext context) async {
    // Validasi input
    if (_titleController.text.isEmpty ||
        _deskripsiController.text.isEmpty ||
        _rating == 0 ||
        galleryFile == null) {
      // Tampilkan snackbar peringatan jika ada field yang kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Hentikan proses jika ada field yang kosong
    }

    // Lanjutkan dengan mengirim data jika semua field telah diisi
    if (galleryFile == null) {
      // Handle case where no image is selected
      // Tampilkan snackbar peringatan jika gambar tidak dipilih
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Hentikan proses jika gambar tidak dipilih
    }

    var request = MultipartRequest('POST', Uri.parse(Endpoints.cs));
    request.fields['title_issues'] = _titleController.text;
    request.fields['description_issues'] = _deskripsiController.text;
    request.fields['rating'] = _rating.toString();

    var multipartFile = await MultipartFile.fromPath(
      'image',
      galleryFile!.path,
    );
    request.files.add(multipartFile);

    request.send().then((response) {
      // Handle response (success or error)
      if (response.statusCode == 201) {
        debugPrint('Data and image posted successfully!');
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/customer-screen');
      } else {
        debugPrint('Error posting data: ${response.statusCode}');
      }
    });
  }

  Future<void> _editData(BuildContext context) async {
    var request = MultipartRequest(
        'POST', Uri.parse('${Endpoints.cs}/${widget.item?.idCustomerService}'));

    if (galleryFile != null) {
      var multipartFile = await MultipartFile.fromPath(
        'image',
        galleryFile!.path,
      ); // Handle case where no image is selected
      request.files.add(multipartFile);
    }

    request.fields['title_issues'] = _titleController.text;
    //tambah deskripsi
    request.fields['description_issues'] = _deskripsiController.text;
    //tambahrating

    request.fields['rating'] = _rating.toString();

    print(_titleController.text);
    print(_deskripsiController.text);
    print(widget.item?.rating);
    request.send().then((response) {
      // Handle response (success or error)
      if (response.statusCode == 200) {
        // Data updated successfully
        print("success");
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/customer-screen');
      } else {
        // Handle error
        print('Failed to update data: ${response.statusCode}');
      }
    }).catchError((error) {
      // Handle other errors
      print('Error updating data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.item == null
              ? 'Create Customer Datas'
              : 'Edit Customer Datas'),
          style: const TextStyle(
            fontSize: 23,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Constants.secondaryColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white), 
      ),
      // ignore: sized_box_for_whitespace
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/home_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Constants.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Constants.primaryColor,
                            blurRadius: 20,
                            offset: Offset(0, 10))
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        InputWidget(
                          hintText: 'Input title issues',
                          topLabel: 'Title Issues',
                          controller: _titleController,
                          onChanged: (value) {
                            setState(() {
                              _title = value;
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            _showPicker(context: context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                            ),
                            width: double.infinity,
                            height: 150,
                            child: galleryFile == null && widget.item == null
                                ? const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.upload_file,
                                          size: 45,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          'Pick your Image here',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color.fromARGB(
                                                255, 124, 122, 122),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : galleryFile != null
                                    ? Center(
                                        child: Image.file(galleryFile!),
                                      )
                                    : Image.network(
                                        Uri.parse(
                                                '${Endpoints.baseURLLive}/public/${widget.item!.imageUrl!}')
                                            .toString(),
                                        width: 100,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.error),
                                      ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: InputWidget(
                            height: 50,
                            hintText: 'Input description issues',
                            topLabel: 'Description Issues',
                            controller: _deskripsiController,
                            onChanged: (value) {
                              setState(() {
                                _deskripsi = value;
                              });
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade200))),
                          child: Column(
                            children: [
                              const Text(
                                'Give a rating',
                                style: TextStyle(fontSize: 20),
                              ),
                              RatingBar.builder(
                                initialRating:
                                    widget.item?.rating?.toDouble() ??
                                        0.0, // 0.0 sebagai nilai default
                                minRating: 0,
                                maxRating: 5,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemSize: 40,
                                itemBuilder: (context, index) {
                                  IconData iconData = index < _rating
                                      ? Icons.star
                                      : Icons.star_border;
                                  return Icon(
                                    iconData,
                                    color: index < _rating
                                        ? Colors.amber
                                        : Colors.grey,
                                  );
                                },
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    _rating = rating.toInt();
                                  });
                                },
                              ),
                              DropdownButtonFormField<String>(
                          value: _selectedDivision,
                          decoration: const InputDecoration(
                            labelText: 'Division ',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedDivision = newValue!;
                            });
                          },
                          items: <String>['Dailing', 'Teknis', 'Support']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        Slider(
                          activeColor: Constants.primaryColor,
                          value: _priority,
                          onChanged: (newValue) {
                            setState(() {
                              _priority = newValue;
                            });
                          },
                          min: 0,
                          max: 10, // nilai priority maximum
                          divisions: 10, // Divide the slider into 10 divisions
                          label: _priority.toString(),
                        ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: AppButton(
                    type: ButtonType.PRIMARY,
                    onPressed: () {
                      widget.item?.idCustomerService == null
                          ? _postDataWithImage(context)
                          : _editData(context);
                    },
                    text: (widget.item == null ? 'Add Datas' : 'Save Datas'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}