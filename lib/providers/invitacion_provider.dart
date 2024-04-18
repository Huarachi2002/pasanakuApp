import 'package:flutter/material.dart';

class InvitacionProvider with ChangeNotifier{
  String id;
  String nameAdmin;
  String capacidad;
  String cuota;
  String users;
  String fechaInit;
  String periodo;

  InvitacionProvider({
    this.id = '',
    this.nameAdmin = '',
    this.capacidad = '',
    this.cuota = '',
    this.users = '',
    this.fechaInit = '',
    this.periodo = '',
  });

  void changeInvitacion({
    required String newId,
    required  String newNameAdmin,
    required  String newCapacidad,
    required  String newCuota,
    required  String newUsers,
    required  String newFechaInit,
    required  String newPeriodo
  }) async {
    id = newId;
    nameAdmin = newNameAdmin;
    capacidad = newCapacidad;
    cuota = newCuota;
    users = newUsers;
    fechaInit = newFechaInit;
    periodo = newPeriodo;

    notifyListeners();
  }
}