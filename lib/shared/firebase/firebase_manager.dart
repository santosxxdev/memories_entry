import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:memories_entry/model/memories_model.dart';
import 'package:memories_entry/model/user_model.dart';

class FirebaseManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference _userCollection =
  FirebaseFirestore.instance.collection("user");

  final CollectionReference _memoriesCollection =
  FirebaseFirestore.instance.collection("memories");

  // 🔐 إنشاء حساب جديد
  Future<void> createAccount(
      String email, String password, UserModel userModel) async {
    UserCredential userCredential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password);

    String uid = userCredential.user!.uid;

    UserModel updatedUser = UserModel(
      id: uid,
      name: userModel.name,
      age: userModel.age,
      phone: userModel.phone,
      email: userModel.email,
    );

    await _userCollection.doc(uid).set(updatedUser.toMap());
  }

  // 🔓 تسجيل الدخول
  Future<void> loginAccount(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // 📥 جلب بيانات المستخدم الحالي
  Future<UserModel> getCurrentUserData() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) throw Exception("المستخدم غير مسجل دخول");

      final DocumentSnapshot snapshot = await _userCollection.doc(user.uid).get();
      return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception("فشل تحميل بيانات المستخدم: $e");
    }
  }

  // ⬆️ حفظ ذكرى جديدة
  Future<void> uploadMemory({
    required String title,
    required String description,
    File? imageFile,
    File? audioFile,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) throw Exception("لا يوجد مستخدم مسجل دخول");

      String? imageUrl;
      String? audioUrl;

      // رفع الصورة إلى Firebase Storage
      if (imageFile != null) {
        final imageRef = FirebaseStorage.instance
            .ref("memories/images/${DateTime.now().millisecondsSinceEpoch}");
        await imageRef.putFile(imageFile);
        imageUrl = await imageRef.getDownloadURL();
      }

      // رفع الصوت إلى Firebase Storage
      if (audioFile != null) {
        final audioRef = FirebaseStorage.instance
            .ref("memories/audios/${DateTime.now().millisecondsSinceEpoch}");
        await audioRef.putFile(audioFile);
        audioUrl = await audioRef.getDownloadURL();
      }

      // إنشاء موديل الذكرى
      final MemoriesModel memory = MemoriesModel(
        titelMemories: title,
        decMemories: description,
        dateTimeMemories: DateTime.now(),
        imageMemories: imageUrl,
        audioMemories: audioUrl,
      );

      // حفظ الذكرى داخل مجموعة خاصة بالمستخدم
      await _memoriesCollection
          .doc(user.uid)
          .collection("userMemories")
          .add(memory.toMap());
    } catch (e) {
      throw Exception("فشل حفظ الذكرى: $e");
    }
  }

  Stream<List<MemoriesModel>> getUserMemoriesStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]); // لو مش مسجل دخول يرجّع ستريم فاضي
    }

    return _memoriesCollection
        .doc(user.uid)
        .collection("userMemories")
        .orderBy("dateTimeMemories", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MemoriesModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }


}
