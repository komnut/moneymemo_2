import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator; // เพิ่มฟิลด์ validator
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters; // เพิ่มพารามิเตอร์นี้

  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.labelText,
    this.isPassword = false,
    required this.controller,
    this.validator, // เพิ่มฟิลด์ใน constructor
    required this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword, // หากเป็นรหัสผ่านให้ซ่อนข้อความ
        validator: validator, // ใช้ validator ที่ส่งเข้ามา
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            fontSize: 16,
            letterSpacing: 0.0,
          ),
          labelText: labelText,
          labelStyle: GoogleFonts.inter(
            fontSize: 16,
            letterSpacing: 0.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0x00000000),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0x00000000),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0x00000000),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0x00000000),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
        ),
      ),
    );
  }
}
