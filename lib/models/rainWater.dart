class LatLng {
  double lattitude;
  double longitude;
}

class RainWater {
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
}
