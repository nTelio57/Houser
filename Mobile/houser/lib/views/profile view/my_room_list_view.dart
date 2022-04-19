import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:houser/utils/current_login.dart';
import 'package:houser/models/Room.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/views/profile%20view/my_room_card.dart';
import 'package:houser/views/profile%20view/room_form_view.dart';
import 'package:houser/widgets/WG_snackbars.dart';

class MyRoomListView extends StatefulWidget {
  MyRoomListView({Key? key}) : super(key: key);

  final ApiService _apiService = ApiService();
  final CurrentLogin _currentLogin = CurrentLogin();

  @override
  _MyRoomListViewState createState() => _MyRoomListViewState();
}

class _MyRoomListViewState extends State<MyRoomListView> {

  List<Room> rooms = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: newRoomFab(),
      body: body(),
      appBar: AppBar(),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  Widget newRoomButton()
  {
    return IconButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => RoomFormView())).then((value) => setState((){}));
      },
      icon: const Icon(Icons.add)
    );
  }

  Widget body()
  {
    return Container(
      margin: const EdgeInsets.all(10),
      child: roomLoader(),
    );
  }

  Widget roomLoader()
  {
    return FutureBuilder(
      future: loadRooms().timeout(const Duration(seconds: 5)),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)
      {
        if(snapshot.hasData)
          {
            return roomList();
          }
        else if(snapshot.hasError)
          {
            return SizedBox(
              width: double.infinity,
              child: Text(
                'Įvyko klaida bandant gauti pasiūlymų sąrašą.'.toUpperCase(),
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
            if(rooms.isNotEmpty) {
              return roomList();
            }
            else
              {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
          }
      },
    );
  }

  Future loadRooms() async
  {
    rooms = await widget._apiService.GetRoomsByUser(widget._currentLogin.user!.id);
    return true;
  }

  Widget roomList()
  {
    return RefreshIndicator(
      onRefresh: () async {
        await loadRooms();
        setState(() {

        });
      },
      child: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index)
            {
              return MyRoomCard((){onEditClicked(rooms[index]);}, (){onVisibilityClicked(rooms[index]);}, (){onDeleteClicked(rooms[index]);}, room: rooms[index]);
            }
      ),
    );
  }

  void onEditClicked(Room room)
  {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => RoomFormView(isEditingMode: true, roomToEdit: room))).then((value) => setState((){}));
  }

  void onVisibilityClicked(Room room)
  {
    showDialog(
        context: context,
        builder: (context) => visibilityDialog(room)
    );
  }

  void onDeleteClicked(Room room)
  {
    showDialog(
      context: context,
      builder: (context) => deleteDialog(room)
    );
  }

  AlertDialog deleteDialog(Room room)
  {
    return AlertDialog(
      content: const Text('Ar tikrai norite ištrinti pasiūlymą?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'ATŠAUKTI',
            style: TextStyle(
              fontWeight: FontWeight.w600
            ),
          )
        ),
        TextButton(
            onPressed: () {
              widget._apiService.DeleteRoom(room.id).timeout(const Duration(seconds: 5)).then((value) {
                setState(() {

                });
              });
              Navigator.pop(context);
            },
            child: const Text(
              'IŠTRINTI',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600
              ),
            )
        ),
      ],
    );
  }

  AlertDialog visibilityDialog(Room room)
  {
    return AlertDialog(
      content: const Text('Ar tikrai norite pasiūlymo matomumą?'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'ATŠAUKTI',
              style: TextStyle(
                  fontWeight: FontWeight.w600
              ),)
        ),
        TextButton(
            onPressed: () {
              room.isVisible = !room.isVisible;
              widget._apiService.UpdateOfer(room.id, room).timeout(const Duration(seconds: 5)).then((value) {
                setState(() {

                });
              })
              .catchError(handleSocketException, test: (e) => e is SocketException)
              .catchError(handleTimeoutException, test: (e) => e is TimeoutException)
              .catchError(handleVisibilityException, test: (e) => e is Exception);

              Navigator.pop(context);
            },
            child: const Text(
              'TĘSTI',
              style: TextStyle(
                  fontWeight: FontWeight.w600
              ),)
        ),
      ],
    );
  }

  Widget newRoomFab()
  {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColorDark,
      child: const Icon(Icons.add),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => RoomFormView())).then((value) => setState((){}));
      },
    );
  }

  void handleSocketException(Object o){
    ScaffoldMessenger.of(context).showSnackBar(noConnectionSnackbar);
  }

  void handleTimeoutException(Object o){
    ScaffoldMessenger.of(context).showSnackBar(noConnectionSnackbar);
  }

  void handleVisibilityException(Object o){
    ScaffoldMessenger.of(context).showSnackBar(visibilityChangeFailed);
  }
}
