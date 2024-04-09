import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pasanaku_app/widgets/custom_text_form_field.dart';

class RegisterPage extends StatelessWidget {
  static const name = 'register-screen';
  RegisterPage({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String nombre_text = '';
  String telefono_text = '';
  String ci_text = '';
  String correo_text = '';
  String password_text = '';
  String password2_text = '';

  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3001/api',
    )
  );

  Future<void> registerUser() async{
    try {
      final response = await Dio().post(
        '/player',
        data: {
          "email":correo_text,
          "name": nombre_text,
          "ci": ci_text,
          "password": password_text,
          "telephone": telefono_text,
        }
      );

      print(response.data);
    } catch (e) {
      print(e);
    }

    
    

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff6AA9E9),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                      decoration: TextDecoration.none
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
                      icon: const Icon(Icons.email_outlined, size: 25,),
                      label: 'Correo Electronico',
                      hint: 'example@gmail.com',
                      // errorMessage: 'Correo invalido',
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
                        return null;
                      },
                    )
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
                        registerUser();
                        context.push('/home');
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
              const SizedBox(height: 100,),
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
                    context.push('/login');
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