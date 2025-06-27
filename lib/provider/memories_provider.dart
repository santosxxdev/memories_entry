import 'package:flutter/foundation.dart';
import 'package:memories_entry/model/memories_model.dart';
import 'package:memories_entry/shared/firebase/firebase_manager.dart';

class MemoriesProvider with ChangeNotifier {
  final FirebaseManager _firebaseManager = FirebaseManager();

  Stream<List<MemoriesModel>> getUserMemories() {
    return _firebaseManager.getUserMemoriesStream();
  }
}
