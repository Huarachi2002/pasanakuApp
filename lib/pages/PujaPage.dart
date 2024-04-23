import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:pasanaku_app/providers/partida_provider.dart';
import 'package:provider/provider.dart';

class PujaPage extends StatefulWidget {
  static const name = 'puja-screen';
  const PujaPage({super.key});

  @override
  State<PujaPage> createState() => _PujaPageState();
}

class _PujaPageState extends State<PujaPage> {
  List<Map<String,String>> data = [
    {
      'name': 'Fernando',
      'monto': '100'
    },
    {
      'name': 'Jose',
      'monto': '100'
    },
    {
      'name': 'Sebastian',
      'monto': '100'
    },
    {
      'name': 'Carlos',
      'monto': '100'
    },
  ];
  
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.100.17:3001/api',
    ),
  );

  @override
  Widget build(BuildContext context) {
    // final partidaInfo = Provider.of<PartidaProvider>(context, listen: false);
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
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFFAFCDEA),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))
              ),
              child: SizedBox(
                height: 845,
                child: SingleChildScrollView(
                  child: Column(
                    children: [     
                      const Text(
                        'PUJA', 
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontSize: 25
                        ),
                      ),
                      const SizedBox(height: 5,),
                    
                      const Padding(
                        padding: EdgeInsets.all(15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Lista de ganadores', 
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
                          height: 399,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 250,
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: data.length,
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
                                              '${index+1}. ${data[index]['name']} (${data[index]['monto']}bs)', 
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
                            'Pujas', 
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