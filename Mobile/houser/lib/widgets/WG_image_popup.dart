import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:houser/models/Image.dart' as apiImage;
import 'package:houser/services/api_service.dart';
import 'package:houser/utils/current_login.dart';

// ignore: must_be_immutable
class WGImagePopup extends StatefulWidget {

  apiImage.Image image;
  Function(apiImage.Image) onDelete;
  Function(apiImage.Image) onSetAsMain;

  WGImagePopup(this.image, this.onDelete, this.onSetAsMain, {Key? key}) : super(key: key);

  @override
  _WGImagePopupState createState() => _WGImagePopupState();
}

class _WGImagePopupState extends State<WGImagePopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
      backgroundColor: Colors.transparent,
      floatingActionButton: fab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget body()
  {
    return Stack(
      children: [
        imageParent(),
      ],
    );
  }

  Widget imageParent()
  {
    return GestureDetector(
      onTap: closePopup,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        width: double.infinity,
        height: double.infinity,
        child: FittedBox(
          fit: BoxFit.contain,
          child: widget.image.id != 0 ? networkImage(widget.image.id) : localImage(widget.image.path),
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
      fit: BoxFit.fill,
      alignment: FractionalOffset.center,
    );
  }

  Widget localImage(String path)
  {
    return Image.file(
      File(path),
      fit: BoxFit.fill,
      alignment: FractionalOffset.center,
    );
  }
  void setAsMainImage()
  {
    widget.onSetAsMain(widget.image);
  }

  void delete()
  {
    widget.onDelete(widget.image);
    Navigator.pop(context);
  }

  void closePopup()
  {
    Navigator.pop(context);
  }

  Widget fab()
  {
    var theme = Theme.of(context);

    var labelStyle = const TextStyle(
        fontWeight: FontWeight.w600
    );

    List<SpeedDialChild> fabButtons = [];

    if(!widget.image.isMain)
      {
        fabButtons.add(
            SpeedDialChild(
                child: const Icon(
                  Icons.image,
                  color: Colors.white,
                ),
                label: 'Nustatyti kaip pagrindine',
                backgroundColor: theme.primaryColor,
                labelStyle: labelStyle,
                onTap: (){
                  Navigator.pop(context);
                  setAsMainImage();
                }
            )
        );
      }

    fabButtons.add(
        SpeedDialChild(
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            label: 'Ištrinti',
            backgroundColor: Colors.red,
            labelStyle: labelStyle,
            onTap: (){
              showDialog(
                  context: context,
                  builder: (context) => deleteDialog()
              );
            }
        )
    );

    return SpeedDial(
      icon: Icons.menu,
      backgroundColor: theme.primaryColor,
      activeIcon: Icons.close,
      activeBackgroundColor: theme.primaryColorDark,
      overlayOpacity: 0,
      children: fabButtons
    );
  }

  AlertDialog deleteDialog()
  {
    return AlertDialog(
      content: const Text('Ar tikrai norite ištrinti nuotrauką?'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'ATŠAUKTI',
              style: TextStyle(
                  fontWeight: FontWeight.w600
              ),
            )
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              delete();
            },
            child: const Text(
              'IŠTRINTI',
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600
              ),
            )
        ),
      ],
    );
  }
}