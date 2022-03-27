import 'package:houser/enums/BedType.dart';

class Offer{
  bool isActive = true;
  bool isVisible = true;
  DateTime uploadDate = DateTime.now();

  String title = 'Ieškomas vienas kambariokas dviem mėnesiams';
  String city = 'Kaunas';
  String address = 'Studentų g. 50 ';

  double monthlyPrice  = 100;
  bool utilityBillsRequired = true;

  DateTime availableFrom = DateTime.now();
  DateTime availableTo = DateTime.now().add(const Duration(days: 90));
  int freeRoomCount = 1;
  int totalRoomCount = 3;

  bool ruleSmoking = true;
  bool ruleAnimals = true;

  int bedCount = 1;
  BedType bedType = BedType.single;

  bool accommodationTV = true;
  bool accommodationWIFI = true;
  bool accommodationAC = true;

  Offer({required this.title, required this.uploadDate, required this.address, required this.city, required this.freeRoomCount, required this.totalRoomCount, required this.isActive, required this.isVisible});

  Offer.placeholder(this.isVisible);

}