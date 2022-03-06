class Offer{
  bool isActive = true;
  bool isVisible = true;

  String title = 'Ieškomas vienas kambariokas dviem mėnesiams';
  DateTime uploadDate = DateTime.now();
  String address = 'Studentų g. 50 ';
  String city = 'Kaunas';
  int freeRoomCount = 1;
  int totalRoomCount = 3;

  Offer({required this.title, required this.uploadDate, required this.address, required this.city, required this.freeRoomCount, required this.totalRoomCount, required this.isActive, required this.isVisible});

  Offer.placeholder(this.isVisible);

}