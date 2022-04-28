import 'package:flutter/material.dart';
import 'package:houser/enums/FilterType.dart';
import 'package:houser/models/Room.dart';
import 'package:houser/models/User.dart';
import 'package:houser/widgets/WG_RoomCard.dart';
import 'package:houser/widgets/WG_UserCard.dart';

// ignore: must_be_immutable
class GuestProfileView extends StatefulWidget {

  GuestProfileView(this.filterType, {Key? key, this.room, this.user}) : super(key: key);
  FilterType filterType;
  Room? room;
  User? user;

  @override
  _GuestProfileViewState createState() => _GuestProfileViewState();
}

class _GuestProfileViewState extends State<GuestProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: body(),
    );
  }

  Widget body()
  {
    if(widget.filterType == FilterType.user)
      {
        return WGUserCard(user: widget.user!, isFront: false);
      }
    else
      {
        return WGRoomCard(room: widget.room!, isFront: false);
      }
  }
}
