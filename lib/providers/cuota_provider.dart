import 'package:flutter/material.dart';

class CuotaProvider with ChangeNotifier{
  String id;
  int cuota;
  int discount;
  int penaltyFee;
  int totalAmount;
  bool state;
  String fecha;
  String destination_participant_id;

  CuotaProvider({
    this.id = '',
    this.cuota = 0,
    this.discount = 0,
    this.penaltyFee = 0,
    this.totalAmount = 0,
    this.state = false,
    this.fecha = '',
    this.destination_participant_id = ''
  });

  void changeCuota({
    String? newId,
    int? newCuota,
    int? newDiscount,
    int? newPenaltyFee,
    int? newTotalAmount,
    bool? newState,
    String? newFecha,
    String? newDestination_participant_id
  }) async {
    id = newId ?? id;
    cuota = newCuota ?? cuota;
    discount = newDiscount ?? discount;
    penaltyFee = newPenaltyFee ?? penaltyFee;
    totalAmount = newTotalAmount ?? totalAmount;
    state = newState ?? state;
    fecha = newFecha ?? fecha;
    destination_participant_id = newDestination_participant_id ?? destination_participant_id;
    notifyListeners();
  }
}