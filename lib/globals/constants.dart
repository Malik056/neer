import 'package:flutter/material.dart';
import 'package:neer/bloc/canceledRequestBloc.dart';
import 'package:neer/bloc/connectivityBloc.dart';
import 'package:neer/bloc/openRequestsBloc.dart';
import 'package:neer/bloc/waitTimeBloc.dart';
import 'package:neer/models/contract.dart';
import 'package:neer/models/milestone.dart';
import 'package:neer/models/openRequest.dart';
import 'package:neer/models/payment.dart';
import 'package:neer/models/quotesModel.dart';
import 'package:neer/models/review.dart';
import 'package:neer/models/serviceProviderModel.dart';
import 'package:neer/models/serviceType.dart';
import 'package:neer/providers/authProvider.dart';
import 'package:neer/models/user.dart';
import 'package:neer/providers/rainwaterDataProvider.dart';

class PaymentStatus {
  static final String inEscrow = "In Escrow";
  static final String cleared = "Cleared";
}

class MilestoneStatus {
  static final String active = "Active";
  static final String complete = "Complete";
  static final String halfCompleted = "Half Complete";
  static final String waiting = "Waiting";
}

class ContractStatus {
  static String inProgress = "In Progress";
  static String completed = "Completed";
  static String canceled = "Canceled";
}

ConnectivityBloc connectivityBloc;
MyPhoneAuthProvider phoneAuthProvider;
GlobalKey<NavigatorState> navigatorState;
RainWaterDataProvider rainWaterDataProvider;
WaitingTimeBloc waitingTimeBloc;

List<ServiceProviderModel> serviceProviders = [
  ServiceProviderModel(
    name: 'The Rebel Unit',
    description: 'Specialized in Grey Water and Rain Water Services',
    licenseExpiryDate:
        DateTime.parse("2022-02-27 00:00:00Z").millisecondsSinceEpoch,
    rating: 9,
    totalReviews: 28,
    services: [
      ServiceTypes.rainWaterHarvest,
      ServiceTypes.waterQualityAssessment,
      ServiceTypes.saltWaterTreatment,
      ServiceTypes.greyWater,
    ],
    id: "1",
  ),
  ServiceProviderModel(
    name: 'Twelves Group',
    description: 'Specialized in Grey Water and Rain Water Services',
    licenseExpiryDate:
        DateTime.parse("2029-02-27 00:00:00Z").millisecondsSinceEpoch,
    rating: 10,
    totalReviews: 28,
    services: [
      ServiceTypes.rainWaterHarvest,
      ServiceTypes.waterQualityAssessment,
      ServiceTypes.saltWaterTreatment,
      ServiceTypes.greyWater,
    ],
    id: "2",
  ),
  ServiceProviderModel(
    name: 'Twelves Group 2',
    description: 'Specialized in Grey Water and Rain Water Services',
    licenseExpiryDate:
        DateTime.parse("2020-02-27 00:00:00Z").millisecondsSinceEpoch,
    rating: 10,
    totalReviews: 28,
    services: [
      ServiceTypes.rainWaterHarvest,
      ServiceTypes.waterQualityAssessment,
      ServiceTypes.saltWaterTreatment,
      ServiceTypes.greyWater,
    ],
    id: "3",
  ),
];
OpenRequestBloc openRequestBloc;
CanceledRequestBloc canceledRequestBloc;

List<OpenRequest> openRequests = [
  OpenRequest(
    requestId: '1XXXXXXXXXX',
    initializeDate: DateTime.utc(2022, 10, 3).millisecondsSinceEpoch,
    serviceType: ServiceTypes.rainWaterHarvest,
  ),
  OpenRequest(
    requestId: '2XXXXXXXXXX',
    initializeDate: DateTime.utc(2021, 10, 3).millisecondsSinceEpoch,
    serviceType: ServiceTypes.waterQualityAssessment,
  ),
  OpenRequest(
    requestId: '3XXXXXXXXXX',
    initializeDate: DateTime.utc(2022, 12, 30).millisecondsSinceEpoch,
    serviceType: ServiceTypes.rainWaterHarvest,
  ),
  OpenRequest(
    requestId: '4XXXXXXXXXX',
    initializeDate: DateTime.utc(2022, 10, 3).millisecondsSinceEpoch,
    serviceType: ServiceTypes.waterQualityAssessment,
  ),
];
List<QuoteRequest> quotes = [
  QuoteRequest(
    assumptions:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
    details:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
    costEstimation: 2000,
    quote: null,
    quoteId: 'XXXXXXXXXXXXXXXXX',
    requestId: openRequests[0].requestId,
    serviceProviderId: serviceProviders[0].id,
    timeEstimation: Duration(days: 200).inMilliseconds,
  )
    ..request = openRequests[0]
    ..serviceProviderModel = serviceProviders[0],
  QuoteRequest(
    assumptions:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
    details:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
    costEstimation: 2000,
    quote: null,
    quoteId: 'XXXXXXXXXXXXXXXXX',
    requestId: openRequests[1].requestId,
    serviceProviderId: serviceProviders[1].id,
    timeEstimation: Duration(days: 200).inMilliseconds,
  )
    ..request = openRequests[1]
    ..serviceProviderModel = serviceProviders[1],
  QuoteRequest(
    assumptions:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
    details:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
    costEstimation: 2000,
    quote: null,
    quoteId: 'XXXXXXXXXXXXXXXXX',
    requestId: openRequests[2].requestId,
    serviceProviderId: serviceProviders[0].id,
    timeEstimation: Duration(days: 200).inMilliseconds,
  )
    ..request = openRequests[2]
    ..serviceProviderModel = serviceProviders[0],
  QuoteRequest(
    assumptions:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
    details:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
    costEstimation: 2000,
    quote: null,
    quoteId: 'XXXXXXXXXXXXXXXXX',
    requestId: openRequests[0].requestId,
    serviceProviderId: serviceProviders[2].id,
    timeEstimation: Duration(days: 200).inMilliseconds,
  )
    ..request = openRequests[0]
    ..serviceProviderModel = serviceProviders[2],
];
List<Review> reviews = [
  Review(
    date: DateTime.utc(2020, 4, 28).millisecondsSinceEpoch,
    name: "John Smith - The Vinyl Constructions",
    rating: 10,
    review:
        "This will require an ICCW specialist to ensure if both parties are in same page and the terms are met and/or provide mediation assistance too and resolve any conflict",
    serviceProviderId: "1",
    userId: "123",
  ),
  Review(
    date: DateTime.utc(2020, 7, 8).millisecondsSinceEpoch,
    name: "Nolvin Moreno - Nimex Constructions",
    rating: 9,
    review:
        "This will require an ICCW specialist to ensure if both parties are in same page and the terms are met and/or provide mediation assistance too and resolve any conflict",
    serviceProviderId: "1",
    userId: "1233",
  ),
  Review(
    date: DateTime.utc(2020, 5, 2).millisecondsSinceEpoch,
    name: "Allan Starc - Bala Builders",
    rating: 10,
    review:
        "This will require an ICCW specialist to ensure if both parties are in same page and the terms are met and/or provide mediation assistance too and resolve any conflict",
    serviceProviderId: "1",
    userId: "1234",
  ),
  Review(
    date: DateTime.utc(2020, 6, 12).millisecondsSinceEpoch,
    name: "John Smith - The Vinyl Constructions",
    rating: 10,
    review:
        "This will require an ICCW specialist to ensure if both parties are in same page and the terms are met and/or provide mediation assistance too and resolve any conflict",
    serviceProviderId: "1",
    userId: "123",
  ),
  Review(
    date: DateTime.utc(2020, 7, 11).millisecondsSinceEpoch,
    name: "John Smith - The Vinyl Constructions",
    rating: 10,
    review:
        "This will require an ICCW specialist to ensure if both parties are in same page and the terms are met and/or provide mediation assistance too and resolve any conflict",
    serviceProviderId: "1",
    userId: "123",
  ),
  Review(
    date: DateTime.utc(2020, 4, 28).millisecondsSinceEpoch,
    name: "John Handerson - The Vinyl Constructions",
    rating: 8,
    review:
        "This will require an ICCW specialist to ensure if both parties are in same page and the terms are met and/or provide mediation assistance too and resolve any conflict",
    serviceProviderId: "1",
    userId: "1223",
  ),
];

List<Payment> payments = [
  Payment(
    id: '1',
    amount: 100,
    date: DateTime.utc(2020, 8, 15).millisecondsSinceEpoch,
    milestoneId: '1',
    status: PaymentStatus.inEscrow,
  ),
  Payment(
    id: '2',
    amount: 100,
    date: DateTime.utc(2020, 8, 18).millisecondsSinceEpoch,
    milestoneId: '1',
    status: PaymentStatus.inEscrow,
  ),
];
List<Milestone> milestones = [
  Milestone(
    status: MilestoneStatus.active,
    contractId: '1',
    dueDate: DateTime.utc(2020, 8, 20).millisecondsSinceEpoch,
    milestoneId: '1',
    name: "Initial Payment",
    paymentIds: ['1', '2'],
    term: 200,
  )..payments = [
      payments[0],
      payments[1],
    ],
  Milestone(
    status: MilestoneStatus.waiting,
    contractId: '1',
    dueDate: DateTime.utc(2020, 8, 25).millisecondsSinceEpoch,
    milestoneId: '2',
    name: "Half Done",
    paymentIds: [],
    term: 200,
  )..payments = [],
  Milestone(
    status: MilestoneStatus.waiting,
    contractId: '1',
    dueDate: DateTime.utc(2020, 8, 29).millisecondsSinceEpoch,
    milestoneId: '3',
    name: "Completed",
    paymentIds: [],
    term: 100,
  )..payments = [],
];

List<Contract> contracts = [
  Contract(
    contractId: '1',
    escrow: 200,
    projectValue: 500,
    milestoneIds: [
      '1',
      '2',
      '3',
    ],
    requestId: '1XXXXXXXXXX',
    serviceProviderId: '1',
    startDate: DateTime.now().toUtc().millisecondsSinceEpoch,
    status: ContractStatus.inProgress,
  )
    ..milestones = [
      milestones[0],
      milestones[1],
      milestones[2],
    ]
    ..openRequest = openRequests[0]
    ..serviceProviderModel = serviceProviders[0],
  Contract(
    contractId: '2',
    escrow: 200,
    projectValue: 500,
    milestoneIds: [
      '1',
      '2',
      '3',
    ],
    requestId: '2XXXXXXXXXX',
    serviceProviderId: '1',
    startDate: DateTime.now().toUtc().millisecondsSinceEpoch,
    status: ContractStatus.inProgress,
  )
    ..milestones = [
      milestones[0],
      milestones[1],
      milestones[2],
    ]
    ..openRequest = openRequests[0]
    ..serviceProviderModel = serviceProviders[0],
  Contract(
    contractId: '1',
    escrow: 200,
    projectValue: 500,
    milestoneIds: [
      '1',
      '2',
      '3',
    ],
    requestId: '1XXXXXXXXXX',
    serviceProviderId: '1',
    startDate: DateTime.now().toUtc().millisecondsSinceEpoch,
    status: ContractStatus.completed,
    endDate: DateTime.now().toUtc().millisecondsSinceEpoch,
    dateInspected: DateTime.utc(2020, 8, 9).millisecondsSinceEpoch,
    inspectedBy: "John S. Smith",
  )
    ..milestones = [
      milestones[0],
      milestones[1],
      milestones[2],
    ]
    ..openRequest = openRequests[0]
    ..serviceProviderModel = serviceProviders[0],
  Contract(
    contractId: '2',
    escrow: 200,
    projectValue: 500,
    milestoneIds: [
      '1',
      '2',
      '3',
    ],
    requestId: '2XXXXXXXXXX',
    serviceProviderId: '1',
    startDate: DateTime.now().toUtc().millisecondsSinceEpoch,
    status: ContractStatus.completed,
    endDate: DateTime.now().toUtc().millisecondsSinceEpoch,
    // dateInspected: DateTime.utc(2020, 8, 9).millisecondsSinceEpoch,
    // inspectedBy: "John S. Smith",
  )
    ..milestones = [
      milestones[0],
      milestones[1],
      milestones[2],
    ]
    ..openRequest = openRequests[1]
    ..serviceProviderModel = serviceProviders[0],
];

User user;
final List<String> phoneNumberCountryCodes = ["+1", "+91", "+92"];
