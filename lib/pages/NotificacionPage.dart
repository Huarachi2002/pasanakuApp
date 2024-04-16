import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pasanaku_app/models/Invitaciones.dart';
import 'package:pasanaku_app/providers/invitacion_provider.dart';
import 'package:pasanaku_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class NotificacionPage extends StatefulWidget {
    static const name = 'notificacion-screen';
  const NotificacionPage({super.key});

  @override
  State<NotificacionPage> createState() => _NotificacionPageState();
}

class _NotificacionPageState extends State<NotificacionPage> {
  bool notification = false;
  List<dynamic> data = [];

  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.100.17:3001/api',
    ),
  );
  
  Future<void> getInvitaciones(BuildContext context)async{
    try {
      final email = context.watch<UserProvider>().userEmail;
      final response = await dio.get('/invitations/$email');
      print('Response Invitacion: ${response.data['data']}');
      data = response.data['data'];
      // print(data[0]['game']);
      // print('Response Data: $data');
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
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getInvitaciones(context);
    Timer(const Duration(seconds: 3), (){
      setState(() {
      });
    });
  }


  @override
  Widget build(BuildContext context) {
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
              setState(() {
                notification = !notification;
              });
            }, 
            icon: (notification) 
              ?const Icon(Icons.notifications_active_rounded,color: Colors.amber,size: 30,) 
              :const Icon(Icons.notifications, color: Colors.black,size: 30,)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
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
                decoration: const BoxDecoration(
                  color: Color(0xFFAFCDEA),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))
                ),
                child: Column(
                  children: [
                    
                    const SizedBox(height: 10,),
                    const Text(
                      'NOTIFICACIONES', 
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontSize: 25
                      ),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      height: 799,
                      child: 
                      data.isEmpty
                      ? const Center(child: CircularProgressIndicator(),)
                      :
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Material(
                              child: ListTile(
                                title: Text(
                                  '${data[index]["game"]['name']}', 
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                    fontSize: 20
                                  ),
                                ),
                                leading: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: const Color(0xFFD9D9D9),
                                  ),
                                  child: (true) //data[index]['game'] == 'INVITACIÓN'
                                    ? const Icon(Icons.contact_mail,size: 40,color: Colors.black,)
                                    : const Icon(Icons.monetization_on_rounded,size: 40,color: Colors.black,)
                                ),
                                tileColor: const Color(0xFF318CE7),
                                subtitle: Text(
                                  'Te han invitado a que te unas a la partida de ${data[index]['player']['name']}',
                                  style: const TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black,),
                                onTap: (){
                                  context.read<InvitacionProvider>().changeInvitacion(
                                    newId: data[index]['id'].toString(), 
                                    newNameAdmin: data[index]['player']['name'], 
                                    newCapacidad: data[index]['game']['number_of_players'].toString(), 
                                    newCuota: data[index]['game']['cuota'].toString(),
                                    newUsers: '1', 
                                    newFechaInit: data[index]['game']['start_date'].toString(), 
                                    newPeriodo: data[index]['game']['period']['name']
                                  );
                                  context.push('/invitacion');
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}