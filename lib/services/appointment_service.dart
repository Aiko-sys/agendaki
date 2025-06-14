import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentService {
  static final _collection = FirebaseFirestore.instance.collection('appointments');

  static Future<String> createAppointment(Map<String, dynamic> data) async {
    final docRef = await _collection.add(data);
    await docRef.update({'id': docRef.id}); 
    return docRef.id;
  }

  static Future<Map<String, dynamic>?> loadAppointmentData(String AppointmentId) async {
    final doc = await _collection.doc(AppointmentId).get();
    return doc.exists ? doc.data() : null;
  }

  static Future<List<Map<String, dynamic>>> loadAllAppointments() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data(),
    }).toList();
  }

  static Future<void> updateAppointment(String AppointmentId, Map<String, dynamic> data) async {
    await _collection.doc(AppointmentId).update(data);
  }
  
  static Future<void> deleteAppointment(String AppointmentId) async {
    await _collection.doc(AppointmentId).delete();
  }
}
