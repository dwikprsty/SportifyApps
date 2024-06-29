import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sportify_app/cubit/auth/auth_cubit.dart';
import 'package:sportify_app/endpoints/endpoints.dart';
import 'package:sportify_app/services/data_service.dart';
import 'package:sportify_app/utils/constants.dart';
import 'package:sportify_app/widgets/button.dart';
import 'package:sportify_app/widgets/flexible_form_input.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _selectedGender;
  String? _selectedBirthday;
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool isEditing = false;
  bool isEditingProfileImage = false;

  File? galleryFile;
  final picker = ImagePicker();
  late String userProfileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = context.read<AuthCubit>().state.dataUser;
    if (user != null) {
      _nicknameController.text = user.nickname;
      _usernameController.text = '@${user.namaPengguna}';
      _addressController.text = user.alamat;
      _emailController.text = user.email;
      debugPrint(user.noTelp);
      _phoneController.text = user.noTelp;
      _selectedGender = user.jenisKelamin;
      _selectedBirthday = user.tglLahir;
      debugPrint(user.tglLahir);
      _birthdayController.text = formatDate.format(user.tglLahir.contains('GMT')
          ? formatDate2.parse(user.tglLahir)
          : DateTime.parse(user.tglLahir));
      _selectedGender = user.jenisKelamin;

      // Load user profile image URL from API
      userProfileImageUrl =
          '${Endpoints.showImage}/${user.fotoProfil}'; // Adjust the endpoint according to your API
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

  Future<void> _postDataWithImage(BuildContext context) async {
    var request = MultipartRequest(
        'PUT',
        Uri.parse(
            '${Endpoints.updateUser}/${context.read<AuthCubit>().state.dataUser!.idPengguna}'));
    request.fields['nama_pengguna'] = _usernameController.text;
    request.fields['nickname'] = _nicknameController.text;
    request.fields['email'] = _emailController.text;
    request.fields['alamat'] = _addressController.text;
    request.fields['jenis_kelamin'] = _selectedGender!;
    request.fields['tgl_lahir'] = _selectedBirthday!;
    request.fields['no_telp'] = _phoneController.text;

    if (galleryFile != null) {
      var multipartFile = await MultipartFile.fromPath(
        'foto_profil',
        galleryFile!.path,
      );
      request.files.add(multipartFile);
    }

    request.send().then((response) async {
      // Handle response (success or error)
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        final dataUser = await DataService.fetchUser(
            context.read<AuthCubit>().state.dataUser!.idPengguna.toString());
        debugPrint(dataUser.toString());
        context.read<AuthCubit>().updateUser(dataUser);
        _loadUserData();
        setState(() {
          _toggleEditing();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: ${response.statusCode}'),
          ),
        );
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _selectedBirthday = "${picked.toLocal()}".split(' ')[0];
        _birthdayController.text = _selectedBirthday!;
      });
    }
  }

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
      if (!isEditing) {
        // Clear galleryFile when exiting edit mode if not editing profile image
        if (!isEditingProfileImage) {
          galleryFile = null;
        }
      }
      isEditingProfileImage = isEditing;

      // Remove @ prefix if present and update the username field
      String currentUsername = _usernameController.text.trim();
      if (currentUsername.isNotEmpty && currentUsername.startsWith('@')) {
        _usernameController.text = currentUsername.substring(1); // Remove @
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Color.fromARGB(255, 90, 137, 158),
                        Constants.scaffoldBackgroundColor,
                      ],
                      focal: Alignment.center,
                      radius: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 3),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundImage:
                                  const AssetImage('assets/images/avatar.png'),
                              child: ClipOval(
                                child: galleryFile != null
                                    ? Image.file(
                                        galleryFile!,
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                      )
                                    : FadeInImage.assetNetwork(
                                        placeholder: 'assets/images/avatar.png',
                                        image:
                                            '${Endpoints.showImage}/${context.read<AuthCubit>().state.dataUser!.fotoProfil}',
                                        fit: BoxFit.cover,
                                        placeholderErrorBuilder:
                                            (context, error, stackTrace) {
                                          debugPrint(
                                              'Error loading image: $error');
                                          return Image.asset(
                                            'assets/images/avatar_loading.png',
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 100,
                                          );
                                        },
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          debugPrint('Error: $error');
                                          return Image.asset(
                                            'assets/images/avatar_error.png',
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 100,
                                          );
                                        },
                                        fadeOutDuration:
                                            const Duration(seconds: 60),
                                        width: 100,
                                        height: 100,
                                      ),
                              ),
                            ),
                            if (isEditing)
                              GestureDetector(
                                onTap: () {
                                  _showPicker(context: context);
                                },
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                      Colors.black.withOpacity(0.6),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          context.read<AuthCubit>().state.dataUser?.nickname ??
                              "User",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '@${context.read<AuthCubit>().state.dataUser?.namaPengguna ?? " "}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        FlexibleInputWidget(
                          hintText: "Input your nickname",
                          topLabel: "Nickname",
                          controller: _nicknameController,
                          readOnly: !isEditing,
                        ),
                        const SizedBox(height: 15),
                        FlexibleInputWidget(
                          hintText: "Input your username",
                          topLabel: "Username",
                          controller: _usernameController,
                          readOnly: !isEditing,
                          onChanged: isEditing
                              ? (value) {
                                  // Check if input is not empty and not starts with @
                                  if (value != null &&
                                      value.isNotEmpty &&
                                      !value.startsWith('@')) {
                                    _usernameController.text = '@$value';
                                  } else {
                                    // If already starts with @ or empty, leave it as is
                                    _usernameController.text = value ?? '';
                                  }
                                }
                              : null,
                        ),
                        const SizedBox(height: 15),
                        FlexibleInputWidget(
                          hintText: "Input your email address",
                          topLabel: "Email address",
                          controller: _emailController,
                          readOnly: true,
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: FlexibleInputWidget(
                                isDropdown: true,
                                topLabel: 'Gender',
                                hintText: "Select gender",
                                value: _selectedGender,
                                items: const ["man", "woman"],
                                onChanged: isEditing
                                    ? (value) {
                                        setState(() {
                                          _selectedGender = value;
                                        });
                                      }
                                    : null,
                                readOnly: !isEditing,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: FlexibleInputWidget(
                                hintText: "Your birthday",
                                suffixIcon: const Icon(Icons.calendar_today),
                                // topLabel: "Birthday",
                                topLabel: 'Birthday',
                                controller: _birthdayController,
                                readOnly: true,
                                birthDay: true,
                                onTap: isEditing
                                    ? () => _selectDate(context)
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        FlexibleInputWidget(
                          hintText: "Input your address",
                          topLabel: "Address",
                          controller: _addressController,
                          readOnly: !isEditing,
                        ),
                        const SizedBox(height: 15),
                        FlexibleInputWidget(
                          hintText: 'Input your phone number',
                          topLabel: 'Phone number',
                          controller: _phoneController,
                          readOnly: !isEditing,
                        ),
                        const SizedBox(height: 50),
                        AppButton(
                          type:
                              isEditing ? ButtonType.PLAIN : ButtonType.PRIMARY,
                          onPressed: () {
                            isEditing
                                ? _postDataWithImage(context)
                                : _toggleEditing();
                          },
                          text: isEditing ? 'Save' : 'Edit',
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
