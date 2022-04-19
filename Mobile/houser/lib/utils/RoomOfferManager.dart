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
  Future loadOffersAsync(int count, int offset) async{
    var roomList = await _apiService.GetRoomRecommendationByFilter(count, offset, _currentLogin.user!.filter as RoomFilter);
    offerCardManager.rooms.addAll(roomList.where((newRoom) => !offerCardManager.rooms.contains(newRoom)));
  }
}