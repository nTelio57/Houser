import 'package:houser/models/Filter.dart';

abstract class IOfferManager{
  void loadOffersSync(int count, int offset, Filter filter);
  Future loadOffersAsync(int count, int offset, Filter filter);
  Future loadSingleOffer(int offset);
}