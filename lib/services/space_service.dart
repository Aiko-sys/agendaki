import 'package:cloud_firestore/cloud_firestore.dart';

class SpaceService {
  static final _collection = FirebaseFirestore.instance.collection('spaces');

  static Future<String> createSpace(Map<String, dynamic> data) async {
    final docRef = await _collection.add(data);
    await docRef.update({'id': docRef.id}); 
    return docRef.id;
  }

  static Future<Map<String, dynamic>?> loadSpaceData(String spaceId) async {
    final doc = await _collection.doc(spaceId).get();
    return doc.exists ? doc.data() : null;
  }

  static Future<List<Map<String, dynamic>>> loadAllSpaces() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data(),
    }).toList();
  }

  static Future<void> updateSpace(String spaceId, Map<String, dynamic> data) async {
    await _collection.doc(spaceId).update(data);
  }
  
  static Future<void> deleteSpace(String spaceId) async {
    await _collection.doc(spaceId).delete();
  }
}