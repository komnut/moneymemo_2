import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moneymemo_2/screens/login_screen.dart';

class alreadyAccount extends StatelessWidget {
  const alreadyAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.pop(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const Loginscreen(), // เปิดหน้าจอ RegisterScreen
          ),
        );
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.8,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_back_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 24, 0),
                child: Text(
                  "Login",
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.primary,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),
              Text(
                "Already have an account?",
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    fontSize: 15,
                    color: HexColor("#57636C"),
                    letterSpacing: 0.0,
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
