import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:pasanaku_app/api/apiServicio.dart';
import 'package:pasanaku_app/providers/partida_provider.dart';
import 'package:pasanaku_app/providers/puja_provider.dart';
import 'package:pasanaku_app/providers/user_provider.dart';
import 'package:pasanaku_app/widgets/drawer.dart';
import 'package:provider/provider.dart';

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
  List<dynamic> data = [];
  int currentValue= 0;

  late Timer _timer;

  Future<void> getNumbersPuja() async{
    try {
      final player = Provider.of<UserProvider>(context, listen: false);
      final game = Provider.of<PartidaProvider>(context,listen: false);
      final response = await dio.get('/numbers/${game.id}');
      data = response.data['data'];
      for (var number in data) { 
        if(number['state']) idPuja = number['id'].toString(); 
        if(number['player_id'] == player.id) statePujar = false;
      }
      getPujar();
    } on DioException catch (e) {
        if(e.response != null){
          print('data: ${e.response!.data}');
          print('headers: ${e.response!.headers}');
          print('requestOptions: ${e.response!.requestOptions}');
        }else{
          print('requestOptions: ${e.requestOptions}');
          print(e.message);
        }
    } 
  }

  Future<void> getPujar()async{
    try {
      if(idPuja == '') return;
      final player = Provider.of<UserProvider>(context, listen: false);
      final response = await dio.get(
        '/offer/$idPuja',
        data: {
          "participant_id": player.idParticipant
        }
      );
      // print(response.data['data'].length);
      if(response.data['data'].length>0){
        statePujar = false;
        montoPuja = response.data['data'][0]['amount'];
      }  
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
        // print('playerIdPart: ${player.idParticipant}, idPuja: $idPuja , amount: $montoPuja');
        final response = await dio.post(
          '/offer/$idPuja',
          data: {
            'participant_id': player.idParticipant,
            'amount': montoPuja
          }
        );
        Provider.of<PujaProvider>(context,listen: false).changePuja(
          newMont: response.data['data']['amount'], 
          newNumberId: response.data['data']['number_id'],
          newParticipantId: response.data['data']['participant_id']
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
    getNumbersPuja();
    _timer = Timer(const Duration(seconds: 1), (){
      setState(() {
        
      });
    });
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) { 
      if(mounted){
        setState(() { 
          getNumbersPuja();
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<PartidaProvider>(context, listen: false);
    final pujaProvider = Provider.of<PujaProvider>(context, listen: false);
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
        child: SingleChildScrollView(
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
                        context.go('/partida');
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
                  height: MediaQuery.of(context).size.height * 0.85,
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
                            height: MediaQuery.of(context).size.height * 0.70,
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
                                      height: MediaQuery.of(context).size.height * 0.65,
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: data.length,
                                        itemBuilder: (context, index) {
                                          // print(data[index]);
                                          return SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: Card(
                                              elevation: 4,
                                              color: (idPuja == data[index]['id'].toString()) ? const Color(0xFF318CE7) : const Color(0xFFA3A8B7),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                    'Ronda ${index+1}:',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      decoration: TextDecoration.none,
                                                      fontSize: 16
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5,),
                                                    statePujar && montoPuja == 0
                                                    ?
                                                      idPuja == data[index]['id'].toString()
                                                      ?
                                                        Row(
                                                          children: [
                                                            const SizedBox(width: 20,),
                                                            CupertinoButton.filled(
                                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                                              borderRadius: BorderRadius.circular(10),
                                                              child: Text('$currentValue Bs'), 
                                                              onPressed: () => showCupertinoModalPopup(
                                                                context: context,
                                                                builder: (_) => SizedBox(
                                                                  width: double.infinity,
                                                                  height: 250,
                                                                  child: CupertinoPicker(
                                                                    backgroundColor: Colors.white,
                                                                    itemExtent: 30,
                                                                    scrollController: FixedExtentScrollController(
                                                                      initialItem: currentValue
                                                                    ),
                                                                    onSelectedItemChanged: (int value) {
                                                                      setState(() {
                                                                        currentValue=value + (game.cuota*0.20).toInt() ;
                                                                      });
                                                                    },
                                                                    children: 
                                                                      List<Widget>.generate(game.cuota - (game.cuota*0.20).toInt(), (int index) {
                                                                        return Center(child: Text('${index+(game.cuota*0.20).toInt()}'));
                                                                      }
                                                                    ),
                                                                  ),
                                                                )
                                                              )
                                                            ),
                                                            SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
                                                            ElevatedButton.icon(
                                                              onPressed: (){
                                                                setState(() {
                                                                  pujaProvider.changePuja(newMont: montoPuja);
                                                                  statePujar = false;
                                                                  montoPuja = currentValue;
                                                                  postPujar(context);
                                                                  // print(montoPuja);
                                                                });
                                                              }, 
                                                              icon: const Icon(Icons.monetization_on_rounded), 
                                                              label: const Text('Pujar')
                                                            )
                                                          ],
                                                        )
                                                      :
                                                        Text(
                                                          data[index]['player'] == null ? 'Puja no disponible': (data[index]['player']['name'].length > 14)? '${data[index]['player']['name'].substring(0,12)}... (${data[index]['winning_amount']} Bs)' :'${data[index]['player']['name']} (${data[index]['winning_amount']} Bs)',
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            // fontWeight: FontWeight.bold,
                                                            decoration: TextDecoration.none,
                                                            fontSize: 16
                                                          ),
                                                        )
                                                    :
                                                      (montoPuja > 0  && data[index]['player'] == null && data[index]['id'].toString() == idPuja)
                                                      ?
                                                      Text(
                                                          'Pujaste con $montoPuja Bs',
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            decoration: TextDecoration.none,
                                                            fontSize: 16
                                                          ),
                                                        )
                                                      :
                                                      Text(
                                                          data[index]['player'] == null ? 'Puja no disponible': (data[index]['player']['name'].length > 14)?'${data[index]['player']['name'].substring(0,12)}... (${data[index]['winning_amount']} Bs)' :'${data[index]['player']['name']} (${data[index]['winning_amount']} Bs)',
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            decoration: TextDecoration.none,
                                                            fontSize: 16
                                                          ),
                                                        )
                                                  ]   
                                                ),
                                              ),
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
        ),
      )
    );
  }
}