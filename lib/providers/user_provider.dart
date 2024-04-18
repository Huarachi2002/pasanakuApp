import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier{
  String userEmail;
  String id;

  UserProvider({
    this.userEmail = '',
    this.id = ''
  });

  void changeUserEmail({
    required String newUserEmail,
    required String newId
  }) async {
    userEmail = newUserEmail;
    id = newId;
    notifyListeners();
  }
}