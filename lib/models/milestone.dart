import 'package:neer/models/payment.dart';

class Milestone {
  String name;
  double term;
  int dueDate;
  String status;
  List<String> paymentIds;
  String milestoneId;
  String contractId;

  //Temp
  List<Payment> payments = [];

  Milestone({
    this.name,
    this.term,
    this.dueDate,
    this.status,
    this.paymentIds,
    this.milestoneId,
    this.contractId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'term': term,
      'dueDate': dueDate,
      'status': status,
      'paymentIds': paymentIds,
      'milestoneId': milestoneId,
      'contractId': contractId,
    };
  }

  factory Milestone.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Milestone(
      name: map['name'],
      term: map['term'],
      dueDate: map['dueDate'],
      status: map['status'],
      paymentIds: List<String>.from(map['paymentIds']),
      milestoneId: map['milestoneId'],
      contractId: map['contractId'],
    );
  }
}
