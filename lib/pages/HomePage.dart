import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pasanaku_app/providers/partida_provider.dart';
import 'package:pasanaku_app/providers/user_provider.dart';
import 'package:pasanaku_app/services/bloc/notifications_bloc.dart';
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

  bool load = true;
  String id = '';
  late Timer _timer;

  List<dynamic> dataFiltrada = [];
  final filtro = ['Iniciado', 'En espera', 'Finalizado'];
  final dio = Dio(
    BaseOptions(
        // baseUrl: 'http://192.168.100.17:3001/api',
        baseUrl: 'http://www.ficct.uagrm.edu.bo:3001/api'),
  );

  List<dynamic> data = [];

  Future<void> getNotification() async {
    try {
      final player = Provider.of<UserProvider>(context, listen: false);
      final response = await dio.get('/invitations/${player.userEmail}');
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

  Future<void> getPartidas() async {
    try {
      final playerId = Provider.of<UserProvider>(context, listen: false).id;
      final response = await dio.get(
        '/game/playerByPk/$playerId',
      );
      data = response.data['data'];
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
    context.push('/login');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPartidas();
    getNotification();
    reload();
  }

  void reload() {
    getPartidas();
    getNotification();
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
        drawer: const Drawer(
          backgroundColor: Color(0xFF666F88),
        ),
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
                  context.push('/invitations');
                  // context.push('/qr-details/343');
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
            // IconButton(
            //   onPressed: (){
            //     context.read<NotificationsBloc>().requestPermission();
            //   },
            //   icon: const Icon(Icons.settings)
            // ),
            IconButton(onPressed: () {
              context.push('/notificacion');
            }, icon: const Icon(Icons.notifications)),
            IconButton(
                onPressed: () {
                  logout();
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                )),
          ],
        ),
        body: Container(
          color: const Color(0xFF318CE7),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 90),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.search_outlined),
                        label: Text(
                          'Buscar',
                          style: TextStyle(color: Colors.white),
                        )),
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
                            fontSize: 25),
                      ),
                      (load)
                          ? const SizedBox(
                              height: 780,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : (dataFiltrada.isEmpty)
                              ? Column(
                                  children: [
                                    const Center(
                                      child: Text(
                                        'Vacio',
                                        style: TextStyle(
                                            color: Color(0xFF318CE7),
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.none,
                                            fontSize: 40),
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
                                )
                              : const SizedBox(
                                  height: 20,
                                ),
                      SizedBox(
                        height: 707,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: dataFiltrada.length,
                          itemBuilder: (context, index) {
                            if (dataFiltrada[index]['estado'] ==
                                filtro[currentIndex]) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
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
                                      context.push('/partida');
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
              ],
            ),
          ),
        ));
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
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        load = !load;
      });
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
    final notifications =
        context.watch<NotificationsBloc>().state.notifications;
    // print(notifications);
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
                    label: Text(
                      'Buscar',
                      style: TextStyle(color: Colors.white),
                    )),
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
                        fontSize: 25),
                  ),
                  (load)
                      ? const SizedBox(
                          height: 780,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : (widget.data.isEmpty)
                          ? Column(
                              children: [
                                const Center(
                                  child: Text(
                                    'Vacio',
                                    style: TextStyle(
                                        color: Color(0xFF318CE7),
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.none,
                                        fontSize: 40),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.replay_outlined))
                              ],
                            )
                          : const SizedBox(
                              height: 20,
                            ),
                  SizedBox(
                    height: 707,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.data.length,
                      itemBuilder: (context, index) {
                        if (widget.data[index]['estado'] ==
                            widget.filtro[widget.currentIndex]) {
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
                                      fontSize: 20),
                                ),
                                leading: ClipOval(
                                  child:
                                      widget.data[index]['path_image'] == null
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
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Cuota: ${widget.data[index]['cuota']}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Fecha de Inicio: ${widget.data[index]['start_date'].toString().substring(0, 10)}',
                                      style:
                                          const TextStyle(color: Colors.white),
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
                                          newTitle: widget.data[index]['name'],
                                          newId: widget.data[index]['id']
                                              .toString(),
                                          newEstado: widget.data[index]
                                              ['estado'],
                                          newCuota: int.parse(widget.data[index]
                                                  ['cuota']
                                              .toString()),
                                          newPlayerTotal: int.parse(widget
                                              .data[index]['number_of_players']
                                              .toString()),
                                          newPeriodo: widget.data[index]
                                              ['period']['name']);
                                  context.push('/partida');
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
          ],
        ),
      ),
    );
  }
}
