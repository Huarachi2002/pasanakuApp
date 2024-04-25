import 'package:flutter/material.dart';

class InvitacionProvider with ChangeNotifier{
  String id;
  String nameAdmin;
  String capacidad;
  String cuota;
  String fechaInit;
  String periodo;
  String idGame;

  InvitacionProvider({
    this.id = '',
    this.nameAdmin = '',
    this.capacidad = '',
    this.cuota = '',
    this.fechaInit = '',
    this.periodo = '',
    this.idGame = ''
  });

  void changeInvitacion({
    required String newId,
    required  String newNameAdmin,
    required  String newCapacidad,
    required  String newCuota,
    required  String newFechaInit,
    required  String newPeriodo,
    required String newIdGame
  }) async {
    id = newId;
    nameAdmin = newNameAdmin;
    capacidad = newCapacidad;
    cuota = newCuota;
    fechaInit = newFechaInit;
    periodo = newPeriodo;
    idGame = newIdGame;
    notifyListeners();
  }
}