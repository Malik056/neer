import 'dart:convert';

class OpenRequest {
  final String requestId;
  final int initializeDate;
  final String serviceType;
  OpenRequest({
    this.requestId,
    this.initializeDate,
    this.serviceType,
  });

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'initializeDate': initializeDate,
      'serviceType': serviceType.toString(),
    };
  }

  factory OpenRequest.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OpenRequest(
      requestId: map['requestId'],
      initializeDate: map['initializeDate'],
      serviceType: map['serviceType'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OpenRequest.fromJson(String source) =>
      OpenRequest.fromMap(json.decode(source));

  @override
  String toString() =>
      'OpenRequest(requestId: $requestId, initializeDate: $initializeDate, serviceType: $serviceType)';
}
