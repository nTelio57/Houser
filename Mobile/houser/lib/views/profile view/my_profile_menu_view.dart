import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:houser/extensions/int_extensions.dart';
import 'package:houser/services/api_client.dart';
import 'package:houser/services/current_login.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/services/offer%20manager/offer_card_manager.dart';
import 'package:houser/views/personal%20details%20view/personal_details_create_stepper.dart';
import 'package:houser/views/profile%20view/my_room_list_view.dart';
import 'package:houser/views/welcome_view.dart';
import 'package:houser/widgets/WG_album_slider.dart';
import 'package:houser/models/Image.dart' as apiImage;
import 'package:houser/widgets/WG_snackbars.dart';
import 'package:provider/provider.dart';

class MyProfileMenuView extends StatefulWidget {

  final ApiService _apiService = ApiService();

  MyProfileMenuView({Key? key}) : super(key: key);
  final CurrentLogin _currentLogin = CurrentLogin();

  @override
  _MyProfileMenuViewState createState() => _MyProfileMenuViewState();
}

class _MyProfileMenuViewState extends State<MyProfileMenuView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: body(),
      appBar: AppBar(
        leading: Container(),
        actions: [
          roomsButton()
        ],
      )
    );
  }

  Widget roomsButton()
  {
    return IconButton(
      icon: const Icon(Icons.home),
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
            return WGAlbumSlider(widget._currentLogin.user!.images, onImageUpload, onImageDelete, onImageSetAsMain);
          }
          else if(snapshot.hasError)
          {
            return Container(
              color: Colors.red,
            );
          }
          else
          {
            return WGAlbumSlider(widget._currentLogin.user!.images, onImageUpload, onImageDelete, onImageSetAsMain);
          }
        }
    );
  }

  Future onImageUpload(File file) async
  {
    try{
      ApiResponse postResult = await widget._apiService.PostUserImage(file.path).timeout(const Duration(seconds: 5));
      if(!postResult.statusCode.isSuccessStatusCode)
      {
        ScaffoldMessenger.of(context).showSnackBar(failedFileUpload);
      }
    }on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(noConnectionSnackbar);
    } on TimeoutException {
      ScaffoldMessenger.of(context).showSnackBar(serverErrorSnackbar);
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(failedFileUpload);
    }
    setState(() {
    });
  }

  Future onImageDelete(apiImage.Image image) async
  {
    try{
      var deleteResult = await widget._apiService.DeleteImage(image.id).timeout(const Duration(seconds: 5));

      if(!deleteResult)
      {
        ScaffoldMessenger.of(context).showSnackBar(failedImageDelete);
      }
    }on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(noConnectionSnackbar);
    } on TimeoutException {
      ScaffoldMessenger.of(context).showSnackBar(serverErrorSnackbar);
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(failedImageDelete);
    }
    setState(() {

    });
  }

  Future onImageSetAsMain(apiImage.Image image) async
  {
    try{
      image.isMain = true;
      var updateResult = await widget._apiService.UpdateImage(image.id, image).timeout(const Duration(seconds: 5));

      if(!updateResult)
      {
        ScaffoldMessenger.of(context).showSnackBar(failedImageUpdate);
      }
    }on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(noConnectionSnackbar);
    } on TimeoutException {
      ScaffoldMessenger.of(context).showSnackBar(serverErrorSnackbar);
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(failedImageUpdate);
    }
    setState(() {

    });
  }

  Future loadImages() async
  {
    var images = await widget._apiService.GetAllImagesByUserId(widget._currentLogin.user!.id);
    images = images.reversed.toList();
    widget._currentLogin.user!.images = images;
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
        userVisibilitySwitch(),
        menuButton('Mano pasiūlymai', Icons.format_list_bulleted, () => onRoomListClicked()),
        menuButton('Redaguoti profilį', Icons.edit,() => onProfileEditClicked()),
        //menuButton('Nustatymai', Icons.settings,() => null),
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

  Widget userVisibilitySwitch()
  {
    return SwitchListTile(
      onChanged: (bool value) {
        updateUserVisibility(!widget._currentLogin.user!.isVisible);
        setState(() {
          widget._currentLogin.user!.isVisible = !widget._currentLogin.user!.isVisible;
        });
      },
      contentPadding: const EdgeInsets.only(left: 8),
      value: widget._currentLogin.user!.isVisible,
      title: Row(
        children: [
          Icon(
            Icons.visibility,
            size: 28,
            color: Theme.of(context).primaryColorDark,
          ),
          const SizedBox(width: 4),
          Text(
            'Rodyti manę kitiems'.toUpperCase(),
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor
            ),
          ),
        ],
      ),
    );
  }

  Future updateUserVisibility(bool visibility) async{
    await widget._apiService.UpdateUserVisibility(widget._currentLogin.user!.id, visibility);
  }

  onProfileEditClicked() async{
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
        PersonalDetailsCreateStepper(userToEdit: widget._currentLogin.user!, isEditingMode: true)))
        .then((value) => setState((){}));
  }

  void onRoomListClicked()
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyRoomListView()));
  }

  Future onLogoutClicked() async
  {
    await widget._currentLogin.clear();
    final provider = Provider.of<OfferCardManager>(context, listen: false);
    provider.resetOffers();

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const WelcomeView()), (Route<dynamic> route) => false);
  }
}
