import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moneymemo_2/screens/login_screen.dart';
import 'package:moneymemo_2/widgets/custom_elevated_buttom.dart';
import 'package:moneymemo_2/widgets/custom_text_form_field.dart';
import 'package:moneymemo_2/widgets/logo_image.dart';
import 'package:moneymemo_2/widgets/register_inkwall.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null; // ถ้าผ่านการตรวจสอบ
  }

  Future<void> registerWithEmailPassword() async {
    if (formKey.currentState!.validate()) {
      try {
        await auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Loginscreen()),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 1,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 24, 0, 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            logoImage(),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        child: SingleChildScrollView(
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Get Started',
                                      style: GoogleFonts.readexPro(
                                        textStyle: const TextStyle(
                                          fontSize: 30,
                                          color: Colors.black,
                                          letterSpacing: 0.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 5, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        'Create your account below.',
                                        style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                            fontSize: 18,
                                            color: HexColor("#57636C"),
                                            letterSpacing: 0.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 20, 0, 0),
                                  child: CustomTextFormField(
                                    hintText: "Enter your email..",
                                    labelText: "Email Address*",
                                    controller: emailController,
                                    validator: MultiValidator([
                                      RequiredValidator(
                                          errorText: "Email is required"),
                                      EmailValidator(
                                          errorText:
                                              "Enter a valid email address"),
                                    ]).call,
                                  ),
                                ),
                                CustomTextFormField(
                                  hintText: "Enter your password..",
                                  labelText: "Password*",
                                  isPassword: true,
                                  controller: passwordController,
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "Password is required"),
                                    MinLengthValidator(8,
                                        errorText:
                                            'Password must be at least 8 digits long'),
                                  ]).call,
                                ),
                                CustomTextFormField(
                                  hintText: "Enter your password..",
                                  labelText: "Confirm password*",
                                  isPassword: true,
                                  controller: confirmPasswordController,
                                  validator: validateConfirmPassword,
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 24, 0, 24),
                                  child: CustomElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        registerWithEmailPassword();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text('Validation failed!')),
                                        );
                                      }
                                    },
                                    text:
                                        'Create Account', // หรือใช้การแปลภาษาที่คุณต้องการ
                                  ),
                                ),
                                const Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [alreadyAccount()],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
