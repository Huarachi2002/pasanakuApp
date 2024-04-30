import 'package:flutter/material.dart';

class PujaProvider with ChangeNotifier{
  int? numberid;
  int? monto = 0;
  int? participantId;

  PujaProvider({
    this.monto = 0
  });

  void changePuja({
    int? newMont,
    int? newNumberId,
    int? newParticipantId,
  }) async {
    monto = newMont ?? monto;
    numberid = newNumberId ?? numberid;
    participantId = newParticipantId ?? participantId;
    notifyListeners();
  }
}