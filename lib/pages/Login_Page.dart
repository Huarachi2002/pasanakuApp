import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pasanaku_app/api/apiServicio.dart';
import 'package:pasanaku_app/providers/previuosRoute_provider.dart';
import 'package:pasanaku_app/providers/user_provider.dart';
import 'package:pasanaku_app/services/bloc/notifications_bloc.dart';
import 'package:pasanaku_app/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatefulWidget {
  static const name = 'login-screen';
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  String correo_text = '';
  String errorMessage = '';
  String errorPassword = '';
  String password_text = '';

  Future<void> loginUser(String token) async{
    try {
      final response = await dio.post(
        '/auth/login',
        data: { 
          'email': correo_text,
          'password': password_text,
        },
      );
      await dio.put(
        '/player/${response.data['data']['id']}/token',
        data: {
          'token_FCM': token
        }
      );
      // print(response.statusCode);
      context.read<UserProvider>().changeUserEmail(newUserEmail: correo_text, newId: response.data['data']['id'], newState: 'authenticated');

      final response3 = await dio.get('/invitations/$correo_text');      
      final routePrevious = Provider.of<PreviousRouteProvider>(context, listen: false).route;
      // print('route: $routePrevious');
      if(routePrevious != ''){ 
        context.go(routePrevious);
      }else{
        if(response3.data['data'].length > 0){
          context.go('/invitations');
        }else{
          context.go('/home');
        }
      }
      

    }on DioException catch (e) {
        if(e.response != null){
          // print('data: ${e.response!.data}');
          // print('headers: ${e.response!.headers}');
          // print('requestOptions: ${e.response!.requestOptions}');
          setState(() {
            if(e.response!.data['meta']['message'] == 'Datos incorrectos'){
              errorMessage = e.response!.data['errors']['details'][0];
            }else{
              errorPassword = 'Contraseña incorrecta';
            }
          });
          // print('Message: ${e.response!.data['errors']['details'][0]["msg"]}');
        }
    } 
    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<NotificationsBloc>().state;
    // print('status: ${bloc.status}');
    // print('token: ${bloc.token}');
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Image(
                      image: AssetImage('assets/Bandera_Bolivia.png'),
                      width: 70,
                      height: 50,
                    ), 
                    const Text(
                      'PASANAKU', 
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontSize: 30
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        context.read<NotificationsBloc>().requestPermission();
                      }, 
                      icon: const Icon(Icons.settings)
                    )
                  ],
                ),
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
                'INICIAR SESIÓN', 
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
                  child: 
                  CustomTextFormField(
                    icon: const Icon(Icons.email_outlined, size: 25,),
                    label: 'Correo Electronico',
                    hint: 'example@gmail.com',
                    errorMessage: errorMessage == '' ? null : errorMessage,
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
              const SizedBox(height: 30,),
          
              Padding(
                padding: const EdgeInsets.fromLTRB(45,0,45,0),
                child: Material(
                  color: const Color(0xff6AA9E9),
                  child: CustomTextFormField(
                    icon: const Icon(Icons.vpn_key_rounded, size: 25,),
                    label: 'Contraseña',
                    errorMessage: errorPassword == '' ? null : errorPassword,
                    obscureText: true,
                    onChanged: (value) {
                      // _formKey.currentState?.validate();
                      password_text = value;
                    },
                    validator: (value) {
                      if(value == null || value.isEmpty || value.trim().isEmpty ) return 'Campo requerido';
                      // if(value.length < 6) return 'Mas de 6 letras';
                      return null;
                    },
                  )
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: (){
                      Link('');
                    }, 
                    child: const Text(
                      'Olvide mi contraseña',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black
                      ),
                    )
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final isValid = _formKey.currentState!.validate();
                      if(!isValid) return;
                      loginUser(bloc.token);
                      // print('Error: ${errorMessage}');
                    }, 
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(Color(0xFF318CE7)),
                    ),
                    child: const Text(
                      'Ingresar',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    )
                  ),
                  SizedBox(width: MediaQuery.of(context).size.height * 0.1,),
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(Colors.grey),
                    ),
                    onPressed:(){
                      context.go('/register');
                    }, 
                    child: const Text(
                      'Registrar',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    )
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
              const Text(
                'Al continuar, declaras tu conformidad con nuestras',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  decoration: TextDecoration.none
                ),  
              ),
              TextButton(onPressed: (){
                Link('');
              }, child: const Text('condiciones de uso')),
              const Text(
                'y confirmas que has leido nuestras',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  decoration: TextDecoration.none
                ),
              ),
              TextButton(onPressed: (){
                Link('');
              }, child: const Text('Declaración de privacidad y cookies.'))
            ],
          ),
        ),
      ),
    );
  }
}