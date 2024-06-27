import 'package:flutter/material.dart';
import 'package:sportify_app/utils/constants.dart';

class FlexibleInputWidget extends StatelessWidget {
  final String hintText;
  final String topLabel;
  final String? value;
  final List<String>? items; // Null jika bukan dropdown
  final ValueChanged<String?>? onChanged;
  final Color fillColor;
  final IconData? prefixIcon;
  final double height;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final ValueChanged<String?>? onTextChanged;
  final dynamic onTap;
  final bool readOnly;
  final bool isDropdown;
  final TextInputType? keyboardType;
  final bool enabled; // Tambahkan properti enabled

  const FlexibleInputWidget({
    Key? key,
    required this.hintText,
    this.topLabel = "",
    this.value,
    this.items,
    this.onChanged,
    this.fillColor = Constants.scaffoldBackgroundColor,
    this.prefixIcon,
    this.height = 48.0,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
    this.onTextChanged,
    this.onTap,
    this.readOnly = false,
    this.isDropdown = false,
    this.keyboardType,
    this.enabled = true, // Tambahkan properti enabled dengan nilai default true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (topLabel.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              topLabel,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        if (isDropdown)
          DropdownButtonFormField<String>(
            value: value?.isNotEmpty == true && items?.contains(value) == true ? value : null,
            hint: Text(hintText),
            items: items?.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: fillColor,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            ),
          )
        else
          Container(
            height: height,
            decoration: BoxDecoration(
              color: Constants.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextFormField(
              controller: controller,
              enabled: enabled, // Gunakan properti enabled di dalam TextFormField
              obscureText: obscureText,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Constants.secondaryColor,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Constants.primaryColor,
                  ),
                ),
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontSize: 14.0,
                  color: Color.fromRGBO(105, 108, 121, 0.7),
                ),
                prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
                suffixIcon: suffixIcon,
              ),
              onChanged: onTextChanged,
              onTap: onTap,
              readOnly: readOnly,
              keyboardType: keyboardType,
            ),
          ),
      ],
    );
  }
}
