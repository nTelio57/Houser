import 'package:flutter/material.dart';
import 'package:houser/services/messenger_service.dart';
import 'package:houser/utils/current_login.dart';

class MatchChatView extends StatefulWidget {
  MatchChatView({Key? key}) : super(key: key);

  final MessengerService _messengerService = MessengerService();
  final CurrentLogin _currentLogin = CurrentLogin();

  @override
  _MatchChatViewState createState() => _MatchChatViewState();
}

class _MatchChatViewState extends State<MatchChatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(),
      body: body(),
    );
  }

  Widget body()
  {
    return Stack(
      children: [
        messageList(),
        bottomPanel()
      ],
    );
  }

  Widget messageList()
  {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          myBubble('Labas ka tu?'),
          otherBubble('Nezinau siaip va'),
          myBubble('O tu ka gero?'),
          otherBubble('Joo  geras sitas'),
        ],
      ),
    );
  }

  Widget myBubble(String text)
  {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).primaryColor
        ),
        constraints: const BoxConstraints(minWidth: 100, maxWidth: 250),
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 6),

        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white
          ),
        ),
      ),
    );
  }

  Widget otherBubble(String text)
  {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[400]
        ),
        constraints: const BoxConstraints(minWidth: 100, maxWidth: 250),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black
          ),
        ),
      ),
    );
  }

  Widget bottomPanel()
  {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          inputFieldContainer(),
          enterButton()
        ],
      ),
    );
  }

  Widget inputFieldContainer()
  {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 8, bottom: 8, top: 8),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: inputField(),
      ),
    );
  }

  final TextEditingController _messageInputController = TextEditingController();

  Widget inputField()
  {
    return TextField(
      maxLines: 3,
      minLines: 1,
      keyboardType: TextInputType.multiline,
      controller: _messageInputController,
      decoration: const InputDecoration(
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      ),
    );
  }

  Widget enterButton()
  {
    return Container(
      margin: const EdgeInsets.only(bottom: 8, top: 8),
      child: IconButton(
        iconSize: 26,
        splashRadius: 24,
        color: Theme.of(context).primaryColor,
        icon: const Icon(Icons.send),
        onPressed: (){
          onSendPressed();
        },
      ),
    );
  }

  Future onSendPressed() async
  {
    await widget._messengerService.sendMessage(widget._currentLogin.user!.id, 'Yooo');
  }
}
