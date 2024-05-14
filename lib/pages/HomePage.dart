import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:pasanaku_app/api/apiServicio.dart';
import 'package:pasanaku_app/providers/partida_provider.dart';
import 'package:pasanaku_app/providers/user_provider.dart';
import 'package:pasanaku_app/widgets/drawer.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {

  static const name = 'home-screen';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currentIndex = 0;
  bool invitacion = false;
  bool notificacion = false;

  bool load = true;
  String id = '';
  late Timer _timer;

  List<dynamic> dataFiltrada = [];
  final filtro = ['Iniciado', 'En espera', 'Finalizado'];

  List<dynamic> data = [];

  Future<void> getInvitaciones() async {
    try {
      final player = Provider.of<UserProvider>(context, listen: false);
      final response = await dio.get('/invitations/${player.userEmail}');
      // print('length invitacion: ${response.data['data'].length}');
      if (response.data['data'].length > 0) invitacion = true;
    } on DioException catch (e) {
      if (e.response != null) {
        print('data: ${e.response!.data}');
        print('headers: ${e.response!.headers}');
        print('requestOptions: ${e.response!.requestOptions}');
      } else {
        print('requestOptions: ${e.requestOptions}');
        print(e.message);
      }
    }
  }
  Future<void> getNotificaciones() async {
    try {
      final player = Provider.of<UserProvider>(context, listen: false);
      final response = await dio.get('/notification/${player.id}');
      // print(response.data['data']);
      if (response.data['data'].length > 0) notificacion = true;
    } on DioException catch (e) {
      if (e.response != null) {
        print('data: ${e.response!.data}');
        print('headers: ${e.response!.headers}');
        print('requestOptions: ${e.response!.requestOptions}');
      } else {
        print('requestOptions: ${e.requestOptions}');
        print(e.message);
      }
    }
  }

  Future<void> getPartidas() async {
    try {
      final playerId = Provider.of<UserProvider>(context, listen: false).id;
      final response = await dio.get(
        '/game/playerByPk/$playerId',
      );
      data = response.data['data'];
      // print(data);
    } on DioException catch (e) {
      if (e.response != null) {
        print('data: ${e.response!.data}');
        print('headers: ${e.response!.headers}');
        print('requestOptions: ${e.response!.requestOptions}');
        print('Message: ${e.response!.data['errors']['details'][0]["msg"]}');
      } else {
        print('requestOptions: ${e.requestOptions}');
        print(e.message);
      }
    }
  }

  List<dynamic> filterData() {
    return data
        .where((element) => element['estado'] == filtro[currentIndex])
        .toList();
  }

  void logout() {
    Provider.of<UserProvider>(context, listen: false).deletedUser();
    context.go('/login');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reload();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) { 
      if(mounted){
        setState(() {
          getPartidas();
          getInvitaciones();
          getNotificaciones();
        });
      }
    });
  }

  void reload() {
    getPartidas();
    getInvitaciones();
    getNotificaciones();
    _timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        load = !load;
        dataFiltrada = filterData();
      });
      setState(() {});
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
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.double_arrow_rounded,
                ),
                label: 'INICIADOS',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.access_alarms_outlined), label: 'EN ESPERA'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.assistant_photo_rounded),
                  label: 'FINALIZADOS'),
            ]),
        drawer: const DrawerView(),
        appBar: AppBar(
          backgroundColor: const Color(0xFF318CE7),
          title: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'PASANAKU',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontSize: 20),
                ),
                SizedBox(
                  width: 15,
                ),
                Image(
                    image: AssetImage('assets/logo.png'),
                    width: 30,
                    height: 30),
              ],
            ),
          ),
          excludeHeaderSemantics: true,
          actions: [
            IconButton(
              onPressed: () {
                logout();
              },
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.red,
              )
            ),
          ],
        ),
        body: Container(
          color: const Color(0xFF318CE7),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width * 0.04,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.001),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.search_outlined),
                                  label: Text(
                                    'Buscar',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20,),
                        IconButton(
                          onPressed: () {
                            context.go('/invitations');
                            invitacion = false;
                          },
                          icon: (invitacion)
                              ? const Icon(
                                  Icons.group_add,
                                  color: Colors.amber,
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.group_add,
                                  color: Colors.black,
                                  size: 30,
                                )),
                        IconButton(onPressed: () {
                            context.go('/notificacion');
                            notificacion = false;
                          }, 
                          icon: 
                          (notificacion)
                          ? const Icon(Icons.notifications, color: Colors.amber,size: 30,)
                          : const Icon(Icons.notifications, color: Colors.black,size: 30,)
                        ),
                        const SizedBox(height: 20,)
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFFAFCDEA),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
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
                            ? const SizedBox(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : (dataFiltrada.isEmpty)
                                ? SingleChildScrollView(
                                  child: Column(
                                      children: [
                                        const Center(
                                          child: Text(
                                            'Vacio',
                                            style: TextStyle(
                                              color: Color(0xFF318CE7),
                                              fontWeight: FontWeight.bold,
                                              decoration: TextDecoration.none,
                                              fontSize: 40
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                load = true;
                                              });
                                              reload();
                                            },
                                            style: ButtonStyle(
                                                iconSize: MaterialStateProperty.all<
                                                    double?>(40)),
                                            icon: const Icon(Icons.replay_outlined))
                                      ],
                                    ),
                                )
                                : Container(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: dataFiltrada.length,
                            itemBuilder: (context, index) {
                              if (dataFiltrada[index]['estado'] ==
                                  filtro[currentIndex]) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Material(
                                    child: ListTile(
                                      title: Text(
                                        '${dataFiltrada[index]["name"]}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.none,
                                            fontSize: 20),
                                      ),
                                      leading: ClipOval(
                                        child: dataFiltrada[index]
                                                    ['path_image'] ==
                                                null
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: const Color(0xFFD9D9D9),
                                                ),
                                                child: const Image(
                                                    image: AssetImage(
                                                        'assets/groupImg.png'),
                                                    width: 40,
                                                    height: 40),
                                              )
                                            : Image.network(
                                                '${dataFiltrada[index]['path_image']}',
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                      tileColor: const Color(0xFF318CE7),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${dataFiltrada[index]['description']}',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Text(
                                            'Cuota: ${dataFiltrada[index]['cuota']}',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Text(
                                            'Fecha de Inicio: ${dataFiltrada[index]['start_date'].toString().substring(0, 10)}',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.black,
                                      ),
                                      onTap: () {
                                        Provider.of<PartidaProvider>(context,
                                                listen: false)
                                            .changePartida(
                                                newTitle: dataFiltrada[index]
                                                    ['name'],
                                                newId: dataFiltrada[index]['id']
                                                    .toString(),
                                                newEstado: dataFiltrada[index]
                                                    ['estado'],
                                                newCuota: int.parse(
                                                    dataFiltrada[index]['cuota']
                                                        .toString()),
                                                newPlayerTotal: int.parse(
                                                    dataFiltrada[index]
                                                            ['number_of_players']
                                                        .toString()),
                                                newPeriodo: dataFiltrada[index]
                                                    ['period']['name']);
                                        context.go('/partida');
                                        // context.push('/push-details/${notifications[0].messageId}');
                                      },
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
