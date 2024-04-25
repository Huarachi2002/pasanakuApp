import 'package:flutter/material.dart';

class PreviousRouteProvider with ChangeNotifier{
  String route;

  PreviousRouteProvider({
    this.route = '',
  });

  void changeRoute({
    required String newRoute,
  }) async {
    route = newRoute;

    notifyListeners();
  }
}