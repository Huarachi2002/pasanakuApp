import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:pasanaku_app/providers/partida_provider.dart';
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
  bool load = true;

  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.100.17:3001/api',
    ),
  );

  Future<void> getParticipants() async {
    try {
      final gameId = Provider.of<PartidaProvider>(context, listen: false).id;
      final response = await dio.get('/participant/gamePk/$gameId');
      data = response.data['data'];
      print('Data Participantes: $data');
      print('Data Participantes: ${data[0]['player']['name']}');

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
    getParticipants();
    Timer(Duration(seconds: 1), () {
      setState(() {
        load = !load;
      });
    },);
  }

  @override
  Widget build(BuildContext context) {
    final partidaInfo = Provider.of<PartidaProvider>(context, listen: false);
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
                    child: ElevatedButton(onPressed: 
                    (true)
                    ?() {
                      context.push('/puja');
                    } 
                    : null
                    , child: 
                    (true)
                    ? const Text('Ver Puja')
                    : const Text('Puja no disponible')
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
                              color: const Color(0xFFFAFF00)
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
                            'Participantes ${partidaInfo.cantPlayer}/${partidaInfo.playerTotal}', 
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
                                        '${data[0]['player']['name']}',
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
                                              '${index+1}. ${data[index+1]['player']['name']}', 
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
                            (true)
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
                            Column(
                              children: [
                                
                              ],
                            )
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Cuota Actual', 
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
                          height: 70,
                          width: double.infinity,
                          child: Container(
                             decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                              ),
                            child: Center(
                              child: ListView.builder(
                                itemCount: 10,
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.only(left: 20),
                                itemBuilder: (context, index) {
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(50)
                                        ),
                                        child: Center(child: Text('${index+1}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                                      ),
                                      (index != 9)
                                        ?const SizedBox(width: 20,child: Divider(color: Colors.grey,))
                                        :const SizedBox(width: 20,)
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      )
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