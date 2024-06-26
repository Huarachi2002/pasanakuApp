import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:go_router/go_router.dart';
import 'package:pasanaku_app/api/apiServicio.dart';
import 'package:pasanaku_app/domain/entities/push_message.dart';
import 'package:pasanaku_app/providers/cuota_provider.dart';
import 'package:pasanaku_app/providers/partida_provider.dart';
import 'package:pasanaku_app/services/bloc/notifications_bloc.dart';
import 'package:pasanaku_app/widgets/drawer.dart';
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
  String pathQr ='';
  bool load = true;
  late Timer _timer;

  Future<void>getQr()async{
    try { 
      final cuota = Provider.of<CuotaProvider>(context,listen: false);
      final response = await dio.get('/player/${cuota.destination_participant_id}');
      // print('dataDestination: ${response.data['data']}');
      pathQr = response.data['data']['path_qr'].toString();
      // print('Pathqr: $pathQr');
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

  Future<void> pagar()async{
    try {
      final cuota = Provider.of<CuotaProvider>(context,listen: false);
      if(cuota.id == '0') return;
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getQr();
    _timer = Timer(const Duration(seconds: 5), () {
      setState(() {
        load = !load;
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
    final PushMessage? message;
    if(widget.pushMessageId != 1){
      message = context.watch<NotificationsBloc>().getMessageById(widget.pushMessageId);
    }
    final cuota = Provider.of<CuotaProvider>(context, listen: false);
    // print('userID: ${user.id} , pathQr: $pathQr');
    String url = 'http://www.ficct.uagrm.edu.bo:3001/uploads/player/${cuota.destination_participant_id}/$pathQr';
    // print(url);
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
                        final partida = Provider.of<PartidaProvider>(context,listen: false).id;
                        if(partida == ''){
                          context.go('/home');
                        }else{
                          context.go('/partida');
                        }
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
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: double.infinity,
                  child: SizedBox(
                    child: SingleChildScrollView(
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
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: const Color(0xFF318CE7)
                              ),
                              child:  Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    (load)
                                    ? const Center(
                                        child: SizedBox(
                                          width: 200,
                                          height: 200,
                                          child: CircularProgressIndicator(),
                                        )
                                      )
                                    :
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
                                        child: SizedBox(
                                          child: (pathQr != '') ? Image.network(url) : Image.asset('assets/errorImage.jpg'),
                                          width: 200,  
                                          height: 200,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      'Fecha limite del pago',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.none
                                      ),
                                    ),
                                    Text(
                                      'Fecha: ${cuota.fecha.substring(0,10)} \nHora: ${cuota.fecha.substring(11,19)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        decoration: TextDecoration.none
                                      ),
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                                    const Text(
                                      'Monto de cuota',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        decoration: TextDecoration.none
                                      ),
                                    ),
                                    Text(
                                      // message.data!['cuota'],
                                      cuota.cuota,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        decoration: TextDecoration.none
                                      ),
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                                    const Text(
                                      'Penalizacion',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        decoration: TextDecoration.none
                                      ),
                                    ),
                                    Text(
                                      // message.data!['penalty_fee'],
                                      cuota.penaltyFee,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        decoration: TextDecoration.none
                                      ),
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                                    const Text(
                                      'Monto Total',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        decoration: TextDecoration.none
                                      ),
                                    ),
                                    Text(
                                      // message.data!['total_amount'],
                                      cuota.totalAmount,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
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
                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height * 0.01),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: 
                                    (load)
                                    ? null
                                    :
                                      () {
                                      FileDownloader.downloadFile(
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
                                        onDownloadError: (errorMessage) {
                                          print('DOWNLOAD ERROR: $errorMessage');
                                        },
                                        notificationType: NotificationType.all,
                                        onDownloadRequestIdReceived: (downloadId) {
                                          print('downloadId: $downloadId');
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
                                      final partida = Provider.of<PartidaProvider>(context,listen: false).id;
                                      if(partida == ''){
                                        context.go('/home');
                                      }else{
                                        context.go('/partida');
                                      }
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
              ),
            ],
          ),
        ),
      )
    );
  }
}