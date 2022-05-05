import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houser/enums/SleepType.dart';
import 'package:houser/extensions/bool_extensions.dart';
import 'package:houser/extensions/int_extensions.dart';
import 'package:houser/models/User.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/services/current_login.dart';
import 'package:houser/services/offer%20manager/offer_card_manager.dart';
import 'package:houser/widgets/WG_album_slider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class WGUserCard extends StatefulWidget {
  final User user;
  final bool isFront;

  const WGUserCard({
    Key? key,
    required this.user,
    required this.isFront
  }) : super(key: key);

  @override
  _WGUserCardState createState() => _WGUserCardState();
}

class _WGUserCardState extends State<WGUserCard> {

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
    return slidingUpPanel(widget.user);
  }

  Widget slidingUpPanel(User user)
  {
    var deviceHeight = MediaQuery.of(context).size.height;
    var mainImage = widget.user.getMainImage();
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

  Widget userMainDetailsList()
  {
    User user = widget.user;
    Column column = Column(crossAxisAlignment: CrossAxisAlignment.start, children: []);

    column.children.add(title());
    column.children.add(const SizedBox(height: 32));
    column.children.add(basicTextField(Icons.cake, user.age.toString()));
    column.children.add(basicTextField(user.sex!.iconBySex, user.sex!.sexToString));
    column.children.add(const SizedBox(height: 20));
    return column;
  }

  Widget userDetailsList()
  {
    User user = widget.user;
    Column column = Column(crossAxisAlignment: CrossAxisAlignment.start, children: []);

    widget.user.images.isNotEmpty ? column.children.add(imageAlbum()) : null;
    widget.user.images.isNotEmpty ? column.children.add(const SizedBox(height: 20)) : null;
    column.children.add(basicTextField(user.isStudying!.iconByStudying, user.isStudying! ? 'Studijuoju' : 'Nestudijuoju'));
    column.children.add(basicTextField(user.isWorking!.iconByWorking, user.isWorking! ? 'Dirbu' : 'Nedirbu'));
    column.children.add(basicTextField(user.isSmoking!.iconBySmoking, user.isSmoking! ? 'Rūkau' : 'Nerūkau'));
    column.children.add(const SizedBox(height: 20));
    if(user.animalCount != null && user.animalCount! > 0)
    {
      column.children.add(basicTextField(Icons.pets, user.animalCount!.animalCountToString));
    }
    column.children.add(basicTextField(Icons.groups, user.guestCount!.guestCountToString));
    column.children.add(basicTextField(Icons.celebration, user.partyCount!.partyCountToString));
    user.sleepType != SleepType.none ? column.children.add(basicTextField(user.sleepType!.index.iconBySleepType, user.sleepType!.index.sleepTypeToString)) : null;

    return column;
  }

  Widget imageAlbum()
  {
    return WGAlbumSlider(widget.user.images.toList(), (value){}, (value){}, (value){}, isEditable: false);
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
          userMainDetailsList(),
          Expanded(
            child: SingleChildScrollView(
              physics: _isScrollable ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
              child: userDetailsList()
            ),
          ),
        ],
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
            'Šis vartotojas neturi nuotraukų.',
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

  Widget networkImage(int id)
  {
    return CachedNetworkImage(
      imageUrl: 'https://${ApiService().apiUrl}/api/Image/$id',
      httpHeaders: {
        'Authorization': 'bearer ' + CurrentLogin().jwtToken,
      },
      fit: BoxFit.fitHeight,
      alignment: FractionalOffset.center,
    );
  }

  Widget userDetails()
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
    User user = widget.user;
    return SizedBox(
      height: 70,
      child: Text(
        user.name!,
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
