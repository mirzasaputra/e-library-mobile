import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  TextEditingController controller;
  String label;
  bool obsecureText;
  bool readOnly;
  Icon? prefixIcon;
  Icon? suffixIcon;
  String? errorMessage;

  FormInput({
    required this.controller,
    required this.label,
    this.obsecureText = false,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.errorMessage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15.0,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: obsecureText,
          readOnly: readOnly,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            hintText: label,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 15.0,
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                color: Color(0xFF14907A),
                width: 1.0,
              ),
            ),
            
          ),
          validator: (value) {
            if(value!.isEmpty) {
              return errorMessage ?? 'Field $label is required';
            }
          },
        ),
      ],
    );
  }
}