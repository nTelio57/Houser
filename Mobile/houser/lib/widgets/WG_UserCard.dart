import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:houser/models/User.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/utils/current_login.dart';
import 'package:houser/utils/offer_card_manager.dart';
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
    //var imageId = widget.user.images.firstWhere((i) => i.isMain).id;

    return SlidingUpPanel(
      panel: slidePanel(),//Tas kas slidina
      body: networkImage(1),//pagr vaizdas
      collapsed: slidePanelCollapsed(),
      renderPanelSheet: false,
      minHeight: deviceHeight * 0.24,
      maxHeight: 600,
    );
  }

  Widget slidePanelCollapsed()
  {
    return Wrap(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
          ),
          margin: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title(),
            ],
          ),
        ),
      ],
    );
  }

  Widget userDetailsList()
  {
    Column column =
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title(),
        const SizedBox(height: 47),
        const SizedBox(height: 20),
      ],
    );

    return column;
  }

  Widget slidePanel()
  {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.7),
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            boxShadow: [
              BoxShadow(
                blurRadius: 10.0,
                color: Theme.of(context).primaryColor.withOpacity(0.3),
              ),
            ]
        ),
        margin: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: userDetailsList(),
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
      height: 95,
      child: Text(
        user.name!.toUpperCase(),
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
