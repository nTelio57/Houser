import 'package:flutter/material.dart';
import 'package:houser/enums/FilterType.dart';
import 'package:houser/models/Filter.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/utils/current_login.dart';
import 'package:houser/views/filter%20view/filter_base.dart';
import 'package:houser/views/profile%20view/profile_view.dart';
import 'package:houser/widgets/WG_RoomCard.dart';
import 'package:houser/utils/offer_card_manager.dart';
import 'package:houser/widgets/WG_UserCard.dart';
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
  Widget build(BuildContext context) {
    return scaffold();
  }

  Widget scaffold()
  {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: body(),
      floatingActionButton: filterFab(),
    );
  }

  Widget body()
  {
    return Stack(
      children: [
        roomCardStack(),
        topPanel(),
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

  Widget topPanel()
  {
    var deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      height: deviceHeight * 0.09,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(0, 0, 0, 0.8),
            Color.fromRGBO(0, 0, 0, 0.6),
            Color.fromRGBO(0, 0, 0, 0.4),
            Color.fromRGBO(0, 0, 0, 0.2),
          ]
        ),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32))
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profileButton(),
            topPanelSeparator(),
            messagesButton(),
          ],
        ),
      ),
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileView()));
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

  Widget messagesButton()
  {
    return Container(
      padding: const EdgeInsets.only(right: 8),
      child: IconButton(
        icon: const Icon(
          Icons.chat,
          color: Colors.white,
          size: 24,
        ),
        onPressed: () {},
      ),
    );
  }

  Widget filterFab()
  {
    return FloatingActionButton(
      child: const Icon(Icons.filter_list),
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
    widget._apiService.PostFilter(newFilter);
    var currentUser = widget._currentLogin.user!;
    final provider = Provider.of<OfferCardManager>(context, listen: false);

    currentUser.filter = newFilter;
    provider.resetOffers();
    await provider.loadOffersAsync(3, 0);
    provider.loadOffersSync(7, 3);

    Navigator.pop(context);
    return;
  }
}
