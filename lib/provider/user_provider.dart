import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/user_model.dart';
// import '../services/data_service.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<User> _users = [];
  List<User> get users => _users;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  int n = 0;

  void searchUsers(String query) {
    _isSearching = query.isNotEmpty;
    notifyListeners();
  }

  List<User> getFilteredUsers(String query) {
    if (query.isEmpty) {
      return _users;
    }
    return _users.where((user) {
      return user.first_name.toLowerCase().contains(query.toLowerCase()) || user.last_name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();

    // This is for fetchin and Uploading the data to Firebase
    // I have executed it once and commented it to increase the performace of the app
    // DataService dataService = DataService();
    // _users = await dataService.fetchUsers();

    await fetchUsersFromFirebase();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUsersFromFirebase({DocumentSnapshot? lastDocument}) async {
    Query query = _firestore.collection('users');

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    QuerySnapshot querySnapshot = await query.get();
    _users.addAll(querySnapshot.docs.map((doc) => User.fromDocument(doc)).toList());

    notifyListeners();
  }

  static Future<void> openInBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      try {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        print('Error launching URL: $e');
      }
    } else {
      print('Could not launch $url');
    }
  }

  static Future<void> sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(emailUri)) {
      try {
        await launchUrl(emailUri);
      } catch (e) {
        print('Error launching email client: $e');
      }
    } else {
      print('No email client available');
    }
  }

  void handleMenuOption(
    int value,
  ) {
    switch (value) {
      case 0:
        openInBrowser('https://girmantech.com');
        break;
      case 1:
        openInBrowser('https://www.linkedin.com/company/girmantech/');
        break;
      case 2:
        sendEmail('contact@girmantech.com');
        break;
    }
  }
}
