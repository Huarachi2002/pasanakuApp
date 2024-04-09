import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificacionPage extends StatefulWidget {
    static const name = 'notificacion-screen';
  const NotificacionPage({super.key});

  @override
  State<NotificacionPage> createState() => _NotificacionPageState();
}

class _NotificacionPageState extends State<NotificacionPage> {
  bool notification = false;
  final List<Map<String,String>> data = [
    {
      'title':'INVITACIÓN',
      'subtitle':'Te han invitado a que te unas a la partida de Miguel Peinado'
    },
    {
      'title':'INVITACIÓN',
      'subtitle':'Te han invitado a que te unas a la partida de Miguel Peinado'
    },
    {
      'title':'CUOTA PENDIENTE',
      'subtitle':'Tienes una cuota pendiente de la partida de MICREROS'
    },
    {
      'title':'CUOTA PENDIENTE',
      'subtitle':'Tienes una cuota pendiente de la partida de MICREROS'
    },
    {
      'title':'INVITACIÓN',
      'subtitle':'Te han invitado a que te unas a la partida de Miguel Peinado'
    },
    {
      'title':'INVITACIÓN',
      'subtitle':'Te han invitado a que te unas a la partida de Miguel Peinado'
    },
    {
      'title':'CUOTA PENDIENTE',
      'subtitle':'Tienes una cuota pendiente de la partida de MICREROS'
    },
    {
      'title':'CUOTA PENDIENTE',
      'subtitle':'Tienes una cuota pendiente de la partida de MICREROS'
    },
    {
      'title':'INVITACIÓN',
      'subtitle':'Te han invitado a que te unas a la partida de Miguel Peinado'
    },
    {
      'title':'INVITACIÓN',
      'subtitle':'Te han invitado a que te unas a la partida de Miguel Peinado'
    },
    {
      'title':'CUOTA PENDIENTE',
      'subtitle':'Tienes una cuota pendiente de la partida de MICREROS'
    },
    {
      'title':'CUOTA PENDIENTE',
      'subtitle':'Tienes una cuota pendiente de la partida de MICREROS'
    },
    {
      'title':'INVITACIÓN',
      'subtitle':'Te han invitado a que te unas a la partida de Miguel Peinado'
    },
    {
      'title':'INVITACIÓN',
      'subtitle':'Te han invitado a que te unas a la partida de Miguel Peinado'
    },
    {
      'title':'CUOTA PENDIENTE',
      'subtitle':'Tienes una cuota pendiente de la partida de MICREROS'
    },
    {
      'title':'CUOTA PENDIENTE',
      'subtitle':'Tienes una cuota pendiente de la partida de MICREROS'
    },
    {
      'title':'INVITACIÓN',
      'subtitle':'Te han invitado a que te unas a la partida de Miguel Peinado'
    },
    {
      'title':'INVITACIÓN',
      'subtitle':'Te han invitado a que te unas a la partida de Miguel Peinado'
    },
    {
      'title':'CUOTA PENDIENTE',
      'subtitle':'Tienes una cuota pendiente de la partida de MICREROS'
    },
    {
      'title':'CUOTA PENDIENTE',
      'subtitle':'Tienes una cuota pendiente de la partida de MICREROS'
    },
  ];
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
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
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
                              leading: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: const Color(0xFFD9D9D9),
                                ),
                                child: (data[index]["title"] == 'INVITACIÓN')
                                  ? const Icon(Icons.contact_mail,size: 40,color: Colors.black,)
                                  : const Icon(Icons.monetization_on_rounded,size: 40,color: Colors.black,)
                              ),
                              tileColor: const Color(0xFF318CE7),
                              subtitle: Text(
                                '${data[index]['subtitle']}',
                                style: const TextStyle(
                                  color: Colors.white
                                ),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black,),
                              onTap: (){},
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
      )
    );
  }
}