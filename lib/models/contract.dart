import 'package:flutter/material.dart';
import 'package:neer/globals/constants.dart';
import 'package:neer/models/milestone.dart';
import 'package:neer/models/openRequest.dart';
import 'package:neer/models/serviceProviderModel.dart';

class Contract {
  String serviceProviderId;
  String requestId;
  int startDate;
  double projectValue;
  double escrow;
  String contractId;
  List<String> milestoneIds;
  String status;
  int endDate;
  int dateInspected;
  String inspectedBy;

  //temp
  List<Milestone> milestones = [];
  ServiceProviderModel serviceProviderModel;
  OpenRequest openRequest;

  Contract({
    this.serviceProviderId,
    this.requestId,
    this.startDate,
    this.projectValue,
    this.escrow,
    this.contractId,
    this.milestoneIds,
    this.status,
    this.endDate,
    this.dateInspected,
    this.inspectedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'serviceProviderId': serviceProviderId,
      'requestId': requestId,
      'startDate': startDate,
      'projectValue': projectValue,
      'escrow': escrow,
      'contractId': contractId,
      'milestoneIds': milestoneIds,
      'status': status,
      'endDate': endDate,
      'dateInspected': dateInspected,
      'inspectedBy': inspectedBy,
    };
  }

  factory Contract.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Contract(
      serviceProviderId: map['serviceProviderId'],
      requestId: map['requestId'],
      startDate: map['startDate'],
      projectValue: map['projectValue'],
      escrow: map['escrow'],
      contractId: map['contractId'],
      milestoneIds: List<String>.from(map['milestoneIds']),
      status: ContractStatus.inProgress,
      endDate: map['endDate'],
      dateInspected: map['dateInspected'],
      inspectedBy: map['inspectedBy'],
    );
  }
}
