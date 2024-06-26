import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:pasanaku_app/api/apiServicio.dart';
import 'package:pasanaku_app/providers/invitacion_provider.dart';
import 'package:pasanaku_app/providers/user_provider.dart';
import 'package:pasanaku_app/widgets/drawer.dart';
import 'package:provider/provider.dart';

class InvitacionPage extends StatefulWidget {
  static const name = 'invitacion-screen';
  const InvitacionPage({super.key});

  @override
  State<InvitacionPage> createState() => _InvitacionPageState();
}

class _InvitacionPageState extends State<InvitacionPage> {
  final List<Map<String,String>> data = [];
  List<dynamic> dataPart = [];

  Future<void> confirmInvit (BuildContext context) async {
    try {
      final player_id = Provider.of<UserProvider>(context,listen: false).id;
      final invitacion_id = Provider.of<InvitacionProvider>(context,listen: false).id;

      await dio.post(
        '/invitations/confirm',
        data: {
          "player_id": player_id,
          "invitation_id" : invitacion_id
        }
      );
      print('Invitacion Confirmada');
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

  Future<void> denegInvit (BuildContext context) async {
    try {
      final invitacion_id = Provider.of<InvitacionProvider>(context,listen: false).id;
      await dio.delete(
        '/invitations/refuse',
        data: {
          "invitation_id" : invitacion_id
        }
      );
      print('Invitacion Rechazada');
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
  Widget build(BuildContext context) {
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
                        context.go('/invitations');
                      },
                    )
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFAFCDEA),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.85,
                    width: double.infinity,
                    child: SizedBox(
                      child: Column(
                        children: [     
                          const Text(
                            'INVITACION', 
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                              fontSize: 35
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: const Color(0xFF318CE7)
                              ),
                              child:  Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Adminitrador', 
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.none
                                      ),
                                    ),
                                    Text(
                                      context.watch<InvitacionProvider>().nameAdmin, 
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        decoration: TextDecoration.none
                                      ),
                                    ),
                                    const SizedBox(height: 20,),
                                    const Text(
                                      'Capacidad', 
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        decoration: TextDecoration.none
                                      ),
                                    ),
                                    Text(
                                      context.watch<InvitacionProvider>().capacidad, 
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        decoration: TextDecoration.none
                                      ),
                                    ),
                                    const SizedBox(height: 20,),
                                    const Text(
                                      'Cuota', 
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        decoration: TextDecoration.none
                                      ),
                                    ),
                                    Text(
                                      context.watch<InvitacionProvider>().cuota, 
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        decoration: TextDecoration.none
                                      ),
                                    ),
                                    const SizedBox(height: 20,),
                                    const Text(
                                      'Fecha de Inicio', 
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        decoration: TextDecoration.none
                                      ),
                                    ),
                                    Text(
                                      context.watch<InvitacionProvider>().fechaInit.substring(0,10), 
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        decoration: TextDecoration.none
                                      ),
                                    ),
                                    const SizedBox(height: 20,),
                                    const Text(
                                      'Periodo', 
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        decoration: TextDecoration.none
                                      ),
                                    ),
                                    Text(
                                      context.watch<InvitacionProvider>().periodo, 
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        decoration: TextDecoration.none
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(40, 20),
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Espaciado interno
                                  textStyle: const TextStyle(fontSize: 14),  
                                  backgroundColor: const Color(0xFF318CE7) 
                                ),
                                onPressed: () {
                                  confirmInvit(context);
                                  context.go('/home');
                                }, 
                                child: const Text(
                                  'ACEPTAR INVITACIÓN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              ),
                              // const SizedBox(width: 0,),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(40, 20),
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Espaciado interno
                                  textStyle: const TextStyle(fontSize: 14),  
                                  backgroundColor: Colors.grey
                                ),
                                onPressed:(){
                                  denegInvit(context);
                                  context.go('/invitations');
                                }, 
                                child: const Text(
                                  'RECHAZAR INVITACIÓN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              )
                             
                            ],
                          )
                        ],
                      ),
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