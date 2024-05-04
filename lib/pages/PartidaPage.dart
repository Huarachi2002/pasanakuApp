import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:pasanaku_app/api/apiServicio.dart';
import 'package:pasanaku_app/providers/cuota_provider.dart';
import 'package:pasanaku_app/providers/partida_provider.dart';
import 'package:pasanaku_app/providers/user_provider.dart';
import 'package:pasanaku_app/widgets/drawer.dart';
import 'package:provider/provider.dart';

class PartidaPage extends StatefulWidget {
  static const name = 'partida-screen';
  const PartidaPage({super.key});

  @override
  State<PartidaPage> createState() => _PartidaPageState();
}

class _PartidaPageState extends State<PartidaPage> {
  int currentStep = 0;
  List<dynamic> data = [];
  List<dynamic> dataCuota = [];
  bool load = true;
  bool statePuja = false;
  PartidaProvider? partida;

  Map<String, MaterialColor> color = {
    "Iniciado": Colors.green,
    "En espera": Colors.yellow,
    "Finalizados": Colors.red
  };

  late Timer _timer;

  Future<void> getParticipants() async {
    try {
      final player = Provider.of<UserProvider>(context, listen: false);
      partida = Provider.of<PartidaProvider>(context, listen: false);
      final response = await dio.get('/participant/gamePk/${partida!.id}');
      data = response.data['data'];
      for (var participant in data) {
        // print('${participant['player_id']} == ${player.id}');
        if(participant['player_id'] == player.id) {
          player.changeParticipantId(newId: participant['id']);
          // print(participant['id']);
        }
      }
      // print('Data Participantes: $data');
      // print('Data Participantes: ${data[0]['player']['name']}');
    } on DioException catch (e) {
        if(e.response != null){
          print('data: ${e.response!.data}');
          print('headers: ${e.response!.headers}');
          print('requestOptions: ${e.response!.requestOptions}');
          // print('Message: ${e.response!.data['errors']['details'][0]["msg"]}');
        }else{
          print('requestOptions: ${e.requestOptions}');
          print(e.message);
        }
    } 
  }

  Future<void> getPuja()async{
    try {
      final response = await dio.get('/numbers/${partida!.id}');
      // print(response.data['data']);
      if(response.data['data'].length > 0) statePuja = true;
    } on DioException catch (e) {
        if(e.response != null){
          print('data: ${e.response!.data}');
          print('headers: ${e.response!.headers}');
          print('requestOptions: ${e.response!.requestOptions}');
          // print('Message: ${e.response!.data['errors']['details'][0]["msg"]}');
        }else{
          print('requestOptions: ${e.requestOptions}');
          print(e.message);
        }
    } 
  }

  Future<void> getCuotas()async{
    try {
      final user = Provider.of<UserProvider>(context, listen: false);
      final game = Provider.of<PartidaProvider>(context,listen: false);
      final response = await dio.get('/transfers/${game.id}/${user.id}');
      dataCuota = response.data['data'];
      // print("dataCuota: $dataCuota");  
    } on DioException catch (e) {
      if(e.response != null){
        print('data: ${e.response!.data}');
        print('headers: ${e.response!.headers}');
        print('requestOptions: ${e.response!.requestOptions}');
        // print('Message: ${e.response!.data['errors']['details'][0]["msg"]}');
      }else{
        print('requestOptions: ${e.requestOptions}');
        print(e.message);
      }
    } 
  }
  void reload (){
    getParticipants();
    getPuja();
    getCuotas();
    _timer = Timer(const Duration(seconds: 2), (){
      setState(() {
        load = !load;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getParticipants();
    getCuotas();
    getPuja();
    _timer = Timer(const Duration(seconds: 1), () {
      setState(() {
        load = !load;
      });
    },);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final partidaInfo = Provider.of<PartidaProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context,listen: false);
    return Scaffold(
      drawer: const DrawerView(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF318CE7),
        title: const Center(
          child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'PASANAKU', 
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontSize: 25
                    ),
                  ),
                  SizedBox(width: 15,),
                  Image(
                    image: AssetImage('assets/logo.png'),
                    width: 50,
                    height: 50
                  ),
                ],
              ),
        ),
      ),
      body: Container(
        color: const Color(0xFF318CE7),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color(0xFFD9D9D9),
                      ),
                      child: InkWell(
                        child: const Icon(Icons.arrow_back_rounded,size: 50,),
                        onTap: () {
                          context.pop();
                        },
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: (){
                            setState(() {
                              load = true;
                            });
                            reload();
                          },
                          style: ButtonStyle(
                            iconSize: MaterialStateProperty.all<double?>(30)
                          ),
                          icon: const Icon(Icons.replay_outlined)
                        ),
                        ElevatedButton(onPressed: 
                        (statePuja)
                        ?() {
                          context.push('/puja');
                        } 
                        : null
                        , child: 
                        (statePuja)
                        ? const Text('Ver Puja')
                        : const Text('Puja no disponible')
                        ),
                      ],
                    )
                  ),
                )
              ],
            ),
            const SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFFAFCDEA),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))
              ),
              child: SizedBox(
                height: 845,
                child: 
                (load)
                ? const Center(child: CircularProgressIndicator(),)
                :SingleChildScrollView(
                  child: 
                  Column(
                    children: [     
                      Text(
                        partidaInfo.title, 
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontSize: 25
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            partidaInfo.estado, 
                            style: const TextStyle(
                              color: Colors.black54,
                              decoration: TextDecoration.none,
                              fontSize: 18
                            ),
                          ),
                          const SizedBox(width: 6,),
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: color[partidaInfo.estado]
                            ),
                          ),
                          const SizedBox(width: 50,),
                          Text(
                            'Periodo:${partidaInfo.periodo}', 
                            style: const TextStyle(
                              color: Colors.black54,
                              decoration: TextDecoration.none,
                              fontSize: 18
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Participantes ${data.length}/${partidaInfo.playerTotal}', 
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                              fontSize: 22
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          height: 399,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Administrador', 
                                      style: TextStyle(
                                        color: Color(0xFF318CE7),
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.none,
                                        fontSize: 19
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: Card(
                                    color: const Color(0xFF318CE7),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          (data[0]['player']['id']==user.id) 
                                          ?'${data[0]['player']['name']} (Yo)'
                                          :'${data[0]['player']['name']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          // fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.none,
                                          fontSize: 20
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(
                                  endIndent: 10,
                                  indent: 10,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Jugadores', 
                                      style: TextStyle(
                                        color: Color(0xFF318CE7),
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.none,
                                        fontSize: 19
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 250,
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: data.length-1,
                                    itemBuilder: (context, index) {
                                      return SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: Card(
                                          color: const Color(0xFF318CE7),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                // '${index+1}. ${data[index+1]['player']['name']}',
                                                (user.id == data[index+1]['player_id'])
                                                ? '${index+1}. ${data[index+1]['player']['name']} (Yo)' 
                                                : '${index+1}. ${data[index+1]['player']['name']}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                // fontWeight: FontWeight.bold,
                                                decoration: TextDecoration.none,
                                                fontSize: 20
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Cuotas Pendientes', 
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                              fontSize: 22
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          height: 299,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: 
                            (dataCuota.isEmpty)
                            ? const Center(
                                child: Text(
                                  'Vacio', 
                                  style: TextStyle(
                                    color: Color(0xFF318CE7),
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                    fontSize: 40
                                  ),
                                ),)
                            :
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: dataCuota.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: Card(
                                    color: const Color(0xFF318CE7),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                            'Ronda ${dataCuota[index]['number']['number']} no pagada', 
                                            style: const TextStyle(
                                              color: Colors.white,
                                              decoration: TextDecoration.none,
                                              fontSize: 20
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: ElevatedButton.icon(
                                            onPressed: (){
                                              // print('dataCuota[index]: ${dataCuota[index]}');
                                              Provider.of<CuotaProvider>(context,listen: false).changeCuota(
                                                newId: dataCuota[index]['id'].toString(),
                                                newCuota: dataCuota[index]['cuota'],
                                                newDiscount: dataCuota[index]['discount'],
                                                newFecha: dataCuota[index]['number']['transfer_end_date'],
                                                newPenaltyFee: dataCuota[index]['penalty_fee'],
                                                newState: dataCuota[index]['state'],
                                                newTotalAmount: dataCuota[index]['total_amount'],
                                                newDestination_participant_id: dataCuota[index]['destination_participant_id']
                                              );
                                              context.push('/qr-details/1');
                                            }, 
                                            icon: const Icon(Icons.qr_code_2), 
                                            label: const Text('Ver Qr')
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}