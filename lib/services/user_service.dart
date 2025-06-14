import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;
  static final _collection = _firestore.collection('users');

  static Future<Map<String, dynamic>?> loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _collection.doc(uid).get();
    return doc.data();
  }

  static Future<void> updateUserData(Map<String, dynamic> newData) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Usuário não autenticado');

    await _collection.doc(uid).update(newData);
  }

  static Future<void> deleteUserData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Usuário não autenticado');

    await _collection.doc(uid).delete();
  }

  static Future<void> createUserData(Map<String, dynamic> data) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Usuário não autenticado');

    await _collection.doc(uid).set(data);
  }

  static Future<Map<String, dynamic>?> getUserById(String uid) async {
    final doc = await _collection.doc(uid).get();
    return doc.data();
  }
}
