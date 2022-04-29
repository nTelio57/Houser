import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:houser/enums/FilterType.dart';
import 'package:houser/models/Message.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/services/messenger_service.dart';
import 'package:houser/utils/current_login.dart';
import 'package:houser/models/Match.dart';
import 'package:houser/views/profile%20view/guest_profile_view.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MatchChatView extends StatefulWidget {
  MatchChatView(this.match, {Key? key}) : super(key: key);

  final CurrentLogin _currentLogin = CurrentLogin();
  final ApiService _apiService = ApiService();
  Match match;

  @override
  _MatchChatViewState createState() => _MatchChatViewState();
}

class _MatchChatViewState extends State<MatchChatView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: appBarButton(),
      ),
      body: body(),
    );
  }

  Widget body()
  {
    return Stack(
      children: [
        messageListView(),
        bottomPanel()
      ],
    );
  }

  Widget appBarTitle()
  {
    return Container(
      constraints: const BoxConstraints(maxWidth: 250),
      child: Row(
        children: [
          image(),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              getTitle(),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget appBarButton()
  {
    return TextButton(
      onPressed: ()
        {
          onAppBarTitleClick();
        },
      child: appBarTitle(),
    );
  }

  Future onAppBarTitleClick() async{
    var otherUser = widget.match.getOtherUser(widget._currentLogin.user!.id);
    if(widget.match.roomOfferer.id == otherUser.id)
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => GuestProfileView(FilterType.room, room: widget.match.room!)));
      }
    else
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => GuestProfileView(FilterType.user, user: otherUser)));
      }
  }

  Widget image()
  {
    var imageId = getImageId();
    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColorDark,
      foregroundImage: imageId == 0 ? null : networkImage(imageId),
      child: initialsText(),
    );
  }

  int getImageId()
  {
    var otherUser = widget.match.getOtherUser(widget._currentLogin.user!.id);
    if(widget.match.roomOfferer.id == otherUser.id)
    {
      return widget.match.room!.getMainImage()!.id;
    }
    var otherUsersMainImage = otherUser.getMainImage();
    if(otherUsersMainImage != null) {
      return otherUsersMainImage.id;
    }
    return 0;
  }

  Widget initialsText()
  {
    return Text(
      getInitials(),
      style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600
      ),
    );
  }

  String getInitials()
  {
    var otherUser = widget.match.getOtherUser(widget._currentLogin.user!.id);
    if(widget.match.roomOfferer.id == otherUser.id)
    {
      return widget.match.room!.title[0];
    }
    return otherUser.name![0];
  }

  CachedNetworkImageProvider networkImage(int id)
  {
    return CachedNetworkImageProvider(
      'https://${widget._apiService.apiUrl}/api/Image/$id',
      headers: {
        'Authorization': 'bearer ' + widget._currentLogin.jwtToken,
      },
    );
  }

  String getTitle()
  {
    var otherUser = widget.match.getOtherUser(widget._currentLogin.user!.id);
    if(widget.match.roomOfferer.id == otherUser.id)
    {
      return widget.match.room!.title;
    }
    return otherUser.name!;
  }

  Widget messageLoader()
  {
    return FutureBuilder(
      future: loadMessages().timeout(const Duration(seconds: 5)),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)
      {
        if(snapshot.hasData)
        {
          return messageListView();
        }
        else if(snapshot.hasError)
        {
          return SizedBox(
            width: double.infinity,
            child: Text(
              'Įvyko klaida bandant gauti žinutes.'.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.red
              ),
            ),
          );
        }
        else
        {
          if(widget.match.messages.isNotEmpty) {
            return messageListView();
          }
          else
          {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      }
    );
  }

  Future loadMessages() async
  {
    var provider = Provider.of<MessengerService>(context, listen: false);
    var messages = await widget._apiService.GetMessagesByMatch(widget.match.id);
    widget.match.messages = messages;
    provider.matchList.firstWhere((x) => x.id == widget.match.id).messages = messages;
  }

  Widget messageListView()
  {
    var provider = Provider.of<MessengerService>(context, listen: true);
    var messages = provider.matchList.firstWhere((x) => x.id == widget.match.id).messages.reversed.toList();
    var userId = widget._currentLogin.user!.id;

    return RefreshIndicator(
      onRefresh: () async {
        await loadMessages();
        setState(() {

        });
      },
      child: ListView.builder(
        itemCount: messages.length,
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 70),
        reverse: true,
        itemBuilder: (context, index)
        {
          return messages[index].senderId == userId ? myBubble(messages[index].content) : otherBubble(messages[index].content);
        }
      ),
    );
  }

  Widget myBubble(String text)
  {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).primaryColor
        ),
        constraints: const BoxConstraints(maxWidth: 250),
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 6),

        child: Text(
          text,
          textAlign: TextAlign.right,
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
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[400]
        ),
        constraints: const BoxConstraints(maxWidth: 250),
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
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Row(
          children: [
            inputFieldContainer(),
            enterButton()
          ],
        ),
      ),
    );
  }

  Widget inputFieldContainer()
  {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 8, bottom: 8, top: 8),
        constraints: const BoxConstraints(minHeight: 40),
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
        contentPadding: EdgeInsets.only(left: 12, right: 8, top: 8, bottom: 4),
      ),
    );
  }

  Widget enterButton()
  {
    return Container(
      margin: const EdgeInsets.only(bottom: 8, top: 8, left: 10, right: 10),
      child: Material(
        type: MaterialType.transparency,
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        child: IconButton(
          iconSize: 26,
          icon: const Icon(
            Icons.send,
            color: Colors.white,
          ),
          onPressed: (){
            onSendPressed();
          },
        ),
      ),
    );
  }

  Future onSendPressed() async
  {
    if(_messageInputController.text.isEmpty) {
      return;
    }

    Message newMessage = Message(0, widget._currentLogin.user!.id, widget.match.id, null, _messageInputController.text);
    _messageInputController.text = '';
    var provider = Provider.of<MessengerService>(context, listen: false);
    await provider.sendMessage(newMessage);
  }
}
