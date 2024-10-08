import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:houser/enums/FilterType.dart';
import 'package:houser/models/Room.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/services/current_login.dart';
import 'package:houser/services/offer%20manager/offer_card_manager.dart';
import 'package:houser/views/profile%20view/guest_profile_view.dart';
import 'package:houser/widgets/WG_album_slider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:collection/collection.dart';

class WGRoomCard extends StatefulWidget {
  final Room room;
  final bool isFront;

  const WGRoomCard({
    Key? key,
    required this.room,
    required this.isFront
  }) : super(key: key);

  @override
  _WGRoomCardState createState() => _WGRoomCardState();
}

class _WGRoomCardState extends State<WGRoomCard> {

  bool _isScrollable = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<OfferCardManager>(context, listen: false);
      provider.screenSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.isFront ? buildFrontCard() : buildCard(),
    );
  }

  Widget buildFrontCard()
  {
    return GestureDetector(
      child: LayoutBuilder(
        builder: (context, constraints)
        {
          final provider = Provider.of<OfferCardManager>(context, listen: true);
          final position = provider.position;
          final milliseconds = provider.isDragging ? 0 : 400;

          final center = constraints.smallest.center(Offset.zero);
          final angle = provider.angle * pi / 180;
          final rotatedMatrix = Matrix4.identity()
            ..translate(center.dx, center.dy)
            ..rotateZ(angle)
            ..translate(-center.dx, -center.dy)
            ..translate(position.dx, position.dy);

          return AnimatedContainer(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: milliseconds),
            transform: rotatedMatrix..translate(position.dx, position.dy),
            child: buildCard(),
          );
        },
      ),
      onPanStart: (details)
      {
        final provider = Provider.of<OfferCardManager>(context, listen: false);
        provider.startPosition(details);
      },
      onPanUpdate: (details)
      {
        final provider = Provider.of<OfferCardManager>(context, listen: false);
        provider.updatePosition(details);
      },
      onPanEnd: (details)
      {
        final provider = Provider.of<OfferCardManager>(context, listen: false);
        provider.endPosition();
      },
    );
  }

  Widget buildCard()
  {
    return slidingUpPanel(widget.room);
  }

  void onPanelOpened()
  {
    setState(() {
      _isScrollable = true;
    });
  }

  void onPanelClosed()
  {
    setState(() {
      _isScrollable = false;
    });
  }

  Widget slidingUpPanel(Room room)
  {
    var deviceHeight = MediaQuery.of(context).size.height;
    var mainImage = widget.room.images.firstWhereOrNull((i) => i.isMain);
    var imageWidget = mainImage != null? networkImage(mainImage.id) : noImage();

    return SlidingUpPanel(
      panel: slidePanel(),//Tas kas slidina
      body: imageWidget,//pagr vaizdas
      renderPanelSheet: false,
      minHeight: deviceHeight * 0.24,
      maxHeight: 600,
      onPanelOpened: onPanelOpened,
      onPanelClosed: onPanelClosed,
    );
  }

  Widget roomMainDetailsList()
  {
    Column column = Column(crossAxisAlignment: CrossAxisAlignment.start, children: []);

    column.children.add(title());
    column.children.add(durationDate());
    column.children.add(price());
    column.children.add(const SizedBox(height: 20));
    return column;
  }

  Widget roomDetailsList()
  {
    Room room = widget.room;
    Column column = Column(crossAxisAlignment: CrossAxisAlignment.start, children: []);

    widget.room.images.isNotEmpty ? column.children.add(imageAlbum()) : null;
    widget.room.images.isNotEmpty ? column.children.add(const SizedBox(height: 20)) : null;
    column.children.add(labelField('Pagrindinė info'));
    column.children.add(divider());
    column.children.add(basicTextField(Icons.location_city, room.city));
    column.children.add(basicTextField(Icons.location_on, room.address));
    if(room.area != null && room.area != 0)
    {
      column.children.add(basicTextField(Icons.square_foot, ('${room.area}m\u00B2')));
    }
    column.children.add(basicTextField(Icons.meeting_room, '${room.freeRoomCount} laisvas kambarys iš ${room.totalRoomCount}'));
    column.children.add(const SizedBox(height: 20));
    column.children.add(labelField('Taisyklės'));
    column.children.add(divider());
    room.ruleAnimals ? column.children.add(basicTextField(Icons.add, 'Gyvūnai galimi')) : column.children.add(basicTextField(Icons.remove, 'Gyvūnai negalimi'));
    room.ruleSmoking ? column.children.add(basicTextField(Icons.add, 'Rūkymas leidžiamas')) : column.children.add(basicTextField(Icons.remove, 'Rūkymas neleidžiamas'));
    column.children.add(const SizedBox(height: 20));
    column.children.add(labelField('Privalumai'));
    column.children.add(divider());
    room.accommodationTv ? column.children.add(basicTextField(Icons.tv, 'TV')) : null;
    room.accommodationWifi ? column.children.add(basicTextField(Icons.wifi, 'Wifi')): null;
    room.accommodationBalcony ? column.children.add(basicTextField(Icons.balcony, 'Balkonas')): null;
    room.accommodationAc ? column.children.add(basicTextField(Icons.air, 'Oro kondicionierius')) : null;
    room.accommodationDisability ? column.children.add(basicTextField(Icons.accessible, 'Pritaikyta neįgaliesiems')): null;
    room.accommodationParking ? column.children.add(basicTextField(Icons.local_parking, 'Parkingas')): null;
    column.children.add(const SizedBox(height: 20));
    column.children.add(labelField('Skelbėjas'));
    column.children.add(divider());
    column.children.add(ownerButton());

    return column;
  }

  Widget imageAlbum()
  {
    return WGAlbumSlider(widget.room.images.toList(), (value){}, (value){}, (value){}, isEditable: false);
  }

  Widget divider()
  {
    return const Divider(
      color: Colors.white,
      thickness: 2,
    );
  }

  Widget labelField(String text)
  {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w700
      ),
    );
  }

  Widget ownerButton()
  {
    return Container(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => GuestProfileView(FilterType.user, user: widget.room.user)));
        },
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            widget.room.user!.name!,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 16
            ),
          ),
        ),
        style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
            )
        ),
      ),
    );
  }

  Widget slidePanel()
  {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.7),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 10.0,
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
          ]
      ),
      margin: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        children: [
          roomMainDetailsList(),
          Expanded(
            child: SingleChildScrollView(
              child: roomDetailsList(),
              physics: _isScrollable ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }

  Widget image()
  {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    var imageHeight = deviceHeight;

    return SizedBox(
      height: imageHeight,
      child: AspectRatio(
        aspectRatio: deviceWidth/(imageHeight),
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  alignment: FractionalOffset.center,
                  image: AssetImage('assets/images/apt_placeholder1.jpg')
              )
          ),
        ),
      ),
    );
  }

  Widget noImage()
  {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_circle,
            color: Theme.of(context).primaryColor,
            size: 80,
          ),
          Text(
            'Šis pasiūlymas neturi nuotraukų.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 20
            ),
          )
        ],
      ),
    );
  }

  Widget networkImage(int id)
  {
    return CachedNetworkImage(
      imageUrl: 'https://${ApiService().apiUrl}/api/Image/$id',
      httpHeaders: {
        'Authorization': 'bearer ' + CurrentLogin().jwtToken,
      },
      fit: BoxFit.fitHeight,
      alignment: FractionalOffset.center,
      errorWidget: (context, url, error) => noImage(),
    );
  }

  Widget roomDetails()
  {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title(),
        ],
      ),
    );
  }

  Widget title()
  {
    Room room = widget.room;
    return SizedBox(
      height: 95,
      child: Text(
        room.title,
        textAlign: TextAlign.left,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w800
        ),
      ),
    );
  }

  Widget durationDate()
  {
    Room room = widget.room;
    return Text(
      '${dateToString(room.availableFrom)} - ${dateToString(room.availableTo)}',
      style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700
      ),
    );
  }

  Widget price()
  {
    Room room = widget.room;
    return Text(
      '${room.monthlyPrice}\$',
      style: const TextStyle(
          color: Colors.white,
          fontSize: 23,
          fontWeight: FontWeight.w700
      ),
    );
  }

  Widget basicTextField(IconData icon, String text)
  {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600
          ),
        ),
      ],
    );
  }

  String dateToString(DateTime dateTime)
  {
    return DateFormat('MM/dd/yyyy').format(dateTime);
  }
}
