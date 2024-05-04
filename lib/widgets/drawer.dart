import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pasanaku_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(context),
            buildMenuItems(context)
          ],
        ),
      ),
    );
  }
}

Widget buildHeader(BuildContext context)  {
  final user = Provider.of<UserProvider>(context, listen: false);
  return Container(
  color: Colors.blue.shade700,
  padding: EdgeInsets.only(top:MediaQuery.of(context).padding.top, bottom: 10),
  child: Column(
    children: [
      const CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage('assets/User_Icon.png')
      ),
      const SizedBox(height: 12,),
      Text(
        user.userEmail,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
          fontSize: 20
        ),
      ),
    ],
   ),
  );
}


Widget buildMenuItems(BuildContext context) => Container(
  padding: const EdgeInsets.all(24),
  child: Wrap(
    runSpacing: 16,
    children: [
      ListTile(
        leading: const Icon(Icons.person),
        title: const Text('Actualizar datos personales'),
        onTap: (){},
      ),
      const Divider(),
      ListTile(
        leading: const Icon(Icons.qr_code_2),
        title: const Text('Actualizar QR'),
        onTap: (){
          context.pop();
          context.push('/qr-update');
        },
      ),
      ListTile(
        leading: const Icon(Icons.qr_code_scanner_outlined),
        title: const Text('Escanear QR'),
        onTap: (){
          context.pop();
          context.push('/qr-scan');
        },
      ),
      const Divider(),
      ListTile(
        leading: const Icon(Icons.build),
        title: const Text('Configuraciones'),
        onTap: (){
          context.pop();
          context.push('/downloader');
        },
      ),
      const Divider(),
      ListTile(
        leading: const Icon(Icons.business),
        title: const Text('Nosotros'),
        onTap: (){},
      ),
      ListTile(
        leading: const Icon(Icons.quick_contacts_mail_outlined),
        title: const Text('Contactanos'),
        onTap: (){},
      ),
    ],
  ),
);