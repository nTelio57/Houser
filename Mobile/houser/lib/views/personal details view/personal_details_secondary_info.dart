import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:houser/widgets/WG_slider.dart';

// ignore: must_be_immutable
class PersonalDetailsSecondaryInfo extends StatefulWidget {

  WGSlider animalCountSlider = WGSlider(min: 0, max: 5, canBeMoreThanMax: true);
  WGSlider guestCountSlider = WGSlider(min: 0, max: 10, canBeMoreThanMax: true);
  WGSlider partyCountSlider = WGSlider(min: 0, max: 5, canBeMoreThanMax: true);

  PersonalDetailsSecondaryInfo({Key? key}) : super(key: key);

  @override
  _PersonalDetailsSecondaryInfoState createState() => _PersonalDetailsSecondaryInfoState();
}

class _PersonalDetailsSecondaryInfoState extends State<PersonalDetailsSecondaryInfo> {

  void refresh(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    widget.animalCountSlider.onValueChange = refresh;
    widget.guestCountSlider.onValueChange = refresh;
    widget.partyCountSlider.onValueChange = refresh;

    return body();
  }

  Widget body()
  {
    return Column(
      children: [
        sliderValueRow('Kiek turite gyvūnų:',Icons.pets, widget.animalCountSlider),
        widget.animalCountSlider,
        sliderValueRow('Kiek kartų į mėnesį lankysis svečiai:', Icons.groups, widget.guestCountSlider),
        widget.guestCountSlider,
        sliderValueRow('Kiek kartų į mėnesį planuojate turėti vakarėlių:', Icons.celebration, widget.partyCountSlider),
        widget.partyCountSlider,

        const SizedBox(height: 50,),
      ],
    );
  }

  Widget sliderValueRow(String label, IconData icon, WGSlider slider)
  {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(icon, color:  const Color.fromRGBO(0, 153, 204, 1)),
          const SizedBox(width: 8,),
          Expanded(
            flex: 3,
            child: AutoSizeText(
              label,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(0, 153, 204, 1)
              ),
            ),
          ),
          Expanded(child: Container()),
          Container(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              slider.label,
              style: const TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(0, 153, 204, 1),
                fontWeight: FontWeight.w700
              ),
            ),
          ),
        ],
      ),
    );
  }
}
