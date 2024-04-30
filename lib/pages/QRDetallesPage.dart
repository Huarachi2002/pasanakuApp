import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QRDetallesPage extends StatelessWidget {
  static const name = 'partida-screen';
  const QRDetallesPage({super.key});

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
                      context.push('/home');
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
                width: double.infinity,
                child: SizedBox(
                  child: Column(
                    children: [     
                      const Text(
                        'QR Detalle', 
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontSize: 35
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          width: 500,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color(0xFF318CE7)
                          ),
                          child:  const Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fecha maximo de pago', 
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none
                                  ),
                                ),
                                Text(
                                  '', 
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    decoration: TextDecoration.none
                                  ),
                                ),
                                SizedBox(height: 50,),
                                Text(
                                  'Monto de cuota', 
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                    decoration: TextDecoration.none
                                  ),
                                ),
                                Text(
                                  '', 
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    decoration: TextDecoration.none
                                  ),
                                ),
                                SizedBox(height: 50,),
                                Text(
                                  'Penalizacion', 
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                    decoration: TextDecoration.none
                                  ),
                                ),
                                Text(
                                  '', 
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    decoration: TextDecoration.none
                                  ),
                                ),
                                SizedBox(height: 50,),
                                Text(
                                  'Monto Total', 
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                    decoration: TextDecoration.none
                                  ),
                                ),
                                Text(
                                  '', 
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    decoration: TextDecoration.none
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ),
                      Center(
                  child: TextButton.icon(
                    onPressed: () {
                    },
                    icon: const Icon(Icons.download),
                    label: const Text(
                      'DESCARGAR QR', 
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontSize: 20
                      ),
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