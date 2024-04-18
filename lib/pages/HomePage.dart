import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:pasanaku_app/providers/partida_provider.dart';
import 'package:pasanaku_app/providers/user_provider.dart';
import 'package:pasanaku_app/services/bloc/notifications_bloc.dart';
import 'package:provider/provider.dart';

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
  
  List<dynamic> dataFiltrada = [];
  final filtro = ['Iniciado','En espera','Finalizado'];
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.100.17:3001/api',
    ),
  );

  List<dynamic> data = [];

  Future<void> getPartidas() async{
    try {
      final playerId = Provider.of<UserProvider>(context,listen: false).id;
      final response = await dio.get(
        '/game/playerByPk/$playerId',
      );
      data = response.data['data'];
      // print(data);
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

  List<dynamic> filterData(){
    return data.where((element) => element['estado'] == filtro[currentIndex]).toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPartidas();
    dataFiltrada = filterData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
            dataFiltrada = filterData();
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
        title: context.select((NotificationsBloc bloc) 
          => Center(
            child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${bloc.state.status}', 
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontSize: 10
                    ),
                  ),
                  const SizedBox(width: 15,),
                  const Image(
                    image: AssetImage('assets/logo.png'),
                    width: 50,
                    height: 50
                  ),
                ],
              ),
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
          ),
          IconButton(
            onPressed: (){
              context.read<NotificationsBloc>().requestPermission();  
            },
            icon: const Icon(Icons.settings)
          )
        ],
      ),
      body: _PartidaView(
        data: dataFiltrada,
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
    required this.data,
  });
  final List<String> filtro;
  final int currentIndex;
  final List<dynamic> data;

  @override
  State<_PartidaView> createState() => _PartidaViewState();
}

class _PartidaViewState extends State<_PartidaView> {
  bool load = true;
  String id = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                  (widget.data.isEmpty)
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
                      itemCount: widget.data.length,
                      itemBuilder: (context, index) {
                        if(widget.data[index]['estado'] == widget.filtro[widget.currentIndex]) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Material(
                              child: ListTile(
                                title: Text(
                                  '${widget.data[index]["name"]}', 
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                    fontSize: 20
                                  ),
                                ),
                                leading: ClipOval(
                                  child: 
                                    widget.data[index]['path_image'] == null 
                                    ?Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: const Color(0xFFD9D9D9),
                                      ),
                                      child: const Image(
                                        image: AssetImage('assets/groupImg.png'),
                                        width: 40,
                                        height: 40
                                      ),
                                    )
                                    :Image.network(
                                      '${widget.data[index]['path_image']}',
                                      fit: BoxFit.cover,                       
                                  ),
                                ),
                                tileColor: const Color(0xFF318CE7),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${widget.data[index]['description']}',
                                      style: const TextStyle(
                                        color: Colors.white
                                      ),
                                    ),
                                    Text(
                                      'Cuota: ${widget.data[index]['cuota']}',
                                      style: const TextStyle(
                                        color: Colors.white
                                      ),
                                    ),
                                    Text(
                                      'Fecha de Inicio: ${widget.data[index]['start_date'].toString().substring(0,10)}',
                                      style: const TextStyle(
                                        color: Colors.white
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black,),
                                onTap: (){
                                  context.read<PartidaProvider>().changePartida(
                                    newTitle: widget.data[index]['name'], 
                                    newId: widget.data[index]['id'],
                                    newEstado: widget.data[index]['estado'], 
                                    newCuota: int.parse(widget.data[index]['cuota'].toString()), 
                                    newPlayerTotal: int.parse(widget.data[index]['number_of_players'].toString()) , 
                                    newPeriodo: widget.data[index]['period']['name']
                                  );
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