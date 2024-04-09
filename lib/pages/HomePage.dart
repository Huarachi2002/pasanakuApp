import 'dart:async';

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

  final List<Map<String,String>> data = [
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
        data: data, 
        filtro: filtro, 
        currentIndex: currentIndex
      )
    );
  } 
}

class _PartidaView extends StatefulWidget {
  const _PartidaView({
    super.key,
    required this.data,
    required this.filtro,
    required this.currentIndex,
  });

  final List<Map<String, String>> data;
  final List<String> filtro;
  final int currentIndex;

  @override
  State<_PartidaView> createState() => _PartidaViewState();
}

class _PartidaViewState extends State<_PartidaView> {
  bool load = true;

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
                  const SizedBox(height: 20,),
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
                                  '${widget.data[index]["title"]}', 
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                    fontSize: 20
                                  ),
                                ),
                                leading: ClipOval(
                                  child: Image.network(
                                    '${widget.data[index]['img']}',
                                    fit: BoxFit.cover,                       
                                  ),
                                ),
                                tileColor: const Color(0xFF318CE7),
                                subtitle: Text(
                                  '${widget.data[index]['subtitle']}',
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