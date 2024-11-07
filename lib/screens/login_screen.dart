import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moneymemo_2/screens/myasset_screen.dart';
import 'package:moneymemo_2/services/auth_service.dart'; // Import the AuthService
import 'package:moneymemo_2/widgets/custom_elevated_buttom.dart';
import 'package:moneymemo_2/widgets/custom_text_form_field.dart';
import 'package:moneymemo_2/widgets/customer_text_button.dart';
import 'package:moneymemo_2/widgets/login_inkwall.dart';
import 'package:moneymemo_2/widgets/logo_image.dart';
import 'package:moneymemo_2/widgets/text_readexpro.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService(); // Initialize AuthService

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    User? user = await _authService.getCurrentUser();
    if (user != null) {
      // User is already logged in, navigate to the main screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyAssetScreen(username: user.email ?? ""),
        ),
      );
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authService.loginWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // Navigate to your home screen upon successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyAssetScreen(
              username: emailController.text,
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      print("Validation failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                          padding:
                              EdgeInsetsDirectional.fromSTEB(24, 24, 0, 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [logoImage()],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24, 0, 24, 0),
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      TextReadexpro(
                                        title: "Welcome back",
                                        textSize: 30,
                                        hexcolor: "#000000",
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 5, 0, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          'Login to access your account below.',
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
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
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
                                      keyboardType: TextInputType.text,
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
                                    keyboardType: TextInputType.text,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomTextButton(
                                        onPressed: () {
                                          print("Click Forget Password");
                                        },
                                        text: "",
                                      ),
                                      CustomElevatedButton(
                                        onPressed: _login,
                                        text: 'Login',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      )
                                    ],
                                  ),
                                  const Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [regiesterAccount()],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
