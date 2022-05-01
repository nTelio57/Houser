import 'package:flutter/material.dart';
import 'package:houser/models/Room.dart';

// ignore: must_be_immutable
class MyRoomCard extends StatefulWidget {
  Room room;
  Function() onEditClick;
  Function() onVisibilityClick;
  Function() onDeleteClick;

  MyRoomCard(this.onEditClick, this.onVisibilityClick, this.onDeleteClick, {Key? key, required this.room}) : super(key: key);

  @override
  _MyRoomCardState createState() => _MyRoomCardState();
}

class _MyRoomCardState extends State<MyRoomCard> {
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
        title: header(widget.room),
        children: [
          expansion(widget.room)
        ],
      ),
    );
  }

  Widget trailing()
  {
    return Column(
      children: [
        const Icon(Icons.expand_more),
        !widget.room.isVisible ? const Icon(Icons.visibility_off) : const Spacer(),
      ],
    );
  }

  Widget header(Room room)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title(room),
        address(room),
        roomCount(room)
      ],
    );
  }

  Widget title(Room room)
  {
    return Text(
      room.title.toUpperCase(),
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget address(Room room)
  {
    return Row(
      children: [
        Icon(
          Icons.place,
          color: Theme.of(context).primaryColor
        ),
        Text(
          '${room.city}, ${room.address}',
          style: const TextStyle(
              fontSize: 16
          ),
        )
      ],
    );
  }

  Widget roomCount(Room room)
  {
    return Row(
      children: [
        Icon(
          Icons.person_search,
            color: Theme.of(context).primaryColor
        ),
        Text(
          '${room.freeRoomCount} / ${room.totalRoomCount}',
          style: const TextStyle(
              fontSize: 16
          ),
        )
      ],
    );
  }

  Widget expansion(Room room)
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
          expansionButton(room.isVisible ? Icons.visibility_off : Icons.visibility, widget.onVisibilityClick),
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
