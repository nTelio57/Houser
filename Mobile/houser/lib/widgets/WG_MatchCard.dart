import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:houser/enums/FilterType.dart';
import 'package:houser/models/Match.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/utils/current_login.dart';
import 'package:houser/views/match%20view/match_chat_view.dart';

// ignore: must_be_immutable
class WGMatchCard extends StatefulWidget {
  final ApiService _apiService = ApiService();
  final CurrentLogin _currentLogin = CurrentLogin();

  Match match;

  WGMatchCard(this.match, {Key? key}) : super(key: key);

  @override
  _WGMatchCardState createState() => _WGMatchCardState();
}

class _WGMatchCardState extends State<WGMatchCard> {
  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body()
  {
    return Container(
      height: 100,
      color: Colors.transparent,
      child: Card(
         child: InkWell(
           onTap: () {onCardTap();},
           child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisSize: MainAxisSize.min,
               children: [
                 image(),
                 titleAndMessage()
               ],
             ),
           ),
         ),
      ),
    );
  }

  void onCardTap()
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MatchChatView(widget.match)));
  }

  Widget image()
  {
    var imageId = getImageId();
    return CircleAvatar(
      radius: 40,
      backgroundColor: Theme.of(context).primaryColorDark,
      foregroundImage: networkImage(imageId),
      child: initialsText(),
    );
  }

  Widget titleAndMessage()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        title(),
        lastMessage(),
      ],
    );
  }

  Widget lastMessage()
  {
    var messages = widget.match.messages;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        width: 220,
        child: AutoSizeText(
          messages.isNotEmpty ? messages[messages.length-1].content : 'Parašykite žinutę pirmas!',
          maxLines: 2,
          style: const TextStyle(
              fontSize: 16
          ),
        ),
      ),
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
    switch(widget.match.filterType)
    {
      case FilterType.user:
        var otherUser = widget.match.getOtherUser(widget._currentLogin.user!.id);
        return otherUser.name![0];
      case FilterType.room:
        return widget.match.room!.title[0];
    }
    return '';
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

  Widget title()
  {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        getTitle(),
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black
        ),
      ),
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
}
