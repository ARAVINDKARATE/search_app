import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:search_app/model/user_model.dart';
import 'package:flutter/services.dart';

class DataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<User> _users = [];

  Future<List<User>> fetchUsers() async {
    final String response = await rootBundle.loadString('assets/json/user_list.json');
    final List<dynamic> data = json.decode(response);
    _users = data.map((json) => User.fromJson(json)).toList();

    await uploadUsersToFirebase(_users);
    return _users;
  }

  Future<void> uploadUsersToFirebase(List<User> users) async {
    WriteBatch batch = _firestore.batch();

    for (var user in users) {
      var existingUser = await _firestore.collection('users').where('contact_number', isEqualTo: user.contact_number).get();

      if (existingUser.docs.isEmpty) {
        DocumentReference docRef = _firestore.collection('users').doc();
        batch.set(docRef, user.toMap());
      }
    }

    await batch.commit(); // Commit the batch to Firestore
  }
}
