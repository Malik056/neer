import 'dart:convert';

class Review {
  String name;
  double rating;
  int date;
  String review;
  String serviceProviderId;
  String userId;
  Review({
    this.name,
    this.rating,
    this.date,
    this.review,
    this.serviceProviderId,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rating': rating,
      'date': date,
      'review': review,
      'serviceProviderId': serviceProviderId,
      'userId': userId,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Review(
      name: map['name'],
      rating: map['rating'],
      date: map['date'],
      review: map['review'],
      serviceProviderId: map['serviceProviderId'],
      userId: map['userId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) => Review.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Review(name: $name, rating: $rating, date: $date, review: $review, serviceProviderId: $serviceProviderId, userId: $userId)';
  }
}
