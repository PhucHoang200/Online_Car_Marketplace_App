import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report_model.dart';

class ReportRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addReport(Report report) async {
    await _firestore.doc('reports/${report.id}').set(report.toMap());
  }

  Future<List<Report>> getReports() async {
    final snapshot = await _firestore.collection('reports').get();
    return snapshot.docs.map((doc) => Report.fromMap(doc.data())).toList();
  }
}