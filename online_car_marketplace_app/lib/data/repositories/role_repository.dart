import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/role_model.dart';

class RoleRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addRole(Role role) async {
    await _firestore.doc('roles/${role.id}').set(role.toMap());
  }

  Future<List<Role>> getRoles() async {
    final snapshot = await _firestore.collection('roles').get();
    return snapshot.docs.map((doc) => Role.fromMap(doc.data())).toList();
  }
}