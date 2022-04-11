import 'package:flutter/material.dart';
import 'package:houser/enums/CardResponseType.dart';
import 'package:houser/utils/current_login.dart';
import 'package:houser/models/Offer.dart';
import 'package:houser/services/api_service.dart';

class OfferCardManager extends ChangeNotifier {
  final CurrentLogin _currentLogin = CurrentLogin();
  final ApiService _apiService = ApiService();

  List<Offer> offers = [];
  Offset position = Offset.zero;
  Size screenSize = Size.zero;
  bool isDragging = false;
  double angle = 0;
  double maxRotationAngle = 25;

  OfferCardManager(){
    resetOffers();
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

    if(x >= threshold)
      {
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
    addSingleOffer();

    notifyListeners();
  }

  void dislike()
  {
    angle = -20;
    position -= Offset(2 * screenSize.width, 0);
    nextCard().then((value) => notifyListeners());
    addSingleOffer();

    notifyListeners();
  }

  Future nextCard() async {
    if(CurrentLogin().recommendedOffers.isEmpty) return;

    await Future.delayed(const Duration(milliseconds: 200));
    offers.removeAt(0);
    resetPosition();
  }

  void addSingleOffer(){
    loadSingleOffer().then((value) {
      _currentLogin.recommendedOffers.add(value);
      offers.add(value);
    });
  }

  void resetOffers()
  {
    loadOffers().then((value) {
      offers = _currentLogin.recommendedOffers;
      notifyListeners();
    });
  }

  Future<Offer> loadSingleOffer() async{
    var offer = await _apiService.GetOfferById(7);
    _currentLogin.recommendedOffers.add(offer);
    return offer;
  }

  Future loadOffers() async
  {
    if(_currentLogin.recommendedOffers.isEmpty)
    {
      var a = await _apiService.GetOfferById(1);
      var b = await _apiService.GetOfferById(2);
      var c = await _apiService.GetOfferById(3);
      var d = await _apiService.GetOfferById(5);
      var e = await _apiService.GetOfferById(7);
      _currentLogin.recommendedOffers.addAll([a, b, c, d, e]);
      return true;
    }
    else{
      var a = await _apiService.GetOfferById(7);
      _currentLogin.recommendedOffers.add(a);
      return true;
    }
  }
}