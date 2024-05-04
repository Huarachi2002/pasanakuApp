import 'package:flutter/material.dart';

class CuotaProvider with ChangeNotifier{
  String id;
  String cuota;
  String discount;
  String penaltyFee;
  String totalAmount;
  bool state;
  String fecha;
  String destination_participant_id;

  CuotaProvider({
    this.id = '',
    this.cuota = '',
    this.discount = '',
    this.penaltyFee = '',
    this.totalAmount = '',
    this.state = false,
    this.fecha = '',
    this.destination_participant_id = ''
  });

  void changeCuota({
    String? newId,
    String? newCuota,
    String? newDiscount,
    String? newPenaltyFee,
    String? newTotalAmount,
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