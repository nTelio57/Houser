import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:houser/models/CurrentLogin.dart';
import 'package:houser/models/Image.dart' as apiImage;

class WGAlbumSlider extends StatefulWidget {

  List<apiImage.Image> images;

  WGAlbumSlider(this.images, {Key? key}) : super(key: key);

  @override
  _WGAlbumSliderState createState() => _WGAlbumSliderState();
}

class _WGAlbumSliderState extends State<WGAlbumSlider> {

  Widget? errorCard, newPhotoCard;

  @override
  Widget build(BuildContext context) {
    errorCard = templateCard('Nepavyko užkrauti', Icons.error_outline);
    newPhotoCard = templateCard('Pridėti nuotrauką', Icons.add);

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

    return SizedBox(
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
    );
  }

  Widget networkImage(int id)
  {
    return CachedNetworkImage(
      imageUrl: 'https://10.0.2.2:5001/api/Image/$id',
      placeholder: (context, url) => loadingCard(),
      errorWidget: (context, url, error) => errorCard!,
      httpHeaders: {
        'Authorization': 'bearer ' + CurrentLogin().jwtToken,
      },
    );
  }

  Widget templateCard(String text, IconData icon)
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
