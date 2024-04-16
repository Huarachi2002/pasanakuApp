import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  static const name = 'home-screen';
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  bool notification = true;
  bool load = true;
  
  final filtro = ['Iniciado','Espera','Finalizado'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.double_arrow_rounded,),label: 'INICIADOS',),
          BottomNavigationBarItem(icon: Icon(Icons.access_alarms_outlined),label: 'EN ESPERA'),
          BottomNavigationBarItem(icon: Icon(Icons.assistant_photo_rounded),label: 'FINALIZADOS'),
        ] 
      ),
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
              setState(() {
                notification = !notification;
              });
              context.push('/notificacion');
            }, 
            icon: (notification) 
              ?const Icon(Icons.notifications_active_rounded,color: Colors.amber,size: 30,) 
              :const Icon(Icons.notifications, color: Colors.black,size: 30,)
          )
        ],
      ),
      body: _PartidaView(
        filtro: filtro, 
        currentIndex: currentIndex
      )
    );
  } 
}

class _PartidaView extends StatefulWidget {
  const _PartidaView({
    required this.filtro,
    required this.currentIndex,
  });
  final List<String> filtro;
  final int currentIndex;

  @override
  State<_PartidaView> createState() => _PartidaViewState();
}

class _PartidaViewState extends State<_PartidaView> {
  bool load = true;

  String id = '';
  List<Map<String,String>> data = [
      {
      "title": "INICIADOS",
      "subtitle": '''Cuota: 1000 bs 
Fecha Inicio: 15 Mar 2024, 8:20 PM''',
      "img": "https://upload.wikimedia.org/wikipedia/commons/2/2d/Micro_de_Santa_Cruz.jpg",
      "estado": "Iniciado"
    },
    {
      "title": "INICIADOS",
      "subtitle": '''Cuota: 1000 bs 
Fecha Inicio: 15 Mar 2024, 8:20 PM''',
      "img": "https://upload.wikimedia.org/wikipedia/commons/2/2d/Micro_de_Santa_Cruz.jpg",
      "estado": "Iniciado"
    },
    {
      "title": "INICIADOS",
      "subtitle": '''Cuota: 1000 bs 
Fecha Inicio: 15 Mar 2024, 8:20 PM''',
      "img": "https://upload.wikimedia.org/wikipedia/commons/2/2d/Micro_de_Santa_Cruz.jpg",
      "estado": "Iniciado"
    },
    {
      "title": "INICIADOS",
      "subtitle": '''Cuota: 1000 bs 
Fecha Inicio: 15 Mar 2024, 8:20 PM''',
      "img": "https://upload.wikimedia.org/wikipedia/commons/2/2d/Micro_de_Santa_Cruz.jpg",
      "estado": "Iniciado"
    },
    {
      "title": "INICIADOS",
      "subtitle": '''Cuota: 1000 bs 
Fecha Inicio: 15 Mar 2024, 8:20 PM''',
      "img": "https://upload.wikimedia.org/wikipedia/commons/2/2d/Micro_de_Santa_Cruz.jpg",
      "estado": "Iniciado"
    },
    {
      "title": "INICIADOS",
      "subtitle": '''Cuota: 1000 bs 
Fecha Inicio: 15 Mar 2024, 8:20 PM''',
      "img": "https://upload.wikimedia.org/wikipedia/commons/2/2d/Micro_de_Santa_Cruz.jpg",
      "estado": "Iniciado"
    },
    {
      "title": "INICIADOS",
      "subtitle": '''Cuota: 1000 bs 
Fecha Inicio: 15 Mar 2024, 8:20 PM''',
      "img": "https://upload.wikimedia.org/wikipedia/commons/2/2d/Micro_de_Santa_Cruz.jpg",
      "estado": "Iniciado"
    },
    {
      "title": "INICIADOS",
      "subtitle": '''Cuota: 1000 bs 
Fecha Inicio: 15 Mar 2024, 8:20 PM''',
      "img": "https://upload.wikimedia.org/wikipedia/commons/2/2d/Micro_de_Santa_Cruz.jpg",
      "estado": "Iniciado"
    },
    {
      "title": "INICIADOS",
      "subtitle": '''Cuota: 1000 bs 
Fecha Inicio: 15 Mar 2024, 8:20 PM''',
      "img": "https://upload.wikimedia.org/wikipedia/commons/2/2d/Micro_de_Santa_Cruz.jpg",
      "estado": "Iniciado"
    },
    {
      "title": "ESPERA",
      "subtitle": '''Cuota: 1000 bs 
Fecha Inicio: 15 Mar 2024, 8:20 PM''',
      "img": "https://upload.wikimedia.org/wikipedia/commons/2/2d/Micro_de_Santa_Cruz.jpg",
      "estado": "Espera"
    },
    {
      "title": "FINALIZADOS",
      "subtitle": '''Cuota: 1000 bs 
Fecha Inicio: 15 Mar 2024, 8:20 PM''',
      "img": "https://upload.wikimedia.org/wikipedia/commons/2/2d/Micro_de_Santa_Cruz.jpg",
      "estado": "Finalizado"
    },
    ];

  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.100.17:3001/api',
    ),
  );

  Future<void> getIdPlayer()async{
    try {
      final response = await dio.get('/player');
      id = response.data['id'];
    } on DioException catch (e) {
        if(e.response != null){
          print('data: ${e.response!.data}');
          print('headers: ${e.response!.headers}');
          print('requestOptions: ${e.response!.requestOptions}');
          print('Message: ${e.response!.data['errors']['details'][0]["msg"]}');
        }else{
          print('requestOptions: ${e.requestOptions}');
          print(e.message);
        }
    } 
  }

  Future<void> getPartidas() async{
    try {
      final response = await dio.get(
        '/game/$id',
      );
      data = response.data['data'];
    } on DioException catch (e) {
        if(e.response != null){
          print('data: ${e.response!.data}');
          print('headers: ${e.response!.headers}');
          print('requestOptions: ${e.response!.requestOptions}');
          print('Message: ${e.response!.data['errors']['details'][0]["msg"]}');
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
    // getPartidas();
    Timer(const Duration(seconds: 3), (){
      setState(() {
        load = !load;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF318CE7),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 90),
              child: TextFormField(
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.search_outlined),
                  label: Text('Buscar',style: TextStyle(color: Colors.white),)
                ),
              ),
            ),
            const SizedBox(height: 30,),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFAFCDEA),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  const Text(
                    'PARTIDAS', 
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontSize: 25
                    ),
                  ),
                  (load)
                  ?const SizedBox(
                    height: 780,
                    child: Center(
                        child: CircularProgressIndicator(),
                      ),
                  )
                  :
                  (data.isEmpty)
                  ? const Center(
                      child: Text(
                        'Vacio', 
                        style: TextStyle(
                          color: Color(0xFF318CE7),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontSize: 19
                        ),
                      ),)
                    
                  :const SizedBox(height: 20,),
                  SizedBox(
                    height: 707,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        if(data[index]['estado'] == widget.filtro[widget.currentIndex]) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Material(
                              child: ListTile(
                                title: Text(
                                  '${data[index]["title"]}', 
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                    fontSize: 20
                                  ),
                                ),
                                leading: ClipOval(
                                  child: Image.network(
                                    '${data[index]['img']}',
                                    fit: BoxFit.cover,                       
                                  ),
                                ),
                                tileColor: const Color(0xFF318CE7),
                                subtitle: Text(
                                  '${data[index]['subtitle']}',
                                  style: const TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black,),
                                onTap: (){
                                  context.push('/partida');
                                },
                              ),
                            ),
                          );
                        }else{
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}