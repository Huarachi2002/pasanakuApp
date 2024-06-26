
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pasanaku_app/api/apiServicio.dart';
import 'package:pasanaku_app/providers/user_provider.dart';
import 'package:pasanaku_app/services/bloc/notifications_bloc.dart';
import 'package:pasanaku_app/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  static const name = 'register-screen';
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File ? _selectedImage;

  String nombre_text = '';
  String telefono_text = '';
  String ci_text = '';
  String correo_text = '';
  String password_text = '';
  String password2_text = '';
  String qrPath = '';
  String erroEmail = '';
  
  Future<void> registerUser(String token) async{
    try {
      Response response;
      if(_selectedImage != null){
        String filename =  _selectedImage!.path.split('/').last;
        // print(filename);
        FormData formData = FormData.fromMap({
          "email": correo_text,
          "name": nombre_text,
          "ci": ci_text,
          "password": password_text,
          "address": "prueba",
          "telephone": '+591$telefono_text',
          "token_FCM": token,
          "qr": await MultipartFile.fromFile(_selectedImage!.path, filename: filename),
        });

        response = await dio.post(
          '/player',
          data: formData
        );
        print('imagen subida');
        // print(response.data['data']);
      }else{
        response = await dio.post(
          '/player',
          data: {
            "email":correo_text,
            "name": nombre_text,
            "ci": ci_text,
            "password": password_text,
            "address": "prueba",
            "telephone": '+591$telefono_text',
            "token_FCM" : token,
          }
        );
      }

      // print('Response register: ${response.data}');
      context.read<UserProvider>().changeUserEmail(newUserEmail: correo_text, newId: response.data['data']['id'], newState: 'authenticated');
      final response2 = await dio.get('/invitations/${correo_text}');
      // print('Response Invitaciones: ${response2.data['data']}');
      
      if(response2.data['data'].length > 0){
        context.go('/invitations');
      }else{
        context.go('/home');
      }
    }on DioException catch (e) {
        if(e.response != null){
          print('data: ${e.response!.data}');
          // setState(() {
          //   erroEmail = e.response!.data['errors']['details'][0]['msg'];
          // });
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
    final token = context.watch<NotificationsBloc>().state.token;
    // print('token: $token');
    return Container(
      // height: MediaQuery.of(context).size.height,
      color: const Color(0xff6AA9E9),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Row(
                children: [
                  
                  SizedBox(
                    width: 20,
                  ),
                  Image(
                    image: AssetImage('assets/Bandera_Bolivia.png'),
                    width: 70,
                    height: 50,
                  ), 
                  SizedBox(
                    width: 40,
                  ),
                  Text(
                    'PASANAKU', 
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontSize: 25
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color(0xFFD9D9D9),
                ),
                child: const Image(
                  image: AssetImage('assets/logo.png'),
                  width: 80,
                  height: 80
                ),
              ),
              const SizedBox(
                height: 30  ,
              ),
          
              const Text(
                'REGISTRATE', 
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  decoration: TextDecoration.none
                ),
              ),
              const SizedBox(
                height: 30,
              ),
          
              Padding(
                padding: const EdgeInsets.fromLTRB(45,0,45,0),
                child: Material(
                  color: const Color(0xff6AA9E9),
                  child: CustomTextFormField(
                      icon: const Icon(Icons.account_circle_rounded, size: 25,),
                      label: 'Nombre',
                      hint: 'Erick Aricari Blanco',
                      // errorMessage: 'Correo invalido',
                      onChanged: (value) {
                        // _formKey.currentState?.validate();
                        nombre_text = value;
                      },
                      validator:  (value) {
                        if(value == null || value.isEmpty || value.trim().isEmpty) return 'Campo requerido';
                        if(value.length < 6) return 'Debe tener mas de 6 caracteres';
                        return null;
                      },
                    )
                ),
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.fromLTRB(45,0,45,0),
                child: Material(
                  color: const Color(0xff6AA9E9),
                  child: CustomTextFormField(
                      icon: const Icon(Icons.email_outlined, size: 25,),
                      label: 'Correo Electronico',
                      hint: 'example@gmail.com',
                      errorMessage: erroEmail == '' ? null: 'Correo ya se encuentra registrado',
                      onChanged: (value) {
                        // _formKey.currentState?.validate();
                        correo_text = value;
                      },
                      validator:  (value) {
                        if(value == null || value.isEmpty || value.trim().isEmpty ) return 'Campo requerido';
                        final emailRegExp = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if(!emailRegExp.hasMatch(value)) return 'No tiene formato de correo';
                        return null;
                      },
                    )
                ),
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.fromLTRB(45,0,45,0),
                child: Material(
                  color: const Color(0xff6AA9E9),
                  child: CustomTextFormField(
                      inputFormat: [FilteringTextInputFormatter.digitsOnly],
                      icon: const Icon(Icons.contact_page, size: 25,),
                      label: 'Carnet de Identidad',  
                      // errorMessage: 'Correo invalido',
                      onChanged: (value) {
                        // _formKey.currentState?.validate();
                        ci_text = value;
                      },
                      validator:  (value) {
                        if(value == null || value.isEmpty || value.trim().isEmpty ) return 'Campo requerido';
                        return null;
                      },
                    )
                ),
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.fromLTRB(45,0,45,0),
                child: Material(
                  color: const Color(0xff6AA9E9),
                  child: CustomTextFormField(
                      inputFormat: [FilteringTextInputFormatter.digitsOnly],
                      icon: const Icon(Icons.phone, size: 25,),
                      label: 'Telefono',  
                      // errorMessage: 'Correo invalido',
                      onChanged: (value) {
                        // _formKey.currentState?.validate();
                        telefono_text = value;
                      },
                      validator:  (value) {
                        if(value == null || value.isEmpty || value.trim().isEmpty ) return 'Campo requerido';
                        return null;
                      },
                    )
                ),
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.fromLTRB(45,0,45,0),
                child: Material(
                  color: const Color(0xff6AA9E9),
                  child: CustomTextFormField(
                      icon: const Icon(Icons.vpn_key_rounded, size: 25,),
                      label: 'Contraseña',
                      // errorMessage: 'Contraseña incorrecta',
                      obscureText: true,
                      onChanged: (value) {
                        // _formKey.currentState?.validate();
                        password_text = value;
                      },
                      validator: (value) {
                        if(value == null || value.isEmpty || value.trim().isEmpty ) return 'Campo requerido';
                        if(value.length < 6) return 'Mas de 6 letras';
                        return null;
                      },
                    )
                ),
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.fromLTRB(45,0,45,0),
                child: Material(
                  color: const Color(0xff6AA9E9),
                  child: CustomTextFormField(
                      icon: const Icon(Icons.vpn_key_rounded, size: 25,),
                      label: 'Repetir Contraseña',
                      // errorMessage: 'Contraseña incorrecta',
                      obscureText: true,
                      onChanged: (value) {
                        // _formKey.currentState?.validate();
                        password2_text = value;
                      },
                      validator: (value) {
                        if(value == null || value.isEmpty || value.trim().isEmpty ) return 'Campo requerido';
                        if(value.length < 6) return 'Mas de 6 letras';
                        if(value != password_text) return 'La contraseña no coinciden';
                        return null;
                      },
                    )
                ),
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '(opcional)', 
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              decoration: TextDecoration.none
                            ),
                          ),
                          const SizedBox(height: 5,),
                          ElevatedButton.icon(
                            onPressed: (){
                              showImageGallery();
                            }, 
                            icon: const Icon(Icons.upload), 
                            label: const Text('Subir QR')
                          ),
                        ],
                      ),
                      const SizedBox(width: 10,),
                      (_selectedImage != null )
                        ? SizedBox(
                            width: 60,
                            height: 60,
                            child: Image.file(_selectedImage!),
                          )
                        : Container()
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 45),
                decoration: BoxDecoration(
                  color: const Color(0xFF318CE7),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                        final isValid = _formKey.currentState!.validate();
                        if(!isValid) return;
                        registerUser(token);
                    },
                    child: const Text(
                      'Registrarme', 
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontSize: 20
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Ya tienes una cuenta?',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      fontSize: 14
                    ),
                  ),
                  const SizedBox(width: 4,),
                  TextButton(onPressed: (){
                    context.go('/login');
                  }, child: const Text('Ingresa ahora'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}