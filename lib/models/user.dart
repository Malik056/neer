import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String email;
  String city;
  String phoneNumber;
  String uid;
  User({
    this.name,
    this.email,
    this.city,
    this.phoneNumber,
    this.uid,
  });

  static void copySnapshotToUser(User user, DocumentSnapshot snapshot) {
    if (snapshot == null || user == null || snapshot.data == null) return;
    user.city = snapshot.data['city'];
    user.email = snapshot.data['email'];
    user.name = snapshot.data['name'];
    user.uid = snapshot.data['uid'];
    user.phoneNumber = snapshot.data['phoneNumber'];
  }

  User copyWith({
    String name,
    String email,
    String city,
    String phoneNumber,
    String uid,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      city: city ?? this.city,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'city': city,
      'phoneNumber': phoneNumber,
      'uid': uid,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return User(
      name: map['name'],
      email: map['email'],
      city: map['city'],
      phoneNumber: map['phoneNumber'],
      uid: map['uid'],
    );
  }

  String toJson() => json.encode(toMap());

  static User fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(name: $name, email: $email, city: $city, phoneNumber: $phoneNumber, uid: $uid)';
  }
}
