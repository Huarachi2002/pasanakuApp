import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pasanaku_app/api/apiServicio.dart';
import 'package:pasanaku_app/providers/user_provider.dart';
import 'package:pasanaku_app/widgets/drawer.dart';
import 'package:provider/provider.dart';

class QRupdate extends StatefulWidget {
  static const name = 'qrUpdate-screen';
  const QRupdate({super.key});

  @override
  State<QRupdate> createState() => _QRupdateState();
}

class _QRupdateState extends State<QRupdate> {
  File ? _selectedImage;

  Future<void> updateQr()async{
    try {
      if(_selectedImage != null){
        String filename =  _selectedImage!.path.split('/').last;
        print(filename);
        FormData formData = FormData.fromMap({
          "qr": await MultipartFile.fromFile(_selectedImage!.path, filename: filename),
        });
        final user = Provider.of<UserProvider>(context,listen: false);
        final response = await dio.put(
          '/player/${user.id}/qr',
          data: formData
        );
        print('imagen subida');
        print(response.data['data']);
      }
    } on DioException catch (e) {
        if(e.response != null){
          print('data: ${e.response!.data}');
          print('headers: ${e.response!.headers}');
          print('requestOptions: ${e.response!.requestOptions}');
          // print('Message: ${e.response!.data['errors']['details'][0]["msg"]}');
        }else{
          print('requestOptions: ${e.requestOptions}');
          print(e.message);
        }
    } 
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
                        'Subir QR',
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
                              height: 400,
                              child: Image.file(_selectedImage!),
                            ),
                        )
                        : Container(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: 
                        (_selectedImage != null)
                        ?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                onPressed: (){
                                  showImageGallery();
                                }, 
                                icon: const Icon(Icons.image), 
                                label: const Text('Seleccionar Imagen')
                              ),
                              ElevatedButton.icon(
                                onPressed: (){
                                  updateQr();
                                  showDialog(
                                    context: context, 
                                    builder: (context) => AlertDialog(
                                      actions: [
                                        TextButton(
                                          onPressed: (){
                                            context.pop();
                                          }, 
                                          child: const Text('ok')
                                        )
                                      ],
                                      title: const Text('Imagen Subida'),
                                      contentPadding: const EdgeInsets.all(20),
                                      content: const Text('Se subio correctamente la imagen'),
                                    )
                                  );
                                }, 
                                icon: const Icon(Icons.upload), 
                                label: const Text('Actualizar QR')
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
            ),
          ],
        ),
      )
    );
  }
}