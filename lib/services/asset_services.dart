import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ฟังก์ชันดึงข้อมูล asset ของผู้ใช้
  Stream<List<Asset>> getUserAssets(String username) {
    return FirebaseFirestore.instance
        .collection('user_asset')
        .doc(username)
        .collection('asset')
        .orderBy('createdDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Asset.fromFirestore(doc.data(), doc.id))
            .toList());
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
