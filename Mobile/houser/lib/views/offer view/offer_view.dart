import 'package:flutter/material.dart';
import 'package:houser/views/profile%20view/profile_view.dart';

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
        image(),
        topPanel(),
        bottomPanel(),
      ],
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
            const Spacer(),
            location(),
            const SizedBox(height: 4),
            spaceCount(),
          ],
      ),
    );
  }

  Widget title()
  {
    return const Text(
      'Ieškomas vienas kambariokas labai labai ilgas ir dar ilgesnis pavadinimas',
      textAlign: TextAlign.left,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20
      ),
    );
  }

  Widget location()
  {
    return Row(
      children: const [
        Icon(
          Icons.place,
          color: Colors.white,
        ),
        Text(
          'Kaunas, Baršausko g. 86',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16
          ),
        )
      ],
    );
  }

  Widget spaceCount()
  {
    return Row(
      children: const [
        Icon(
          Icons.person_search,
          color: Colors.white,
        ),
        Text(
          '1/3',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16
          ),
        )
      ],
    );
  }

}
