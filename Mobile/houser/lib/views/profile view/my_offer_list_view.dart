import 'package:flutter/material.dart';
import 'package:houser/models/Offer.dart';
import 'package:houser/views/profile%20view/my_offer_card.dart';

class MyOfferListView extends StatefulWidget {
  const MyOfferListView({Key? key}) : super(key: key);

  @override
  _MyOfferListViewState createState() => _MyOfferListViewState();
}

class _MyOfferListViewState extends State<MyOfferListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
      appBar: AppBar(),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  Widget body()
  {
    return Container(
      margin: const EdgeInsets.all(10),
      child: list(),
    );
  }

  Widget list()
  {
    return Column(
      children: [
        MyOfferCard(offer: Offer.placeholder(false)),
        const SizedBox(height: 10,),
        MyOfferCard(offer: Offer.placeholder(false)),
        const SizedBox(height: 10,),
        MyOfferCard(offer: Offer.placeholder(true)),
        const SizedBox(height: 10,),
        MyOfferCard(offer: Offer.placeholder(true)),
      ],
    );
  }
}
