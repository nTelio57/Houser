import 'package:flutter/material.dart';
import 'package:houser/models/CurrentLogin.dart';
import 'package:houser/models/Offer.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/views/profile%20view/my_offer_card.dart';
import 'package:houser/views/profile%20view/offer_form_view.dart';

class MyOfferListView extends StatefulWidget {
  MyOfferListView({Key? key}) : super(key: key);

  final ApiService _apiService = ApiService();
  final CurrentLogin _currentLogin = CurrentLogin();

  @override
  _MyOfferListViewState createState() => _MyOfferListViewState();
}

class _MyOfferListViewState extends State<MyOfferListView> {

  List<Offer> offers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: body(),
      appBar: AppBar(
        actions: [
          newOfferButton()
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  Widget newOfferButton()
  {
    return IconButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => OfferFormView())).then((value) => setState((){}));
      },
      icon: const Icon(Icons.add)
    );
  }

  Widget body()
  {
    return Container(
      margin: const EdgeInsets.all(10),
      child: offerLoader(),
    );
  }

  Widget offerLoader()
  {
    return FutureBuilder(
      future: loadOffers(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)
      {
        if(snapshot.hasData)
          {
            return offerList();
          }
        else if(snapshot.hasError)
          {
            return Container(
              color: Colors.red,
            );
          }
        else
          {
            if(offers.isNotEmpty) {
              return offerList();
            }
            else
              {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
          }
      },
    );
  }

  Future loadOffers() async
  {
    offers = await widget._apiService.GetOffersByUser(widget._currentLogin.user!.id);
    return true;
  }

  Widget offerList()
  {
    return RefreshIndicator(
      onRefresh: () async {
        await loadOffers();
        setState(() {

        });
      },
      child: ListView.builder(
        itemCount: offers.length,
        itemBuilder: (context, index)
            {
              return MyOfferCard((){onEditClicked(offers[index]);}, (){onVisibilityClicked(offers[index]);}, (){onDeleteClicked(offers[index]);}, offer: offers[index]);
            }
      ),
    );
  }

  void onEditClicked(Offer offer)
  {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => OfferFormView(isEditingMode: true, offerToEdit: offer))).then((value) => setState((){}));
  }

  void onVisibilityClicked(Offer offer)
  {
    offer.isVisible = !offer.isVisible;
    widget._apiService.UpdateOfer(offer.id, offer).then((value) {
      setState(() {

      });
    });
  }

  void onDeleteClicked(Offer offer)
  {
    widget._apiService.DeleteOffer(offer.id).then((value) {
      setState(() {

      });
    });
  }

}
