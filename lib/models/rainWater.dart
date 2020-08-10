import 'package:neer/models/requestData.dart';

class LatLng {
  double latitude;
  double longitude;
  LatLng({
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory LatLng.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return LatLng(
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}

class RainWater with RequestData {
  String jobAddress;
  LatLng latlng;
  String serviceArea;
  String roofType;
  bool existingSetupAvailable;
  List<String> sources = [];
  bool demandBeingMet;
  String qualityOfWaterPerDay;
  String availableWells;
  String countAndDepthOfWells;
  String noOfRainWaterDischargePipes;
  String otherInformation;
  RainWater({
    this.jobAddress,
    this.latlng,
    this.serviceArea,
    this.roofType,
    this.existingSetupAvailable,
    this.sources,
    this.demandBeingMet,
    this.qualityOfWaterPerDay,
    this.availableWells,
    this.countAndDepthOfWells,
    this.noOfRainWaterDischargePipes,
    this.otherInformation,
  }) {
    if (sources == null) {
      sources = [];
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'jobAddress': jobAddress,
      'latlng': latlng?.toMap(),
      'serviceArea': serviceArea,
      'roofType': roofType,
      'existingSetupAvailable': existingSetupAvailable,
      'sources': sources,
      'demandBeingMet': demandBeingMet,
      'qualityOfWaterPerDay': qualityOfWaterPerDay,
      'availableWells': availableWells,
      'countAndDepthOfWells': countAndDepthOfWells,
      'noOfRainWaterDischargePipes': noOfRainWaterDischargePipes,
      'otherInformation': otherInformation,
    };
  }

  factory RainWater.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return RainWater(
      jobAddress: map['jobAddress'],
      latlng: LatLng.fromMap(map['latlng']),
      serviceArea: map['serviceArea'],
      roofType: map['roofType'],
      existingSetupAvailable: map['existingSetupAvailable'],
      sources: List<String>.from(map['sources']),
      demandBeingMet: map['demandBeingMet'],
      qualityOfWaterPerDay: map['qualityOfWaterPerDay'],
      availableWells: map['availableWells'],
      countAndDepthOfWells: map['countAndDepthOfWells'],
      noOfRainWaterDischargePipes: map['noOfRainWaterDischargePipes'],
      otherInformation: map['otherInformation'],
    );
  }
}
