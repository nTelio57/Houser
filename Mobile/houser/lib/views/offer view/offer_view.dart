import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:houser/enums/FilterType.dart';
import 'package:houser/models/Filter.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/services/messenger_service.dart';
import 'package:houser/services/current_login.dart';
import 'package:houser/views/filter%20view/filter_base.dart';
import 'package:houser/views/match%20view/match_list_view.dart';
import 'package:houser/views/profile%20view/my_profile_menu_view.dart';
import 'package:houser/widgets/WG_RoomCard.dart';
import 'package:houser/services/offer%20manager/offer_card_manager.dart';
import 'package:houser/widgets/WG_UserCard.dart';
import 'package:houser/widgets/WG_snackbars.dart';
import 'package:provider/provider.dart';

class OfferView extends StatefulWidget {
  OfferView({Key? key}) : super(key: key);

  final CurrentLogin _currentLogin = CurrentLogin();
  final ApiService _apiService = ApiService();

  @override
  _OfferViewState createState() => _OfferViewState();
}

class _OfferViewState extends State<OfferView> {

  @override
  void initState() {
    MessengerService().init();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setupLoader();
    super.didChangeDependencies();
  }

  void setupLoader()
  {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..maskType = EasyLoadingMaskType.custom
      ..backgroundColor = Theme.of(context).primaryColor
      ..textColor = Colors.white
      ..indicatorColor = Colors.white
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..fontSize = 16
      ..contentPadding = const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0)
      ..maskColor = Colors.black.withOpacity(0.2)
      ..displayDuration = const Duration(seconds: 7);
  }

  @override
  Widget build(BuildContext context) {
    return scaffold();
  }

  Widget scaffold()
  {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBar(),
      body: body(),
      floatingActionButton: filterFab(),
    );
  }

  Widget body()
  {
    return Stack(
      children: [
        roomCardStack(),
      ],
    );
  }

  Widget roomCardStack()
  {
    final provider = Provider.of<OfferCardManager>(context);

    switch(widget._currentLogin.user!.filter!.filterType)
    {
      case FilterType.room:
        final rooms = provider.rooms;
        return rooms.isEmpty ? noOffersResult() :
        Stack(
          children: rooms.reversed.map((room) => WGRoomCard(room: room, isFront: room == rooms.first)).toList(),
        );
      case FilterType.user:
        final users = provider.users;
        return users.isEmpty ? noOffersResult() :
        Stack(
          children: users.reversed.map((user) => WGUserCard(user: user, isFront: user == users.first)).toList(),
        );
    }

    final rooms = provider.rooms;
    return rooms.isEmpty ? noOffersResult() :
    Stack(
      children: rooms.reversed.map((room) => WGRoomCard(room: room, isFront: room == rooms.first)).toList(),
    );
  }

  Widget noOffersResult()
  {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Center(
        child: Text(
          'Nerasta galimų rekomendacijų. Mėginkite pakoreguoti filtrą ir mėginkite dar kartą.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  AppBar appBar()
  {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
      elevation: 0,
      leading: profileButton(),
      actions: [
        matchesButton()
      ],
    );
  }

  Widget profileButton()
  {
    return Container(
      padding: const EdgeInsets.only(left: 8),
      child: IconButton(
        icon: const Icon(
          Icons.person,
          color: Colors.white,
          size: 24,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfileMenuView()));
        },
      ),
    );
  }

  Widget topPanelSeparator()
  {
    return Expanded(
      child: Container(
      ),
    );
  }

  Widget matchesButton()
  {
    return Container(
      padding: const EdgeInsets.only(right: 8),
      child: IconButton(
        icon: const Icon(
          Icons.chat,
          color: Colors.white,
          size: 24,
        ),
        onPressed: () async{
          await MessengerService().init();

          Navigator.push(context, MaterialPageRoute(builder: (context) => MatchListView()));
        },
      ),
    );
  }

  Widget filterFab()
  {
    return FloatingActionButton(
      child: const Icon(Icons.search),
      backgroundColor: Colors.redAccent,
      onPressed: (){
        Navigator.of(context).push(
            PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => FilterBaseView(onFilterChanged)
            )
        );
      })
    ;
  }

  Future onFilterChanged(Filter newFilter) async{
    widget._currentLogin.user!.filter = newFilter;
    widget._apiService.PostFilter(newFilter);
    final provider = Provider.of<OfferCardManager>(context, listen: false);

    provider.resetOffers();
    try{
      await provider.loadOffersAsync(3, 0);
      provider.loadOffersSync(7, 3);
    }catch(e){

    }

    Navigator.pop(context);
    return;
  }
}
