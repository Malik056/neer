import 'dart:convert';
import 'package:neer/models/rainWater.dart';
import 'package:neer/models/requestData.dart';
import 'package:neer/models/serviceType.dart';

class OpenRequest {
  String requestId;
  final int initializeDate;
  final String userId;
  final String serviceType;
  final RequestData requestData;
  final String status;

  OpenRequest({
    this.status = "Active",
    this.requestId,
    this.initializeDate,
    this.serviceType,
    this.userId,
    this.requestData,
  });

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'initializeDate': initializeDate,
      'serviceType': serviceType.toString(),
      'requestData': requestData.toMap(),
      'userId': userId,
      'status': status,
    };
  }

  factory OpenRequest.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OpenRequest(
      status: map['status'],
      requestId: map['requestId'],
      initializeDate: map['initializeDate'],
      serviceType: map['serviceType'],
      requestData: map['serviceType'] == ServiceTypes.rainWaterHarvest
          ? RainWater.fromMap(map['requestData'])
          : null,
      userId: map['userId'],
    );
  }
}
