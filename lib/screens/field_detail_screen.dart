import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sportify_app/cubit/auth/auth_cubit.dart';
import 'package:sportify_app/dto/fields.dart';
import 'package:sportify_app/screens/admin/edit_field_info.dart';
import 'package:sportify_app/utils/constants.dart';
import 'package:sportify_app/utils/helper.dart';
import 'package:sportify_app/widgets/button.dart';
import 'package:sportify_app/widgets/flexible_form_input.dart';

class FieldDetailScreen extends StatefulWidget {
  final FieldDetail fieldDetail;

  const FieldDetailScreen({
    super.key,
    required this.fieldDetail,
  });

  @override
  _FieldDetailScreenState createState() => _FieldDetailScreenState();
}

class _FieldDetailScreenState extends State<FieldDetailScreen> {
  String? _selectedDate;
  String? _selectedTime;
  String? _selectedDuration;
  bool isAdmin = true; 

  @override
  void initState() {
    super.initState();
    isAdmin = context.read<AuthCubit>().state.dataUser!.isAdmin;
  }

  final List<String> _times = [
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
    '19:00',
    '20:00',
  ];

  final List<String> _durations = [
    '1 Hour',
    '2 Hours',
    '3 Hours',
    '4 Hours',
  ];

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

  @override
  Widget build(BuildContext context) {
    final field = widget.fieldDetail;
    return Scaffold(
      appBar: AppBar(
        title: Text(field.courtName),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
                Image.network(
                  field.gambarLapangan, // URL gambar lapangan dari API
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.error), // Menangani error jika gambar gagal dimuat
                ),
                const SizedBox(height: 20),
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  field.description,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 20),
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
                FlexibleInputWidget(
                  topLabel: 'Date',
                  hintText: 'Select date',
                  controller: TextEditingController(text: _selectedDate),
                  suffixIcon: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context),
                  readOnly: true,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: FlexibleInputWidget(
                        isDropdown: true,
                        topLabel: 'Time',
                        hintText: 'Select Time',
                        value: _selectedTime,
                        items: _times,
                        onChanged: (value) {
                          setState(() {
                            _selectedTime = value!;
                          });
                        },
                        fillColor: Constants.scaffoldBackgroundColor,
                      ),
                    ),
                    SizedBox(
                      width: 180,
                      child: FlexibleInputWidget(
                        isDropdown: true,
                        topLabel: 'Duration',
                        hintText: 'Select Duration',
                        value: _selectedDuration,
                        items: _durations,
                        onChanged: (value) {
                          setState(() {
                            _selectedDuration = value!;
                          });
                        },
                        fillColor: Constants.scaffoldBackgroundColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Center(
                  child: isAdmin
                      ? AppButton(
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
                        )
                      : AppButton(
                          type: ButtonType.PRIMARY,
                          onPressed: () {
                            // Implement booking functionality
                          },
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
