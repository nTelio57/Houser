import 'package:houser/models/RoomFilter.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/services/offer%20manager/IOfferManager.dart';
import 'package:houser/services/current_login.dart';
import 'package:houser/services/offer%20manager/offer_card_manager.dart';

class RoomOfferManager implements IOfferManager
{
  final ApiService _apiService = ApiService();
  OfferCardManager offerCardManager;

  RoomOfferManager(this.offerCardManager);

  @override
  Future loadOffersAsync(int count, int offset) async{
    var roomList = await _apiService.GetRoomRecommendationByFilter(count, offset, CurrentLogin().user!.filter as RoomFilter);
    offerCardManager.rooms.addAll(roomList.where((newRoom) => !offerCardManager.rooms.contains(newRoom)));
  }
}