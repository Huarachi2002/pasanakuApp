import 'package:flutter/material.dart';

class PujaProvider with ChangeNotifier{
  int? monto;

  PujaProvider({
    this.monto
  });

  void changeRoute({
    required int newMont,
  }) async {
    monto = newMont;

    notifyListeners();
  }
}