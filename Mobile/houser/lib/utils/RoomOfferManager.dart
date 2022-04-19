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
  OfferCardManager roomCardManager;

  RoomOfferManager(this.roomCardManager);

  @override
  Future loadOffersAsync(int count, int offset, Filter filter) async{
    var roomList = await _apiService.GetRoomRecommendationByFilter(count, offset, filter as RoomFilter);
    roomCardManager.rooms.addAll(roomList.where((newRoom) => !roomCardManager.rooms.contains(newRoom)));
  }

  @override
  void loadOffersSync(int count, int offset, Filter filter) {
    _apiService.GetRoomRecommendationByFilter(count, offset, filter as RoomFilter).then((roomList) {
      roomCardManager.rooms.addAll(roomList.where((newRoom) => !roomCardManager.rooms.contains(newRoom)));
    });
  }

  @override
  Future loadSingleOffer(int offset) async{
    _apiService.GetRoomRecommendationByFilter(1, offset, _currentLogin.user!.filter as RoomFilter).then((roomList) {
      if(roomList.isEmpty) {
        return;
      }
      _currentLogin.recommendedRooms.add(roomList[0]);
      roomCardManager.rooms.add(roomList[0]);
    });
  }
}