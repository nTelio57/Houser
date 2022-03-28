import 'package:flutter/material.dart';

class WGAlbumSlider extends StatefulWidget {
  const WGAlbumSlider({Key? key}) : super(key: key);

  @override
  _WGAlbumSliderState createState() => _WGAlbumSliderState();
}

class _WGAlbumSliderState extends State<WGAlbumSlider> {
  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body()
  {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          newPhotoCard(),
          photoCard(),
          photoCard(),
          photoCard(),
          photoCard(),
        ],
      ),
    );
  }

  Widget photoCard()
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
                image: const DecorationImage(
                    fit: BoxFit.fitHeight,
                    alignment: FractionalOffset.center,
                    image: AssetImage('assets/images/prs_placeholder1.jpg')
                ),
              borderRadius: BorderRadius.circular(8)
            ),
          ),
        ),
      ),
    );
  }

  Widget newPhotoCard()
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
                  Icons.add,
                  color: Theme.of(context).primaryColor,
                  size: 40,
                ),
                Text(
                  'Pridėti nuotrauką',
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

}
