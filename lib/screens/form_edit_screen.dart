import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneymemo_2/services/asset_services.dart';
import 'package:moneymemo_2/widgets/custom_date_picker.dart';
import 'package:moneymemo_2/widgets/custom_dropdown_button_form_field.dart';
import 'package:moneymemo_2/widgets/custom_elevated_buttom.dart';
import 'package:moneymemo_2/widgets/custom_scaffold_messager.dart';
import 'package:moneymemo_2/widgets/custom_text_form_field.dart';

class TransactionEditScreen extends StatefulWidget {
  final String assetId; // เพิ่ม parameter เพื่อรับ id ของ asset ที่จะแก้ไข

  const TransactionEditScreen({super.key, required this.assetId});

  @override
  _TransactionEditScreenState createState() => _TransactionEditScreenState();
}

class _TransactionEditScreenState extends State<TransactionEditScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  // Controllers
  final assetNameController = TextEditingController();
  final assetAmountController = TextEditingController();
  final expiredDateController = TextEditingController();

  final FirestoreService _firestoreService =
      FirestoreService(); // สร้าง instance ของ FirestoreService

  // Form field state
  String? selectedAssetType;

  @override
  void initState() {
    super.initState();
    _loadAssetData();
  }

  // ฟังก์ชันดึงข้อมูล asset จาก Firestore เพื่อแสดงในฟอร์ม
  void _loadAssetData() async {
    try {
      Asset asset = await _firestoreService.getAssetById(
          widget.assetId, auth.currentUser!.email!);
      setState(() {
        assetNameController.text = asset.assetName;
        assetAmountController.text = asset.assetAmount.toString();
        expiredDateController.text = asset.expiredDate ?? '';
        selectedAssetType = asset.assetType;
      });
    } catch (e) {
      CustomScaffoldMessengerWidget.showCustomSnackBar(
        context: context,
        content: "Failed to load asset data.",
        durationInSeconds: 2,
      );
    }
  }

  String? validateExpiredDate(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      DateTime inputDate = DateFormat('dd/MM/yyyy').parse(value);
      if (inputDate.isBefore(DateTime.now())) {
        return 'Please input expired date more than today';
      }
    } catch (e) {
      return 'Invalid date format. Please use dd/MM/yyyy';
    }
    return null;
  }

  // ฟังก์ชันสำหรับตรวจสอบและบันทึกข้อมูล (อัปเดตข้อมูลใน Firestore)
  void _submitForm() {
    if (formKey.currentState!.validate()) {
      print("validate completed!!");

      // รับข้อมูลจากฟอร์ม
      String assetName = assetNameController.text;
      double assetAmount = double.tryParse(assetAmountController.text) ?? 0.0;
      String assetType = selectedAssetType ??
          "asset"; // ใช้ค่าเริ่มต้นเป็น "asset" ถ้าไม่มีการเลือก
      String? expiredDate = expiredDateController.text.isNotEmpty
          ? expiredDateController.text
          : null;
      DateTime now = DateTime.now();

      // สร้าง object Asset
      Asset updatedAsset = Asset(
        id: widget.assetId, // ใช้ assetId จาก parameter
        assetName: assetName,
        assetAmount: assetAmount,
        assetType: assetType,
        expiredDate: expiredDate,
        createdDate: now,
        updatedDate: now,
      );

      // อัปเดตข้อมูลลง Firestore
      _firestoreService
          .updateAsset(updatedAsset, auth.currentUser!.email!)
          .then((_) {
        // เมื่ออัปเดตเสร็จแล้ว แสดงข้อความ
        CustomScaffoldMessengerWidget.showCustomSnackBar(
          context: context,
          content: "Asset updated successfully!",
          durationInSeconds: 2,
        );
        Navigator.pop(context);
      }).catchError((e) {
        // หากเกิดข้อผิดพลาด
        print(e);
        CustomScaffoldMessengerWidget.showCustomSnackBar(
          context: context,
          content: "Failed to update asset.",
          durationInSeconds: 2,
        );
      });
    } else {
      CustomScaffoldMessengerWidget.showCustomSnackBar(
        context: context,
        content: "Validation failed!",
        durationInSeconds: 1,
      );
    }
  }

  Widget _buildTextInputField({
    required String hintText,
    required String labelText,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required TextInputType keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return CustomTextFormField(
      hintText: hintText,
      labelText: labelText,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
    );
  }

  Widget _buildDropdownField() {
    return CustomDropdownButtonFormField(
      hintText: "Asset Type..",
      labelText: "Asset Type",
      value: selectedAssetType,
      items: ["asset", "debt"],
      onChanged: (value) {
        setState(() => selectedAssetType = value);
      },
      validator: (value) =>
          value == null || value.isEmpty ? "Asset Type is required" : null,
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        width: double.infinity,
        child: CustomElevatedButton(
          onPressed: onPressed,
          text: text,
          color: color,
        ),
      ),
    );
  }

  List<TextInputFormatter> _getDecimalInputFormatters() {
    return [
      FilteringTextInputFormatter.allow(
          RegExp(r'^\d*\.?\d*$')), // อนุญาตให้กรอกตัวเลขและจุดทศนิยม
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Asset/Debt',
          style: GoogleFonts.readexPro(fontSize: 30, color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextInputField(
                  hintText: "Asset name..",
                  labelText: "Asset Name",
                  controller: assetNameController,
                  validator:
                      RequiredValidator(errorText: "Asset name is required")
                          .call,
                  keyboardType: TextInputType.text,
                ),
                _buildTextInputField(
                  hintText: "Amount..",
                  labelText: "Amount",
                  controller: assetAmountController,
                  validator:
                      RequiredValidator(errorText: "Amount is required").call,
                  keyboardType: TextInputType.number,
                  inputFormatters: _getDecimalInputFormatters(),
                ),
                _buildDropdownField(),
                ExpiredDatePicker(
                  hintText: "Expired date..",
                  labelText: "Expired Date",
                  controller: expiredDateController,
                  validator: validateExpiredDate,
                ),
                _buildActionButton(
                  text: 'Save changes',
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: _submitForm,
                ),
                _buildActionButton(
                  text: 'Back',
                  color: Theme.of(context).colorScheme.inversePrimary,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
