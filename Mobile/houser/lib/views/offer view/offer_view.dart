import 'package:flutter/material.dart';
import 'package:houser/views/profile%20view/profile_view.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
        slidingUpPanel(),
        topPanel(),
        //bottomPanel(),
      ],
    );
  }

  Widget slidingUpPanel()
  {
    var deviceHeight = MediaQuery.of(context).size.height;

    return SlidingUpPanel(
      panel: slidePanel(),//Tas kas slidina
      body: image(),//pagr vaizdas
      collapsed: slidePanelCollapsed(),
      renderPanelSheet: false,
      minHeight: deviceHeight * 0.24,
    );
  }

  Widget slidePanelCollapsed()
  {
    return Container(
      child: Wrap(
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
                durationDate(),
                price(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget offerDetailsList()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title(),
        durationDate(),
        price(),
        const SizedBox(height: 47),
        basicTextField(Icons.location_city, 'Kaunas'),
        basicTextField(Icons.location_on, 'K. Baršausko g. 86'),
        basicTextField(Icons.square_foot, ('75m\u00B2')),
        basicTextField(Icons.meeting_room, '1 laisvas kambarys iš 3'),
        const SizedBox(height: 20),
        basicTextField(Icons.tv, 'TV'),
        basicTextField(Icons.wifi, 'Wifi'),
        basicTextField(Icons.balcony, 'Balkonas'),
      ],
    );
  }

  Widget slidePanel()
  {
    return Container(
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
      child: offerDetailsList(

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

  Widget bottomPanel()
  {
    var deviceHeight = MediaQuery.of(context).size.height;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: deviceHeight * 0.2,
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.4)
        ),
        child: offerDetails(),
      ),
    );
  }

  Widget offerDetails()
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
    return Text(
      'Ieškomas vienas kambariokas dviems mėnesiams'.toUpperCase(),
      textAlign: TextAlign.left,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 23,
        fontWeight: FontWeight.w800
      ),
    );
  }

  Widget durationDate()
  {
    return const Text(
      '04/09/2022 - 12/29/2022',
      style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700
      ),
    );
  }

  Widget price()
  {
    return const Text(
      '150.00\$',
      style: TextStyle(
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

}
