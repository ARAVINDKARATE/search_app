import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  // ignore: non_constant_identifier_names
  final String first_name;
  // ignore: non_constant_identifier_names
  final String last_name;
  final String city;
  // ignore: non_constant_identifier_names
  final String contact_number;

  // ignore: non_constant_identifier_names
  User({required this.first_name, required this.last_name, required this.city, required this.contact_number});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      first_name: json['first_name'],
      last_name: json['last_name'],
      city: json['city'],
      contact_number: json['contact_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': first_name,
      'last_name': last_name,
      'city': city,
      'contact_number': contact_number,
    };
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      first_name: doc['first_name'],
      last_name: doc['last_name'],
      city: doc['city'],
      contact_number: doc['contact_number'],
    );
  }

  // Convert User object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'first_name': first_name,
      'last_name': last_name,
      'city': city,
      'contact_number': contact_number,
    };
  }
}
