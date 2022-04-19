import 'package:flutter/material.dart';
import 'package:houser/enums/CardResponseType.dart';
import 'package:houser/enums/FilterType.dart';
import 'package:houser/models/Filter.dart';
import 'package:houser/utils/RoomOfferManager.dart';
import 'package:houser/utils/current_login.dart';
import 'package:houser/models/Room.dart';

class OfferCardManager extends ChangeNotifier {
  final CurrentLogin _currentLogin = CurrentLogin();

  late RoomOfferManager _roomRoomManager;

  List<Room> rooms = [];
  Offset position = Offset.zero;
  Size screenSize = Size.zero;
  bool isDragging = false;
  double angle = 0;
  double maxRotationAngle = 25;

  OfferCardManager(){
    _roomRoomManager = RoomOfferManager(this);
    resetRooms();
    loadRoomsSync(3, 0, _currentLogin.user!.filter!);
  }

  void startPosition(DragStartDetails details)
  {
    isDragging = true;
  }

  void updatePosition(DragUpdateDetails details)
  {
    position += details.delta;
    final x = position.dx;
    angle = maxRotationAngle * x / screenSize.width;

    notifyListeners();
  }

  void endPosition()
  {
    isDragging = false;
    notifyListeners();

    final status = getStatus();

    switch(status)
    {
      case CardResponseType.like:
        like();
        break;
      case CardResponseType.dislike:
        dislike();
        break;
      default:
        resetPosition();
    }
  }

  void resetPosition()
  {
    isDragging = false;
    position = Offset.zero;
    angle = 0;

    notifyListeners();
  }

  CardResponseType? getStatus()
  {
    final x = position.dx;
    const threshold = 100;

    if(x >= threshold) {
      return CardResponseType.like;
    }else if(x <= -threshold){
      return CardResponseType.dislike;
    }
  }

  void like()
  {
    angle = 20;
    position += Offset(2 * screenSize.width, 0);
    nextCard().then((value) => notifyListeners());
    addSingleRoom();

    notifyListeners();
  }

  void dislike()
  {
    angle = -20;
    position -= Offset(2 * screenSize.width, 0);
    nextCard().then((value) => notifyListeners());
    addSingleRoom();

    notifyListeners();
  }

  Future nextCard() async {
    if(CurrentLogin().recommendedRooms.isEmpty) return;

    await Future.delayed(const Duration(milliseconds: 200));
    rooms.removeAt(0);
    resetPosition();
  }

  void addSingleRoom(){
    loadSingleRoom();
  }

  void resetRooms()
  {
    _currentLogin.recommendedRooms = [];
    rooms = _currentLogin.recommendedRooms;
    notifyListeners();
  }

  Future loadSingleRoom() async{
    if(_currentLogin.user!.filter!.filterType == FilterType.room) {
      _roomRoomManager.loadSingleOffer(rooms.length);
    }
    return;
  }

  Future loadRoomsAsync(int count, int offset, Filter filter) async{
    if(_currentLogin.user!.filter!.filterType == FilterType.room) {
      await _roomRoomManager.loadOffersAsync(count, offset, filter);
      notifyListeners();
    }
    return;
  }

  void loadRoomsSync(int count, int offset, Filter filter){
    if(_currentLogin.user!.filter!.filterType == FilterType.room) {
      _roomRoomManager.loadOffersAsync(count, offset, filter).then((value) {
        notifyListeners();
      });
    }
    return;
  }

  void deleteRange(int start)
  {
    _currentLogin.recommendedRooms.removeRange(start, _currentLogin.recommendedRooms.length-1);
    rooms = _currentLogin.recommendedRooms;
    notifyListeners();
  }
}