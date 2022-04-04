import 'package:flutter/material.dart';
import 'package:houser/models/Offer.dart';
import 'package:houser/views/profile%20view/offer_form_view.dart';

// ignore: must_be_immutable
class MyOfferCard extends StatefulWidget {
  Offer offer;
  Function() onEditClick;
  Function() onVisibilityClick;
  Function() onDeleteClick;

  MyOfferCard(this.onEditClick, this.onVisibilityClick, this.onDeleteClick, {Key? key, required this.offer}) : super(key: key);

  @override
  _MyOfferCardState createState() => _MyOfferCardState();
}

class _MyOfferCardState extends State<MyOfferCard> {
  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body()
  {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      ),
      child: ExpansionTile(
        trailing: trailing(),
        title: header(widget.offer),
        children: [
          expansion(widget.offer)
        ],
      ),
    );
  }

  Widget trailing()
  {
    return Column(
      children: [
        const Icon(Icons.expand_more),
        !widget.offer.isVisible ? const Icon(Icons.visibility_off) : const Spacer(),
      ],
    );
  }

  Widget header(Offer offer)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title(offer),
        address(offer),
        roomCount(offer)
      ],
    );
  }

  Widget title(Offer offer)
  {
    return Text(
      offer.title.toUpperCase(),
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget address(Offer offer)
  {
    return Row(
      children: [
        Icon(
          Icons.place,
          color: Theme.of(context).primaryColor
        ),
        Text(
          '${offer.city}, ${offer.address}',
          style: const TextStyle(
              fontSize: 16
          ),
        )
      ],
    );
  }

  Widget roomCount(Offer offer)
  {
    return Row(
      children: [
        Icon(
          Icons.person_search,
            color: Theme.of(context).primaryColor
        ),
        Text(
          '${offer.freeRoomCount} / ${offer.totalRoomCount}',
          style: const TextStyle(
              fontSize: 16
          ),
        )
      ],
    );
  }

  Widget expansion(Offer offer)
  {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          expansionButton(Icons.edit, widget.onEditClick),
          expansionButton(offer.isVisible ? Icons.visibility_off : Icons.visibility, widget.onVisibilityClick),
          expansionButton(Icons.delete, widget.onDeleteClick, iconColor: Colors.red.shade300),
        ],
      ),
    );
  }

  Widget expansionButton(IconData icon, Function() onPressed, {Color iconColor = Colors.white})
  {
    return IconButton(
      icon: Icon(
        icon,
        color: iconColor,
      ),
      onPressed: onPressed,
    );
  }

}
