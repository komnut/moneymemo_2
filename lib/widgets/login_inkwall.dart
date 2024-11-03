import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneymemo_2/screens/register_screen.dart';
import 'package:moneymemo_2/widgets/text_inter.dart';

class regiesterAccount extends StatelessWidget {
  const regiesterAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const RegisterScreen(), // เปิดหน้าจอ RegisterScreen
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
              const TextInter(
                title: "Don't have an account?",
                textSize: 15,
                hexcolor: "#57636C",
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 4, 0),
                child: Text(
                  "Create",
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.primary,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              )
            ]),
      ),
    );
  }
}
