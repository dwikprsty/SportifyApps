import 'package:flutter/material.dart';
import 'package:sportify_app/dto/fields.dart';
import 'package:sportify_app/widgets/button.dart';
import 'package:sportify_app/widgets/flexible_form_input.dart';

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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.field.courtName);
    _descriptionController =
        TextEditingController(text: widget.field.description);
    _priceController =
        TextEditingController(text: widget.field.price.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveField() {
// Implement save functionality
// e.g., make API call to update field details
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Field'),
      ),
      body: Padding(
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
//keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 40),
            Center(
              child: AppButton(
                type: ButtonType.PRIMARY,
                onPressed: _saveField,
                text: 'Save',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
