import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/constants.dart';

class SearchWidget extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final double height;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const SearchWidget({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.height = 48.0,
    this.suffixIcon,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5.0),
        Container(
          height: ScreenUtil().setHeight(height),
          decoration: BoxDecoration(
            color: Constants.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextFormField(
            controller: controller, 
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
              suffixIcon: const Icon(Icons.search),
            ),
            onChanged: onChanged,
          ),
        )
      ],
    );
  }
}
