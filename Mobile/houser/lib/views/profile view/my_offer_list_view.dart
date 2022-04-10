import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:houser/utils/current_login.dart';
import 'package:houser/models/Offer.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/views/profile%20view/my_offer_card.dart';
import 'package:houser/views/profile%20view/offer_form_view.dart';
import 'package:houser/widgets/WG_snackbars.dart';

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
      future: loadOffers().timeout(const Duration(seconds: 5)),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)
      {
        if(snapshot.hasData)
          {
            return offerList();
          }
        else if(snapshot.hasError)
          {
            return SizedBox(
              width: double.infinity,
              child: Text(
                'Įvyko klaida bandant gauti pasiūlymų sąrašą.'.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.red
                ),
              ),
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
    widget._apiService.UpdateOfer(offer.id, offer).timeout(const Duration(seconds: 5)).then((value) {
      setState(() {

      });
    })
    .catchError(handleSocketException, test: (e) => e is SocketException)
    .catchError(handleTimeoutException, test: (e) => e is TimeoutException)
    .catchError(handleVisibilityException, test: (e) => e is Exception);

  }

  void handleSocketException(Object o){
    ScaffoldMessenger.of(context).showSnackBar(noConnectionSnackbar);
  }

  void handleTimeoutException(Object o){
    ScaffoldMessenger.of(context).showSnackBar(noConnectionSnackbar);
  }

  void handleVisibilityException(Object o){
    ScaffoldMessenger.of(context).showSnackBar(visibilityChangeFailed);
  }

  void onDeleteClicked(Offer offer)
  {
    showDialog(
      context: context,
      builder: (context) => deleteDialog(offer)
    );
  }

  AlertDialog deleteDialog(Offer offer)
  {
    return AlertDialog(
      content: const Text('Ar tikrai norite ištrinti pasiūlymą?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('ATŠAUKTI')
        ),
        TextButton(
            onPressed: () {
              widget._apiService.DeleteOffer(offer.id).then((value) {
                setState(() {

                });
              });
              Navigator.pop(context);
            },
            child: const Text('IŠTRINTI')
        ),
      ],
    );
  }

}
