import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:houser/extensions/int_extensions.dart';
import 'package:houser/models/CurrentLogin.dart';
import 'package:houser/models/Image.dart' as apiImage;
import 'package:houser/services/api_client.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/widgets/WG_snackbars.dart';

class WGAlbumSlider extends StatefulWidget {

  List<apiImage.Image> images;
  final ApiService _apiService = ApiService();
  Function() onUpload;

  WGAlbumSlider(this.images, this.onUpload, {Key? key}) : super(key: key);

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

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: images.length+1,
      itemBuilder: (context, index)
      {
        if(index == 0) return newPhotoCard!;
        return photoCard(images[index-1].id);
      }
    );
  }

  Widget photoCard(int id)
  {
    var deviceHeight = MediaQuery.of(context).size.height;
    double imageHeight = deviceHeight * 0.25;

    return Stack(
      children: [
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
                child: networkImage(id),
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
                      splashColor: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {},
                    )
                ),
              ),
            )
        )
      ],
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

  Future uploadImage() async
  {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      print('Selected '+ file.path);
      try{
        ApiResponse postResult = await widget._apiService.PostImage(file.path).timeout(const Duration(seconds: 5));
        if(postResult.statusCode.isSuccessStatusCode)
        {
          setState(() {
            widget.onUpload();
          });
        }else{
          ScaffoldMessenger.of(context).showSnackBar(failedFileUpload);
        }
      }on SocketException {
        ScaffoldMessenger.of(context).showSnackBar(noConnectionSnackbar);
      } on TimeoutException {
        ScaffoldMessenger.of(context).showSnackBar(serverErrorSnackbar);
      } on Exception {
        ScaffoldMessenger.of(context).showSnackBar(failedFileUpload);
      }

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

}
