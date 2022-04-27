import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:houser/utils/current_login.dart';
import 'package:houser/models/Image.dart' as apiImage;
import 'package:houser/services/api_service.dart';
import 'package:houser/widgets/WG_image_popup.dart';

// ignore: must_be_immutable
class WGAlbumSlider extends StatefulWidget {

  final ApiService _apiService = ApiService();

  List<apiImage.Image> images;
  Function(File) onUpload;
  Function(apiImage.Image) onDelete;
  Function(apiImage.Image) onSetAsMain;
  bool isEditable;

  WGAlbumSlider(this.images, this.onUpload, this.onDelete, this.onSetAsMain, {Key? key, this.isEditable = true}) : super(key: key);

  @override
  _WGAlbumSliderState createState() => _WGAlbumSliderState();
}

class _WGAlbumSliderState extends State<WGAlbumSlider> {

  Widget? errorCard, newPhotoCard;

  @override
  Widget build(BuildContext context) {
    errorCard = templateCard('Nepavyko užkrauti', Icons.error_outline, (){});
    newPhotoCard = templateCard('Pridėti nuotrauką', Icons.add, ()async{await uploadImage();});
    return body();
  }

  Widget body()
  {
    var deviceHeight = MediaQuery.of(context).size.height;
    double imageHeight = deviceHeight * 0.25;

    return SizedBox(
      height: imageHeight,
      child: photoList()
    );
  }

  Widget photoList()
  {
    var images = widget.images;
    int canAddImages = widget.isEditable ? 1 : 0;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: images.length+canAddImages,
      itemBuilder: (context, index)
      {
        if(index == 0 && widget.isEditable) return newPhotoCard!;
        return photoCard(images[index-canAddImages]);
      }
    );
  }

  Widget photoCard(apiImage.Image image)
  {
    var deviceHeight = MediaQuery.of(context).size.height;
    double imageHeight = deviceHeight * 0.25;

    List<Widget> widgets = [
      SizedBox(
        height: imageHeight,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
          ),
          child: AspectRatio(
            aspectRatio: 2/3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: image.id != 0 ? networkImage(image.id) : localImage(image.path),
            ),
          ),
        ),
      ),
    ];

    if(image.isMain && widget.isEditable) {
      widgets.add(mainImageFrame());
    }

    widgets.add(
        Positioned.fill(
        child: SizedBox(
          height: imageHeight,
          child: Card(
            elevation: 8,
            color: Colors.transparent,
            shadowColor: Colors.transparent,
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    showPopup(image);
                  },
                )
            ),
          ),
        )
    ));

    return Stack(
      children: widgets,
    );
  }

  Widget mainImageFrame()
  {
    return Positioned.fill(
      child: Card(
        elevation: 8,
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
        ),
        child: AspectRatio(
          aspectRatio: 2/3,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Theme.of(context).primaryColorDark,
                    width: 5
                )
            ),
            child: const Align(
              alignment: Alignment.topLeft,
              child: Icon(
                Icons.star,
                color: Colors.yellow,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget networkImage(int id)
  {
    return CachedNetworkImage(
      imageUrl: 'https://${widget._apiService.apiUrl}/api/Image/$id',
      placeholder: (context, url) => loadingCard(),
      errorWidget: (context, url, error) => errorCard!,
      httpHeaders: {
        'Authorization': 'bearer ' + CurrentLogin().jwtToken,
      },
      fit: BoxFit.fitHeight,
      alignment: FractionalOffset.center,
    );
  }

  Widget localImage(String path)
  {
    return Image.file(
        File(path),
      fit: BoxFit.fitHeight,
      alignment: FractionalOffset.center,
    );
  }

  Future uploadImage() async
  {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      print('Selected '+ file.path);
      await widget.onUpload(file);

    } else {
      // Atšaukė nuotraukos pasirinkimą
    }
  }

  Widget templateCard(String text, IconData icon, Function() onTap)
  {
    var deviceHeight = MediaQuery.of(context).size.height;
    double imageHeight = deviceHeight * 0.25;

    return Stack(
      children: [
        SizedBox(
          height: imageHeight,
          child: GestureDetector(
            onTap: (){},
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              ),
              child: AspectRatio(
                aspectRatio: 2/3,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 4
                      )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: Theme.of(context).primaryColor,
                        size: 40,
                      ),
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
            child: SizedBox(
              height: imageHeight,
              child: Card(
                elevation: 8,
                color: Colors.transparent,
                shadowColor: Colors.transparent,
                child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      onTap: onTap,
                    )
                ),
              ),
            )
        )
      ],
    );
  }

  Widget loadingCard()
  {
    var deviceHeight = MediaQuery.of(context).size.height;
    double imageHeight = deviceHeight * 0.25;

    return SizedBox(
      height: imageHeight,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
        ),
        child: AspectRatio(
          aspectRatio: 2/3,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 4
                )
            ),
            child: const Center(child: CircularProgressIndicator())
          ),
        ),
      ),
    );
  }

  Future deleteImage(apiImage.Image image) async
  {
    await widget.onDelete(image);
  }

  Future setAsMain(apiImage.Image image) async
  {
    await widget.onSetAsMain(image);
  }

  void showPopup(apiImage.Image image)
  {
    Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => WGImagePopup(image, deleteImage, setAsMain, isEditable: widget.isEditable)
        )
    );
  }

}
