import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final int id;
  final int reporterId;
  final int reportedUserId;
  final int reportedCarId;
  final String reason;
  final String status;
  final Timestamp creationDate;

  Report({
    required this.id,
    required this.reporterId,
    required this.reportedUserId,
    required this.reportedCarId,
    required this.reason,
    required this.status,
    required this.creationDate,
  });

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'] as int,
      reporterId: map['reporterId'] as int,
      reportedUserId: map['reportedUserId'] as int,
      reportedCarId: map['reportedCarId'] as int,
      reason: map['reason'] as String,
      status: map['status'] as String,
      creationDate: map['creationDate'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'reporterId': reporterId,
    'reportedUserId': reportedUserId,
    'reportedCarId': reportedCarId,
    'reason': reason,
    'status': status,
    'creationDate': creationDate,
  };
}