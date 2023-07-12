import 'package:chat_app_theozu/widgets/chat/message_bubble_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({super.key});

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data!.docs;
        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (context, index) {
            return MessageBubbleWidget(
              message: (chatDocs[index].data()! as Map)['text'],
              userName: (chatDocs[index].data()! as Map)['username'],
              userImage: (chatDocs[index].data()! as Map)['userImage'],
              isMe: (chatDocs[index].data()! as Map)['userId'] == user!.uid,
            );
          },
        );
      },
    );
  }
}
