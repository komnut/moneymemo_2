import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ฟังก์ชันดึงข้อมูล asset ของผู้ใช้
  Stream<List<Asset>> getUserAssets(String username) {
    return _db
        .collection('user_asset')
        .doc(username)
        .collection('asset')
        .orderBy('createdDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Asset.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  // ฟังก์ชันสำหรับดึงข้อมูล asset ตาม id
  Future<Asset> getAssetById(String assetId, String userEmail) async {
    try {
      // ดึงข้อมูลจาก Firestore โดยใช้ assetId และ userEmail
      DocumentSnapshot snapshot = await _db
          .collection(
              'user_asset') // เปลี่ยนชื่อ collection ให้ตรงกับโครงสร้างที่ใช้งาน
          .doc(userEmail) // ใช้ email เป็น document ID
          .collection('asset') // collection สำหรับเก็บ assets
          .doc(assetId) // doc ที่ต้องการดึง
          .get();

      if (snapshot.exists) {
        // แปลงข้อมูลจาก Firestore เป็นอ็อบเจ็กต์ Asset
        return Asset.fromFirestore(
            snapshot.data() as Map<String, dynamic>, snapshot.id);
      } else {
        throw Exception("Asset not found");
      }
    } catch (e) {
      throw Exception("Failed to load asset: $e");
    }
  }

  // ฟังก์ชันสำหรับบันทึกข้อมูล asset ลง Firestore
  Future<void> addAsset(Asset asset, String username) async {
    try {
      final assetRef = _db
          .collection('user_asset')
          .doc(username)
          .collection('asset')
          .doc(); // สร้าง document ใหม่ที่มี id อัตโนมัติ

      await assetRef.set(asset.toFirestore()); // บันทึกข้อมูล Asset
    } catch (e) {
      print("Error adding asset: $e");
      rethrow; // อาจจะมีการจัดการ error ที่เหมาะสม
    }
  }

  // ฟังก์ชันสำหรับอัปเดตข้อมูล asset
  Future<void> updateAsset(Asset updatedAsset, String userEmail) async {
    try {
      // อัปเดตข้อมูลใน Firestore
      await _db
          .collection('user_asset')
          .doc(userEmail)
          .collection('asset')
          .doc(updatedAsset.id) // ใช้ id ของ asset ที่จะอัปเดต
          .update({
        'assetName': updatedAsset.assetName,
        'assetAmount': updatedAsset.assetAmount,
        'assetType': updatedAsset.assetType,
        'expiredDate': updatedAsset.expiredDate,
        'updatedDate': updatedAsset.updatedDate,
      });
    } catch (e) {
      throw Exception("Failed to update asset: $e");
    }
  }
}

class Asset {
  final String id; // เพิ่มฟิลด์ id
  final String assetName;
  final double assetAmount;
  final String assetType;
  final String? expiredDate;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  Asset({
    required this.id, // รับค่า id ใน constructor
    required this.assetName,
    required this.assetAmount,
    required this.assetType,
    this.expiredDate,
    required this.createdDate,
    required this.updatedDate,
  });

  // แปลงข้อมูลจาก Firestore เป็น Asset
  factory Asset.fromFirestore(Map<String, dynamic> data, String id) {
    return Asset(
      id: id, // ตั้งค่า id จาก Firestore
      assetName: data['assetName'] ?? '',
      assetAmount: (data['assetAmount'] ?? 0).toDouble(),
      assetType: data['assetType'] ?? '',
      expiredDate: data['expiredDate'] ?? '',
      createdDate: (data['createdDate'] as Timestamp).toDate(),
      updatedDate: (data['updatedDate'] as Timestamp).toDate(),
    );
  }

  // แปลง Asset เป็นข้อมูลสำหรับ Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'assetName': assetName,
      'assetAmount': assetAmount,
      'assetType': assetType,
      'expiredDate': expiredDate,
      'createdDate':
          createdDate != null ? Timestamp.fromDate(createdDate!) : null,
      'updatedDate':
          updatedDate != null ? Timestamp.fromDate(updatedDate!) : null,
    };
  }
}
