import 'dart:convert';

import 'package:neer/models/milestone.dart';

class Payment {
  double amount;
  int date;
  String status;
  String id;
  String milestoneId;
  //Temp
  Milestone milestone;

  Payment({
    this.amount,
    this.date,
    this.status,
    this.id,
    this.milestoneId,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'date': date,
      'status': status,
      'id': id,
      'milestoneId': milestoneId,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Payment(
      amount: map['amount'],
      date: map['date'],
      status: map['status'],
      id: map['id'],
      milestoneId: map['milestoneId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Payment.fromJson(String source) =>
      Payment.fromMap(json.decode(source));
}
