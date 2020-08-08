import 'dart:convert';

import 'package:neer/models/openRequest.dart';
import 'package:neer/models/serviceProviderModel.dart';

class QuoteRequest {
  final String quoteId;
  final String requestId;
  final double quote;
  final String serviceProviderId;
  final double costEstimation;
  final int timeEstimation;
  final String details;
  final String assumptions;

  //temp
  ServiceProviderModel serviceProviderModel;
  OpenRequest request;

  QuoteRequest({
    this.quoteId,
    this.requestId,
    this.quote,
    this.serviceProviderId,
    this.costEstimation,
    this.timeEstimation,
    this.details,
    this.assumptions,
  });

  Map<String, dynamic> toMap() {
    return {
      'quoteId': quoteId,
      'request': requestId,
      'quote': quote,
      'serviceProviderModel': serviceProviderId,
      'costEstimation': costEstimation,
      'timeEstimation': timeEstimation,
      'details': details,
      'assumptions': assumptions,
    };
  }

  factory QuoteRequest.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return QuoteRequest(
      quoteId: map['quoteId'],
      requestId: map['request'],
      quote: map['quote'],
      serviceProviderId: map['serviceProviderModel'],
      costEstimation: map['costEstimation'],
      timeEstimation: map['timeEstimation'],
      details: map['details'],
      assumptions: map['assumptions'],
    );
  }

  String toJson() => json.encode(toMap());

  factory QuoteRequest.fromJson(String source) =>
      QuoteRequest.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QuoteRequest(quoteId: $quoteId, request: $requestId, quote: $quote, serviceProviderModel: $serviceProviderId, costEstimation: $costEstimation, timeEstimation: $timeEstimation, details: $details, assumptions: $assumptions)';
  }
}
