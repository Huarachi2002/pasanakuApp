import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pasanaku_app/providers/cuota_provider.dart';
import 'package:pasanaku_app/providers/user_provider.dart';
import 'package:pasanaku_app/widgets/drawer.dart';
import 'package:provider/provider.dart';

class ScanCodePage extends StatefulWidget {
  static const name = 'qrScan-screen';
  const ScanCodePage({super.key});

  @override
  State<ScanCodePage> createState() => _ScanCodePageState();
}

class _ScanCodePageState extends State<ScanCodePage> {
  File ? _selectedImage;
  late MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      returnImage: true
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> showImageGallery()async{
    final returnedImage =  await ImagePicker().pickImage(source: ImageSource.gallery);
    if(returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
    print(_selectedImage);
    print(returnedImage.path);
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
                  height: MediaQuery.of(context).size.height * 0.85,
                  width: double.infinity,
                  child: SizedBox(
                    child: Column(
                      children: [
                        const Text(
                          'QR Scaner',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                            fontSize: 35
                          ),
                        ),
                        const SizedBox(height: 5,),
                        (_selectedImage != null )
                          ? Padding(
                            padding: const EdgeInsets.all(10),
                            child: SizedBox(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height * 0.40,
                                child: Image.file(_selectedImage!),
                              ),
                          )
                          : Padding(
                          padding: const EdgeInsets.all(15),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: 
                            MobileScanner(
                              controller: _controller,
                              onDetect: (capture) {
                                // _controller.stop();
                                // print(capture);
                                final List<Barcode> barcodes = capture.barcodes;
                                final Uint8List? image = capture.image;
                                for(final barcode in barcodes){
                                  print('Barcode found: ${barcode.rawValue}');
                                }
                                if(image != null){
                                  showDialog(context: context,builder: (context) {
                                      return AlertDialog(
                                        title: const Text('QR escaneado correctamente' , style: TextStyle(fontSize: 8),),
                                        content: Image(image: MemoryImage(image),),
                                        actions: [
                                          ElevatedButton.icon(
                                            // style: ElevatedButton.styleFrom(
                                            //   minimumSize: Size(MediaQuery.of(context).size.width * 0.1, MediaQuery.of(context).size.height * 0.001),
                                            //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Espaciado interno
                                            //   textStyle: const TextStyle(fontSize: 14),   
                                            // ),
                                            onPressed: (){
                                              Provider.of<CuotaProvider>(context,listen: false).changeCuota(
                                                newId:'0',
                                                newCuota: '100',
                                                newDiscount: '0',
                                                newFecha: '2024-05-20T02:37:00.000Z',
                                                newPenaltyFee: '0',
                                                newState: false,
                                                newTotalAmount: '100',
                                                newDestination_participant_id: Provider.of<UserProvider>(context,listen: false).id
                                              );
                                              // _controller.start();
                                              context.pop();
                                              context.push('/qr-details/1');
                                            }, 
                                            icon: const Icon(Icons.qr_code_2, size: 14,), 
                                            label: const Text('Ver QR')
                                          ),
                                        ],
                                      );
                                    }, 
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: 
                          (_selectedImage != null)
                          ?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(MediaQuery.of(context).size.width * 0.1, MediaQuery.of(context).size.height * 0.001),
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Espaciado interno
                                    textStyle: const TextStyle(fontSize: 14,),
                                  ),
                                  onPressed: (){
                                    showImageGallery();
                                  }, 
                                  icon: const Icon(Icons.image,size: 14,), 
                                  label: const Text('Seleccionar Imagen')
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(MediaQuery.of(context).size.width * 0.1, MediaQuery.of(context).size.height * 0.001),
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Espaciado interno
                                    textStyle: const TextStyle(fontSize: 14),   
                                  ),
                                  onPressed: (){
                                    Provider.of<CuotaProvider>(context,listen: false).changeCuota(
                                      newId:'0',
                                      newCuota: '100',
                                      newDiscount: '0',
                                      newFecha: '2024-05-20T02:37:00.000Z',
                                      newPenaltyFee: '0',
                                      newState: false,
                                      newTotalAmount: '100',
                                      newDestination_participant_id: Provider.of<UserProvider>(context,listen: false).id
                                    );
                                    context.push('/qr-details/1');
                                  }, 
                                  icon: const Icon(Icons.qr_code_2, size: 14,), 
                                  label: const Text('Ver QR')
                                ),
                              ],
                            )
                          :
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: (){
                                  showImageGallery();
                                }, 
                                icon: const Icon(Icons.image), 
                                label: const Text('Seleccionar Imagen')
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}