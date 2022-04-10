import 'package:flutter/material.dart';
import 'package:houser/utils/current_login.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/views/profile%20view/my_offer_list_view.dart';
import 'package:houser/views/welcome_view.dart';
import 'package:houser/widgets/WG_album_slider.dart';
import 'package:houser/models/Image.dart' as apiImage;

class ProfileView extends StatefulWidget {

  final ApiService _apiService = ApiService();

  ProfileView({Key? key}) : super(key: key);
  final CurrentLogin _currentLogin = CurrentLogin();

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  List<apiImage.Image> images = [];

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

  Widget photoSlider()
  {
    return FutureBuilder(
      future: loadImages(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)
        {

          if(snapshot.hasData)
          {
            return WGAlbumSlider(images, onImageUpload);
          }
          else if(snapshot.hasError)
          {
            return Container(
              color: Colors.red,
            );
          }
          else
          {
            return WGAlbumSlider(images, onImageUpload);
          }
        }
    );
  }

  void onImageUpload()
  {
    setState(() {
    });
  }

  Future loadImages() async
  {
    images = await widget._apiService.GetAllImagesByUserId(widget._currentLogin.user!.id);
    images = images.reversed.toList();
    return true;
  }

  Widget accountDetails()
  {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          name(),
          const SizedBox(height: 12),
          photoSlider(),
        ],
      ),
    );
  }

  Widget name()
  {
    String name = widget._currentLogin.user!.name!;
    int age = widget._currentLogin.user!.age;

    return SizedBox(
      height: 37,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          '$name, $age',
          maxLines: 1,
          overflow: TextOverflow. ellipsis,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget menuColumn()
  {
    return Column(
      children: [
        menuButton('Mano pasiūlymai', Icons.format_list_bulleted, () => onOfferListClicked()),
        menuButton('Redaguoti profilį', Icons.edit,() => null),
        menuButton('Nustatymai', Icons.settings,() => null),
        menuButton('Atsijungti', Icons.logout, () => onLogoutClicked(), isLogout: true),
      ],
    );
  }

  Widget menuButton(String title, IconData icon, Function() onPressed, {bool isLogout = false})
  {
    return SizedBox(
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

  void onOfferListClicked()
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyOfferListView()));
  }

  Future onLogoutClicked() async
  {
    await widget._currentLogin.clear();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const WelcomeView()), (Route<dynamic> route) => false);
  }
}
