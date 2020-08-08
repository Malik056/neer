import 'dart:convert';

class ServiceProviderModel {
  String name;
  String description;
  int licenseExpiryDate;
  double rating;
  int totalReviews;
  List<String> services = [];
  String id;
  ServiceProviderModel({
    this.name,
    this.description,
    this.licenseExpiryDate,
    this.rating,
    this.totalReviews,
    this.services,
    this.id,
  }) {
    if (services == null) {
      services = [];
    }
  }

  //local
  bool isFavorite = false;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'licenseExpiryDate': licenseExpiryDate,
      'rating': rating,
      'totalReviews': totalReviews,
      'services': services,
      'id': id,
    };
  }

  factory ServiceProviderModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ServiceProviderModel(
      name: map['name'],
      description: map['description'],
      licenseExpiryDate: map['licenseExpiryDate'],
      rating: map['rating'],
      totalReviews: map['totalReviews'],
      services: List<String>.from(map['services']),
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceProviderModel.fromJson(String source) =>
      ServiceProviderModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ServiceProviderModel(name: $name, description: $description, licenseExpiryDate: $licenseExpiryDate, rating: $rating, totalReviews: $totalReviews, services: $services, id: $id)';
  }
}
