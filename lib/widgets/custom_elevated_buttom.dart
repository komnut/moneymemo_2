import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomElevatedButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(150, 50),
        backgroundColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(
            color: Colors.transparent,
            width: 1,
          ),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          letterSpacing: 0.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
