import 'dart:convert';

import 'package:flutter/foundation.dart';

class ServiceProviderModel {
  String name;
  String description;
  int licenseExpiryDate;
  double rating;
  int totalReviews;
  List<String> services;
  String id;
  String email;
  String phone;
  String website;

  //
  bool isFavorite = false;

  ServiceProviderModel({
    this.name,
    this.description,
    this.licenseExpiryDate,
    this.rating,
    this.totalReviews,
    this.services,
    this.id,
    this.email,
    this.phone,
    this.website,
  }) {
    if (services == null) {
      services = [];
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'licenseExpiryDate': licenseExpiryDate,
      'rating': rating,
      'totalReviews': totalReviews,
      'services': services,
      'id': id,
      'email': email,
      'phone': phone,
      'website': website,
    };
  }

  factory ServiceProviderModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ServiceProviderModel(
      name: map['name'],
      description: map['description'],
      licenseExpiryDate: (map['licenseExpiryDate'] as num).toInt(),
      rating: (map['rating'] as num).toDouble(),
      totalReviews: (map['totalReviews'] as num).toInt(),
      services: List<String>.from(map['services']),
      id: map['id'],
      email: map['email'],
      phone: map['phone'],
      website: map['website'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceProviderModel.fromJson(String source) =>
      ServiceProviderModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ServiceProviderModel(name: $name, description: $description, licenseExpiryDate: $licenseExpiryDate, rating: $rating, totalReviews: $totalReviews, services: $services, id: $id, email: $email, phone: $phone, website: $website)';
  }
}
