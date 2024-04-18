import 'package:flutter/material.dart';

class PartidaProvider with ChangeNotifier{
  String id;
  String title;
  String estado;
  int cuota;
  int playerTotal;
  String periodo;
  List<String> players = [];
  int cantPlayer = 0;

  PartidaProvider({
    this.id = '',
    this.title = '',
    this.estado = '',
    this.cuota = 0,
    this.playerTotal = 0,
    this.periodo = '',
  });

  void changePartida({
    required String newTitle,
    required String newId,
    required String newEstado,
    required int newCuota,
    required int newPlayerTotal,
    required String newPeriodo,
    List<String>? newPlayers
  }) async {
    id = newId;
    title = newTitle;
    estado = newEstado;
    cuota = newCuota;
    playerTotal = newPlayerTotal;
    periodo = newPeriodo;
    players = newPlayers ?? players;
    cantPlayer = players.length;
    notifyListeners();
  }
}