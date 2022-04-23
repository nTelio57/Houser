import 'package:flutter/material.dart';
import 'package:houser/enums/SwipeType.dart';
import 'package:houser/enums/FilterType.dart';
import 'package:houser/models/Swipe.dart';
import 'package:houser/models/User.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/utils/RoomOfferManager.dart';
import 'package:houser/utils/UserOfferManager.dart';
import 'package:houser/utils/current_login.dart';
import 'package:houser/models/Room.dart';

class OfferCardManager extends ChangeNotifier {
  final CurrentLogin _currentLogin = CurrentLogin();
  final ApiService _apiService = ApiService();

  late RoomOfferManager _roomOfferManager;
  late UserOfferManager _userOfferManager;

  List<Room> rooms = [];
  List<User> users = [];
  Offset position = Offset.zero;
  Size screenSize = Size.zero;
  bool isDragging = false;
  double angle = 0;
  double maxRotationAngle = 25;

  OfferCardManager(){
    _roomOfferManager = RoomOfferManager(this);
    _userOfferManager = UserOfferManager(this);
    resetOffers();
    loadOffersSync(3, 0);
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
      case SwipeType.like:
        like();
        break;
      case SwipeType.dislike:
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

  SwipeType? getStatus()
  {
    final x = position.dx;
    const threshold = 100;

    if(x >= threshold) {
      return SwipeType.like;
    }else if(x <= -threshold){
      return SwipeType.dislike;
    }
  }

  Swipe getSwipeData(SwipeType swipeType)
  {
    var filterType = _currentLogin.user!.filter!.filterType;
    var swiperId = _currentLogin.user!.id;
    var userTargetId = filterType == FilterType.user ? users[0].id : rooms[0].userId;
    var roomId = filterType == FilterType.room ? rooms[0].id : null;

    return Swipe(0, swipeType, filterType, swiperId, userTargetId, roomId);
  }

  void like()
  {
    angle = 20;
    position += Offset(2 * screenSize.width, 0);

    postSwipe(getSwipeData(SwipeType.like));
    nextCard().then((value) => notifyListeners());
    addSingleOffer();

    notifyListeners();
  }

  void dislike()
  {
    angle = -20;
    position -= Offset(2 * screenSize.width, 0);

    postSwipe(getSwipeData(SwipeType.dislike));
    nextCard().then((value) => notifyListeners());
    addSingleOffer();

    notifyListeners();
  }

  Future postSwipe(Swipe swipe) async
  {
    await _apiService.PostSwipe(swipe);
  }

  Future nextCard() async {
    if(rooms.isEmpty && users.isEmpty) return;

    await Future.delayed(const Duration(milliseconds: 200));

    switch(_currentLogin.user!.filter!.filterType){
      case FilterType.room:
        rooms.removeAt(0);
        break;
      case FilterType.user:
        users.removeAt(0);
        break;
      case FilterType.none:
        return;
    }

    resetPosition();
  }

  void addSingleOffer(){
    loadSingleOffer();
  }

  void resetOffers()
  {
    rooms = [];
    users = [];
    notifyListeners();
  }

  Future loadSingleOffer() async{
    switch(_currentLogin.user!.filter!.filterType){
      case FilterType.room:
        _roomOfferManager.loadOffersAsync(1, rooms.length);
        break;
      case FilterType.user:
        _userOfferManager.loadOffersAsync(1, rooms.length);
        break;
      case FilterType.none:
        return;
    }
  }

  Future loadOffersAsync(int count, int offset) async{
    switch(_currentLogin.user!.filter!.filterType){
      case FilterType.room:
        await _roomOfferManager.loadOffersAsync(count, offset);
        break;
      case FilterType.user:
        await _userOfferManager.loadOffersAsync(count, offset);
        break;
      case FilterType.none:
        return;
    }
    notifyListeners();
  }

  void loadOffersSync(int count, int offset){
    switch(_currentLogin.user!.filter!.filterType){
      case FilterType.room:
        _roomOfferManager.loadOffersAsync(count, offset).then((value) {
          notifyListeners();
        });
        break;
      case FilterType.user:
        _userOfferManager.loadOffersAsync(count, offset).then((value) {
          notifyListeners();
        });
        break;
      case FilterType.none:
        return;
    }
  }
}