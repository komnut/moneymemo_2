import 'package:flutter/material.dart';

class CustomScaffoldMessengerWidget {
  // ฟังก์ชันนี้จะสร้างและแสดง SnackBar โดยตรง
  static void showCustomSnackBar({
    required BuildContext context,
    required String content,
    int durationInSeconds = 2,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(seconds: durationInSeconds),
      ),
    );
  }
}
