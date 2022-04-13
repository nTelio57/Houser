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
      if(value == null) {
        return;
      }
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

  Future<Offer?> loadSingleOffer() async{
    var offer = await _apiService.GetRecommendationByFilter();
    if(offer == null) {
      return null;
    }
    _currentLogin.recommendedOffers.add(offer);
    return offer;
  }

  Future loadOffers() async
  {
    if(_currentLogin.recommendedOffers.isEmpty)
    {
      for(int i = 0; i < 5; i++)
        {
          var offer = await _apiService.GetRecommendationByFilter();
          if(offer != null) {
            _currentLogin.recommendedOffers.add(offer);
          }
        }
      return true;
    }
    else{
      var offer = await _apiService.GetRecommendationByFilter();
      if(offer != null) {
        _currentLogin.recommendedOffers.add(offer);
      }
      return true;
    }
  }
}