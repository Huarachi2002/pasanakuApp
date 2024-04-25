import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier{
  String userEmail;
  String id;
  String state;
  int? idParticipant;

  UserProvider({
    this.userEmail = '',
    this.id = '',
    this.state = 'no-authenticated'
  });

  void changeUserEmail({
    required String newUserEmail,
    required String newId,
    String? newState
  }) async {
    userEmail = newUserEmail;
    id = newId;
    state = newState ?? 'no-authenticated';
    notifyListeners();
  }
  
  void changeParticipantId({
    required int newId,
  }) async {
    idParticipant = newId;
    notifyListeners();
  }
}