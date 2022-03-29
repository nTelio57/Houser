import 'package:flutter/material.dart';
import 'package:houser/views/profile%20view/my_offer_list_view.dart';
import 'package:houser/views/welcome_view.dart';
import 'package:houser/widgets/WG_album_slider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: body(),
      appBar: AppBar(
        leading: Container(),
        actions: [
          offersButton()
        ],
      )
    );
  }

  Widget offersButton()
  {
    return IconButton(
      icon: const Icon(Icons.list),
      onPressed: () {
        Navigator.pop(context);
      }
    );
  }

  Widget body()
  {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            accountDetails(),
            const SizedBox(height: 32,),
            menuColumn(),
          ],
        ),
      ),
    );
  }

  Widget accountDetails()
  {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          name(),
          SizedBox(height: 12),
          WGAlbumSlider()
        ],
      ),
    );
  }

  Widget name()
  {
    return Text(
      'Vardenis Pavardenis',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget menuColumn()
  {
    return Column(
      children: [
        menuButton('Mano pasiūlymai', Icons.format_list_bulleted, () => OnOfferListClicked()),
        menuButton('Redaguoti profilį', Icons.edit,() => null),
        menuButton('Nustatymai', Icons.settings,() => null),
        menuButton('Atsijungti', Icons.logout, () => OnLogoutClicked(), isLogout: true),
      ],
    );
  }

  Widget menuButton(String title, IconData icon, Function() onPressed, {bool isLogout = false})
  {
    return Container(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Icon(
                icon,
                size: 28,
                color: isLogout ? Colors.red : Theme.of(context).primaryColorDark,
              ),
              const SizedBox(width: 4),
              Text(
                title.toUpperCase(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isLogout ? Colors.red : Theme.of(context).primaryColor
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }

  void OnOfferListClicked()
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyOfferListView()));
  }

  void OnLogoutClicked()
  {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const WelcomeView()), (Route<dynamic> route) => false);
  }
}
