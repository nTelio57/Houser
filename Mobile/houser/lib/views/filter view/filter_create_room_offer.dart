import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FilterCreateRoomOffer extends StatefulWidget {
  FilterCreateRoomOffer(this.onButtonClick, {Key? key}) : super(key: key);

  late Function() onButtonClick;

  @override
  _FilterCreateRoomOfferState createState() => _FilterCreateRoomOfferState();
}

class _FilterCreateRoomOfferState extends State<FilterCreateRoomOffer> {
  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body()
  {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          text(),
          const SizedBox(height: 24),
          button(),
        ],
      ),
    );
  }

  Widget text()
  {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Text(
        'Neturite sukurto savo kambario pasiūlymo.\nNorint ieškoti kambarioko turite sukūrti savo kambario pasiūlymą.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w600
        ),
      ),
    );
  }

  Widget button()
  {
    return TextButton(
      style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          primary: Colors.black,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
          )
      ),
      onPressed: (){
        onButtonPressed();
      },
      child: Text(
        'Sukurti kambario pasiūlymą'.toUpperCase(),
        style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16
        ),
      ),
    );
  }

  void onButtonPressed()
  {
    widget.onButtonClick();
  }
}
