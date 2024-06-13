import 'package:flutter/material.dart';
import 'package:sportify_app/dto/fields.dart';
import 'package:sportify_app/utils/constants.dart';
import 'package:intl/intl.dart';
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
                Constants.scaffoldBackgroundColor
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/${field.fileName}',
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
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
                // Uncomment if using Google Maps
                // Container(
                //   width: double.infinity,
                //   height: 200,
                //   child: GoogleMap(
                //     initialCameraPosition: CameraPosition(
                //       target: LatLng(field.latitude, field.longitude),
                //       zoom: 14,
                //     ),
                //     markers: {
                //       Marker(
                //         markerId: MarkerId(field.courtName),
                //         position: LatLng(field.latitude, field.longitude),
                //         infoWindow: InfoWindow(title: field.courtName),
                //       ),
                //     },
                //   ),
                // ),
                const SizedBox(height: 10),
                Text(
                  'Hourly price:  \$${field.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
              Container(
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
              Container(
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
                  child: AppButton(
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
