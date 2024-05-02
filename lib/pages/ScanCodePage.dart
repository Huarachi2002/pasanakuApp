import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanCodePage extends StatefulWidget {
  const ScanCodePage({super.key});

  @override
  State<ScanCodePage> createState() => _ScanCodePageState();
}

class _ScanCodePageState extends State<ScanCodePage> {

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
                        'QR Scaner',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontSize: 35
                        ),
                      ),
                      const SizedBox(height: 5,),
                      MobileScanner(
                        controller: MobileScannerController(
                          detectionSpeed: DetectionSpeed.normal,
                          returnImage: true
                        ),
                        onDetect: (capture) {
                          print(capture);
                          final List<Barcode> barcodes = capture.barcodes;
                          final Uint8List? image = capture.image;
                          for(final barcode in barcodes){
                            print('Barcode found: ${barcode.rawValue}');
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}