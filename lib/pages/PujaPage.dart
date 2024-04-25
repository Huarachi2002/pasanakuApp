import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:pasanaku_app/providers/partida_provider.dart';
import 'package:pasanaku_app/providers/user_provider.dart';
// import 'package:pasanaku_app/providers/partida_provider.dart';
import 'package:pasanaku_app/widgets/card.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

class PujaPage extends StatefulWidget {
  static const name = 'puja-screen';
  const PujaPage({super.key});

  @override
  State<PujaPage> createState() => _PujaPageState();
}

class _PujaPageState extends State<PujaPage> {
  int montoPuja = 0;
  String idPuja = '';
  int participantId = 0;
  bool statePujar = true;
  UserProvider? player;
  PartidaProvider? game;
  List<dynamic> data = [
    // {
    //   'ganador': 'Fernando',
    //   'monto': '100',
    //   'state': false
    // },
    // {
    //   'ganador': '',
    //   'monto': '',
    //   'state': true
    // },
    // {
    //   'ganador': '',
    //   'monto': '',
    //   'state': false
    // },
    // {
    //   'ganador': '',
    //   'monto': '',
    //   'state': false
    // },
  ];
  
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.100.17:3001/api',
    ),
  );

  Future<void> getNumbersPuja(BuildContext context) async{
    try {
      player = Provider.of<UserProvider>(context, listen: false);
      game = Provider.of<PartidaProvider>(context,listen: false);
      final response = await dio.get('/numbers/${game!.id}');
      data = response.data['data'];
      data.forEach((number) { 
        if(number['state']) idPuja = number['id'].toString(); 
        if (number['player_id'] == player!.id) statePujar = false;
      });
      
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

  Future<void> getPujar(BuildContext context)async{
    try {
        final player = Provider.of<UserProvider>(context, listen: false);
        print('playerIdPart: ${player.idParticipant}, idPuja: $idPuja');
        final response = await dio.get(
          '/offer/$idPuja',
          data: {
            'participant_id': player.idParticipant,
          }
        );
        if(response.data['data'].length > 0) statePujar = false;
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

  Future<void> postPujar(BuildContext context)async{
      try {
        final player = Provider.of<UserProvider>(context, listen: false);
        print('playerIdPart: ${player.idParticipant}, idPuja: $idPuja , amount: $montoPuja');
        final response = await dio.post(
          '/offer/$idPuja',
          data: {
            'participant_id': player.idParticipant,
            'amount': montoPuja
          }
        );

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNumbersPuja(context);
    getPujar(context);
    Timer(const Duration(seconds: 1), (){
      setState(() {
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final partidaInfo = Provider.of<PartidaProvider>(context, listen: false);
    return Scaffold(
      drawer: const Drawer(
        backgroundColor: Color(0xFF666F88),
        
      ),
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
                      decoration: TextDecoration.none
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
        actions: [
          IconButton(
            onPressed: (){
              context.push('/notificacion');
            }, 
            icon: const Icon(Icons.notifications, color: Colors.black,size: 30,)
          )
        ],
      ),
      body: Container(
        color: const Color(0xFF318CE7),
        child: Column(
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
            const SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFFAFCDEA),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))
              ),
              child: SizedBox(
                height: 845,
                child: SingleChildScrollView(
                  child: Column(
                    children: [     
                      const Text(
                        'PUJA', 
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontSize: 25
                        ),
                      ),
                      const SizedBox(height: 5,),
                    
                      const Padding(
                        padding: EdgeInsets.all(15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Lista de ganadores', 
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
                          height: 700,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 250,
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: CustomCard(
                                            montoPujado: montoPuja,
                                            initialValue: (game!.cuota *0.20).toInt(),
                                            minValue: (game!.cuota *0.20).toInt(),
                                            maxValue: game!.cuota,
                                            state: data[index]['state'],
                                            text: 'Ronda ${index+1}:',
                                            ganador: data[index]['player'] != null ? data[index]['player']['name'] : '',
                                            montoGanador: data[index]['winning_amount']!=null ? data[index]['winning_amount'].toString() : '',
                                            pujar: statePujar,
                                            changedPujar: (value) {
                                              montoPuja = value;
                                              print('montoPuja: $montoPuja');
                                              statePujar = false;
                                              postPujar(context);
                                            },
                                          )
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
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