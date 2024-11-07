import 'package:flutter/material.dart';

class LogoImage extends StatelessWidget {
  const LogoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      // width: 170,
      height: 100,
      fit: BoxFit.fitWidth,
    );
  }
}
