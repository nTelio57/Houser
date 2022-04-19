import 'package:houser/models/Filter.dart';
import 'package:houser/models/RoomFilter.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/utils/IOfferManager.dart';
import 'package:houser/utils/current_login.dart';
import 'package:houser/utils/offer_card_manager.dart';

class RoomOfferManager implements IOfferManager
{
  final CurrentLogin _currentLogin = CurrentLogin();
  final ApiService _apiService = ApiService();
  OfferCardManager offerCardManager;

  RoomOfferManager(this.offerCardManager);

  @override
  Future loadOffersAsync(int count, int offset, Filter filter) async{
    var offerList = await _apiService.GetRoomRecommendationByFilter(count, offset, filter as RoomFilter);
    offerCardManager.offers.addAll(offerList.where((newOffer) => !offerCardManager.offers.contains(newOffer)));
  }

  @override
  void loadOffersSync(int count, int offset, Filter filter) {
    _apiService.GetRoomRecommendationByFilter(count, offset, filter as RoomFilter).then((offerList) {
      offerCardManager.offers.addAll(offerList.where((newOffer) => !offerCardManager.offers.contains(newOffer)));
    });
  }

  @override
  Future loadSingleOffer(int offset) async{
    _apiService.GetRoomRecommendationByFilter(1, offset, _currentLogin.user!.filter as RoomFilter).then((offerList) {
      if(offerList.isEmpty) {
        return;
      }
      _currentLogin.recommendedOffers.add(offerList[0]);
      offerCardManager.offers.add(offerList[0]);
    });
  }
}