import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:sportify_app/cubit/auth/auth_cubit.dart';
import 'package:sportify_app/dto/fields.dart';
import 'package:sportify_app/endpoints/endpoints.dart';
import 'package:sportify_app/screens/admin/edit_field_info.dart';
import 'package:sportify_app/services/data_service.dart';
import 'package:sportify_app/utils/constants.dart';
import 'package:sportify_app/widgets/button.dart';
import 'package:sportify_app/widgets/flexible_form_input.dart';
import 'package:sportify_app/dto/session.dart';

class FieldDetailScreen extends StatefulWidget {
  final FieldDetail fieldDetail;

  const FieldDetailScreen({
    super.key,
    required this.fieldDetail,
  });

  @override
  State<FieldDetailScreen> createState() => _FieldDetailScreenState();
}

class _FieldDetailScreenState extends State<FieldDetailScreen> {
  String? _selectedDate;
  Session? _selectedSession;
  List<Session> _sessions = [];
  bool _isLoading = true;
  bool isAdmin = true;

  @override
  void initState() {
    super.initState();
    isAdmin = context.read<AuthCubit>().state.dataUser!.isAdmin;
    _loadSessionTimes();
  }

  Future<void> _loadSessionTimes() async {
    try {
      final sessions = await DataService.fetchSessionTimes();
      setState(() {
        _sessions = sessions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading session times: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  DateTime convertStringToDateTime(String dateString, String timeString) {
    final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
    return dateFormat.parse("$dateString $timeString");
  }

  String convertTimeStringToDateTime(String timeString) {
    final DateFormat timeFormat = DateFormat("HH:mm");
    final DateTime time = timeFormat.parse(timeString);
    final DateFormat newTimeFormat = DateFormat("HH:mm:ss");
    return newTimeFormat.format(time);
  }

  void _confirmBooking() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Booking'),
          content: const Text('Are you sure you want to book this field?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performBooking();
              },
              child: const Text('Book Now'),
            ),
          ],
        );
      },
    );
  }

  void _performBooking() async {
    try {
      if (_selectedDate == null || _selectedSession == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a date and session.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final selectedDateTime = convertStringToDateTime(
        _selectedDate!,
        convertTimeStringToDateTime(_selectedSession!.waktu),
      );

      final response = await http.post(
        Uri.parse(Endpoints.createReservation),
        body: {
          'id_pengguna':
              context.read<AuthCubit>().state.dataUser!.idPengguna.toString(),
          'id_lapangan': widget.fieldDetail.idLapangan,
          'id_sesi': _selectedSession!.idSesi,
          'tgl_sewa': DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime),
          'harga': widget.fieldDetail.price.toString(),
        },
      );

      if (response.statusCode == 201) {
        _showBookingSuccessfulDialog();
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Waktu Sudah Berlalu'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to book: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showBookingSuccessfulDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final userData = context.read<AuthCubit>().state.dataUser!;
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'BOOKING DETAILS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const Divider(),
                const Text(
                  'Total price you have to pay:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text(
                    'IDR ${widget.fieldDetail.price}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
                Text(
                  'Name : ${userData.nickname} ',
                ),
                const SizedBox(height: 10),
                Text(
                  'Email Address : ${userData.email}',
                ),
                const SizedBox(height: 10),
                Text(
                  'Phone Number : ${userData.noTelp}',
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
                Text(
                  'Fields Name : ${widget.fieldDetail.courtName}',
                ),
                const SizedBox(height: 10),
                Text(
                  'Location : ${widget.fieldDetail.location}',
                ),
                const SizedBox(height: 10),
                Text(
                  'Date : ${DateFormat('yyyy-MM-dd').format(DateTime.parse(_selectedDate!))}',
                ),
                const SizedBox(height: 10),
                Text(
                  'Session : ${_selectedSession!.waktu}',
                ),
                const SizedBox(height: 20),
                Center(
                    child: AppButton(
                        type: ButtonType.PRIMARY,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        text: 'Close')),
              ],
            ),
          ),
        );
      },
    );
  }

  void _bookNow() {
    _confirmBooking();
  }

  void _deleteField() async {
    try {
      await DataService.deleteField(widget.fieldDetail.idLapangan);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Field deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting field: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final field = widget.fieldDetail;
    return Scaffold(
      appBar: AppBar(
        title: Text(field.courtName),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Constants.primaryColor.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/loading_image.png',
                            image:
                                '${Endpoints.showImage}/${field.gambarLapangan}',
                            width: MediaQuery.of(context).size.width,
                            height: 350,
                            fit: BoxFit.cover,
                            fadeInDuration: const Duration(milliseconds: 500),
                            fadeOutDuration: const Duration(milliseconds: 500),
                            placeholderErrorBuilder:
                                (context, error, stackTrace) {
                              debugPrint(
                                  'Error loading placeholder image: $error');
                              return Image.asset(
                                'assets/images/failed_placeholder.png',
                                fit: BoxFit.cover,
                              );
                            },
                            imageErrorBuilder: (context, error, stackTrace) {
                              debugPrint('Error loading network image: $error');
                              return Image.asset(
                                'assets/images/failed_image.png',
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        field.description,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Hourly Price',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Text(
                            'IDR :',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            field.price.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Location',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on),
                          Text(
                            field.location,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (!isAdmin)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 170,
                              child: FlexibleInputWidget(
                                topLabel: 'Date',
                                hintText: 'Select date',
                                controller:
                                    TextEditingController(text: _selectedDate),
                                suffixIcon: const Icon(Icons.calendar_today),
                                onTap: () => _selectDate(context),
                                readOnly: true,
                              ),
                            ),
                            SizedBox(
                              width: 170,
                              child: FlexibleInputWidget(
                                isDropdown: true,
                                topLabel: 'Session',
                                hintText: 'Select Session',
                                value: _selectedSession?.waktu,
                                items: _sessions
                                    .map((session) => session.waktu)
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedSession = _sessions.firstWhere(
                                        (session) => session.waktu == value);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 40),
                      Center(
                        child: isAdmin
                            ? Column(
                                children: [
                                  AppButton(
                                    type: ButtonType.PRIMARY,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditFieldScreen(
                                            field: field,
                                          ),
                                        ),
                                      );
                                    },
                                    text: 'Edit',
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  AppButton(
                                    type: ButtonType.PRIMARY,
                                    onPressed: _deleteField,
                                    text: 'Delete',
                                  ),
                                  const SizedBox(height: 40),
                                ],
                              )
                            : AppButton(
                                type: ButtonType.PRIMARY,
                                onPressed: _bookNow,
                                text: 'Book Now',
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
