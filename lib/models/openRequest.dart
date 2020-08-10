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

  OpenRequest({
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
    };
  }

  factory OpenRequest.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OpenRequest(
      requestId: map['requestId'],
      initializeDate: map['initializeDate'],
      serviceType: map['serviceType'],
      requestData: map['serviceType'] == ServiceTypes.rainWaterHarvest
          ? RainWater.fromMap(map['requestData'])
          : null,
      userId: map['userId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OpenRequest.fromJson(String source) =>
      OpenRequest.fromMap(json.decode(source));

  @override
  String toString() =>
      'OpenRequest(requestId: $requestId, initializeDate: $initializeDate, serviceType: $serviceType)';
}
