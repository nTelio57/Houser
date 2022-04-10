import 'package:flutter/material.dart';
import 'package:houser/views/profile%20view/profile_view.dart';
import 'package:houser/widgets/WG_OfferCard.dart';
import 'package:houser/utils/offer_card_manager.dart';
import 'package:provider/provider.dart';

class OfferView extends StatefulWidget {
  const OfferView({Key? key}) : super(key: key);

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
    );
  }

  Widget body()
  {
    return Stack(
      children: [
        offerCardStack(),
        topPanel(),
      ],
    );
  }

  Widget offerCardStack()
  {
    final provider = Provider.of<OfferCardManager>(context);
    final offers = provider.offers;

    return Stack(
      children: offers.reversed.map((offer) => WGOfferCard(offer: offer, isFront: offer == offers.first)).toList(),
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

}
