import 'package:flutter/material.dart';
import 'package:pasanaku_app/domain/entities/push_message.dart';
import 'package:pasanaku_app/services/bloc/notifications_bloc.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatelessWidget {
  final String pushMessageId;
  const DetailsPage({super.key, required this.pushMessageId});

  @override
  Widget build(BuildContext context) {
    final PushMessage? message = context.watch<NotificationsBloc>().getMessageById(pushMessageId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('detalles push'),
      ),
      body: (message != null)  
        ? _DetailsView(message: message,)
        : const Center(child: Text('Notificacion no existe'),)
    );
  }
}

class _DetailsView extends StatelessWidget {
  final PushMessage message;
  const _DetailsView({required this.message});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          if(message.imageUrl != null)
            Image.network(message.imageUrl!),
          const SizedBox(height: 30,),
          Text(message.title, style: textStyle.titleMedium,),
          Text(message.body),
          const Divider(),
          Text(message.data.toString())
        ],
      ),
    );
  }
}