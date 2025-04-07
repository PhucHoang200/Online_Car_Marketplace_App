import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class MessageRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMessage(Message message) async {
    await _firestore.doc('messages/${message.id}').set(message.toMap());
  }

  Future<List<Message>> getMessages() async {
    final snapshot = await _firestore.collection('messages').get();
    return snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList();
  }
}