import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneymemo_2/widgets/custom_date_picker.dart';
import 'package:moneymemo_2/widgets/custom_dropdown_button_form_field.dart';
import 'package:moneymemo_2/widgets/custom_elevated_buttom.dart';
import 'package:moneymemo_2/widgets/custom_text_form_field.dart';

class TransactionADDScreen extends StatefulWidget {
  const TransactionADDScreen({super.key});

  @override
  _TransactionADDScreenState createState() => _TransactionADDScreenState();
}

class _TransactionADDScreenState extends State<TransactionADDScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final assetNameController = TextEditingController();
  final assetAmountController = TextEditingController();
  String? selectedAssetType;
  final expiredDateController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? validateExpiredDate(String? value) {
    if (value != null && value.isNotEmpty) {
      // Convert the string to DateTime
      try {
        DateTime inputDate =
            DateFormat('dd/MM/yyyy').parse(value); // Specify the format used
        DateTime today = DateTime.now();

        // Compare the input date with today
        if (inputDate.isBefore(today)) {
          return 'Please input expired date more than today';
        }
      } catch (e) {
        return 'Invalid date format. Please use dd/MM/yyyy';
      }
    }

    return null; // Validation passed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(
          'Add Asset/Debt',
          style: GoogleFonts.readexPro(
            textStyle: const TextStyle(
              fontSize: 30,
              color: Colors.black,
              letterSpacing: 0.0,
            ),
          ),
        ),
        centerTitle: false,
        // elevation: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                // height: MediaQuery.sizeOf(context).height * 1,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
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
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 20, 0, 0),
                                child: CustomTextFormField(
                                  hintText: "Asset name..",
                                  labelText: "Asset Name",
                                  controller: assetNameController,
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "Asset name is required"),
                                  ]).call,
                                ),
                              ),
                              CustomTextFormField(
                                hintText: "Amount..",
                                labelText: "Amonut",
                                controller: assetAmountController,
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "Amonut is required"),
                                ]).call,
                              ),
                              CustomDropdownButtonFormField(
                                hintText: "Asset Type..",
                                labelText: "Asset Type",
                                value: selectedAssetType,
                                items: ["asset", "debt"],
                                onChanged: (value) {
                                  setState(() {
                                    selectedAssetType = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Asset Type is required";
                                  }
                                  return null;
                                },
                              ),
                              // CustomTextFormField(
                              //   hintText: "Expired date..",
                              //   labelText: "Expired Date",
                              //   controller: expiredDateController,
                              //   validator: validateExpiredDate,
                              // ),
                              ExpiredDatePicker(
                                hintText: "Expired date..",
                                labelText: "Expired Date",
                                controller: expiredDateController,
                                validator: validateExpiredDate,
                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 24, 0, 24),
                                child: CustomElevatedButton(
                                  onPressed: () {
                                    print("click add transaction");
                                    if (formKey.currentState!.validate()) {
                                      // registerWithEmailPassword();
                                      print("validate completed!!");
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Validation failed!')),
                                      );
                                    }
                                  },
                                  text: 'Add asset/debt',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
