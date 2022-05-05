import 'package:houser/models/UserFilter.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/services/offer%20manager/IOfferManager.dart';
import 'package:houser/services/current_login.dart';
import 'package:houser/services/offer%20manager/offer_card_manager.dart';

class UserOfferManager implements IOfferManager
{
  final ApiService _apiService = ApiService();
  OfferCardManager offerCardManager;

  UserOfferManager(this.offerCardManager);

  @override
  Future loadOffersAsync(int count, int offset) async{
    var roomList = await _apiService.GetUserRecommendationByFilter(count, offset, CurrentLogin().user!.filter as UserFilter);
    offerCardManager.users.addAll(roomList.where((newUser) => !offerCardManager.users.contains(newUser)));
  }
}