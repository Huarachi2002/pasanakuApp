import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pasanaku_app/api/apiServicio.dart';
// import 'package:pasanaku_app/models/Invitaciones.dart';
import 'package:pasanaku_app/providers/user_provider.dart';
import 'package:pasanaku_app/widgets/drawer.dart';
import 'package:provider/provider.dart';

class NotificacionPage extends StatefulWidget {
  static const name = 'notificacion-screen';
  const NotificacionPage({super.key});

  @override
  State<NotificacionPage> createState() => _NotificacionPageState();
}

class _NotificacionPageState extends State<NotificacionPage> {
  List<dynamic> data = [];
  bool load = true;
  late Timer _timer;
  
  Future<void> getInvitaciones(BuildContext context) async {
    try {
      final player = Provider.of<UserProvider>(context, listen: false);
      final response = await dio.get('/notification/${player.id}');
      // print('Response Invitacion: ${response.data['data']}');
      data = response.data['data'];
      // print(data[0]['game']);
      // print('Response Data: $data');
    } on DioException catch (e) {
      if (e.response != null) {
        print('data: ${e.response!.data}');
        print('headers: ${e.response!.headers}');
        print('requestOptions: ${e.response!.requestOptions}');
        // print('Message: ${e.response!.data['errors']['details'][0]["msg"]}');
      } else {
        print('requestOptions: ${e.requestOptions}');
        print(e.message);
      }
    }
  }

  void reload() {
    getInvitaciones(context);
    _timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        load = !load;
      });
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Verifica si el widget está montado
        setState(() {
          load = !load;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancela el Timer para evitar errores
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getInvitaciones(context);
    Timer(const Duration(seconds: 1), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      fontSize: 25),
                ),
                SizedBox(
                  width: 15,
                ),
                Image(
                    image: AssetImage('assets/logo.png'),
                    width: 50,
                    height: 50),
              ],
            ),
          ),
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
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          size: 50,
                        ),
                        onTap: () {
                          if (context.canPop()) {
                            context.pop();
                            return;
                          }
                          context.push('/home');
                        },
                      )),
                ),
              ),
              const SizedBox(
                height: 10,
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
                      'NOTIFICACIONES',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontSize: 25),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.72,
                      child: (load)
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : (data.isEmpty)
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Vacio',
                                        style: TextStyle(
                                            color: Color(0xFF318CE7),
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.none,
                                            fontSize: 40),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              load = true;
                                            });
                                            reload();
                                          },
                                          style: ButtonStyle(
                                              iconSize: MaterialStateProperty
                                                  .all<double?>(40)),
                                          icon: const Icon(
                                              Icons.replay_outlined))
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Material(
                                        child: ListTile(
                                          title: Text(
                                            '${data[index]["title"]}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.none,
                                                fontSize: 20),
                                          ),
                                          leading: Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color:
                                                    const Color(0xFFD9D9D9),
                                              ),
                                              child: const Icon(
                                                Icons.monetization_on_rounded,
                                                size: 40,
                                                color: Colors.black,
                                              )),
                                          tileColor: const Color(0xFF318CE7),
                                          subtitle: Text(
                                            '${data[index]['body']}',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          trailing: const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.black,
                                          ),
                                          onTap: () {},
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
        ));
  }
}
