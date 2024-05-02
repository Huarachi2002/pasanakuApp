import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:go_router/go_router.dart';
import 'package:pasanaku_app/api/apiServicio.dart';
import 'package:pasanaku_app/domain/entities/push_message.dart';
import 'package:pasanaku_app/providers/cuota_provider.dart';
import 'package:pasanaku_app/providers/user_provider.dart';
import 'package:pasanaku_app/services/bloc/notifications_bloc.dart';
import 'package:provider/provider.dart';

class QRDetallesPage extends StatefulWidget {
  static const name = 'qr-screen';
  final String pushMessageId;
  const QRDetallesPage({super.key, required this.pushMessageId});

  @override
  State<QRDetallesPage> createState() => _QRDetallesPageState();
}

class _QRDetallesPageState extends State<QRDetallesPage> {
  double? _progress;

  Future<void> pagar()async{
    try {
      final cuota = Provider.of<CuotaProvider>(context,listen: false);
      await dio.put('/transfers/${cuota.id}');
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

  @override
  Widget build(BuildContext context) {
    final PushMessage? message;
    if(widget.pushMessageId != 1){
      message = context.watch<NotificationsBloc>().getMessageById(widget.pushMessageId);
    }
    final user = Provider.of<UserProvider>(context,listen: false);
    final cuota = Provider.of<CuotaProvider>(context, listen: false);
    String url = 'http://www.ficct.uagrm.edu.bo:3001/uploads/player/${user.id}/${cuota.pathQr}';
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
                          child:  Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: SizedBox(
                                    child: Image.network(url),
                                    width: 200,  
                                    height: 200,
                                  ),
                                ),
                                const Text(
                                  'Fecha limite del pago',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none
                                  ),
                                ),
                                Text(
                                  // message!.data!['data'],
                                  cuota.fecha,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    decoration: TextDecoration.none
                                  ),
                                ),
                                const SizedBox(height: 50,),
                                const Text(
                                  'Monto de cuota',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                    decoration: TextDecoration.none
                                  ),
                                ),
                                Text(
                                  // message.data!['cuota'],
                                  '${cuota.cuota}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    decoration: TextDecoration.none
                                  ),
                                ),
                                const SizedBox(height: 50,),
                                const Text(
                                  'Penalizacion',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                    decoration: TextDecoration.none
                                  ),
                                ),
                                Text(
                                  // message.data!['penalty_fee'],
                                  '${cuota.penaltyFee}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    decoration: TextDecoration.none
                                  ),
                                ),
                                const SizedBox(height: 50,),
                                const Text(
                                  'Monto Total',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                    decoration: TextDecoration.none
                                  ),
                                ),
                                Text(
                                  // message.data!['total_amount'],
                                  '${cuota.totalAmount}',
                                  style: const TextStyle(
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
                        child:
                        (_progress != null)
                        ? const CircularProgressIndicator()
                        :
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  FileDownloader.downloadFile(
                                    // url: message.imageUrl!.trim(),
                                    url: url,
                                    onProgress: (fileName, progress) {
                                      setState(() {
                                        _progress = progress;
                                      });
                                    },
                                    onDownloadCompleted: (path) {
                                      print('path $path');
                                      setState(() {
                                        _progress = null;
                                      });
                                    },
                                  );
                              
                                },
                                icon: const Icon(Icons.download),
                                label: const Text(
                                  'DESCARGAR QR',
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: (){
                                  pagar();
                                  context.pop();
                                }, 
                                icon: const Icon(Icons.monetization_on_outlined), 
                                label: const Text('Pagar')
                              )
                            ],
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