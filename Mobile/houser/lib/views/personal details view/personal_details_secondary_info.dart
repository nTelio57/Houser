import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:houser/enums/WGSliderStartingPoint.dart';
import 'package:houser/extensions/int_extensions.dart';
import 'package:houser/widgets/WG_slider.dart';

// ignore: must_be_immutable
class PersonalDetailsSecondaryInfo extends StatefulWidget {

  double animalCountSliderValue = 0;
  double guestCountSliderValue = 0;
  double partyCountSliderValue = 0;

  PersonalDetailsSecondaryInfo({Key? key}) : super(key: key);

  @override
  _PersonalDetailsSecondaryInfoState createState() => _PersonalDetailsSecondaryInfoState();
}

class _PersonalDetailsSecondaryInfoState extends State<PersonalDetailsSecondaryInfo> {

  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body()
  {
    return Column(
      children: [
        sliderValueRow('Kiek turite gyvūnų:',Icons.pets, widget.animalCountSliderValue.toInt().toString()),
        slider(0, 5, widget.animalCountSliderValue, true, WGSliderStartingPoint.start, refreshAnimalValue),
        sliderValueRow('Kiek kartų į mėnesį lankysis svečiai:', Icons.groups, widget.guestCountSliderValue.toInt().toString()),
        slider(0, 5, widget.guestCountSliderValue, true, WGSliderStartingPoint.start, refreshGuestValue, labelFormat: guestCountLabel),
        sliderValueRow('Kiek kartų į mėnesį planuojate turėti vakarėlių:', Icons.celebration, widget.partyCountSliderValue.toInt().toString()),
        slider(0, 5, widget.partyCountSliderValue, true, WGSliderStartingPoint.start, refreshPartyValue, labelFormat: partyCountLabel),

        const SizedBox(height: 50,),
      ],
    );
  }

  Widget slider(double min, double max, double? selectedValue, bool canBeMoreThanMax, WGSliderStartingPoint startingPoint, Function(double)? onValueChange, {String Function(int)? labelFormat})
  {
    return WGSlider(
      min: min,
      max: max,
      selectedValue: selectedValue ?? 0,
      canBeMoreThanMax: canBeMoreThanMax,
      startingPoint: startingPoint,
      onValueChange: onValueChange,
      labelFormat: labelFormat,
    );
  }

  String guestCountLabel(int value)
  {
    return value.guestCountToString;
  }

  String partyCountLabel(int value)
  {
    return value.partyCountToString;
  }

  void refreshAnimalValue(double value){
    setState(() {
      widget.animalCountSliderValue = value;
    });
  }

  void refreshGuestValue(double value){
    setState(() {
      widget.guestCountSliderValue = value;
    });
  }

  void refreshPartyValue(double value){
    setState(() {
      widget.partyCountSliderValue = value;
    });
  }

  Widget sliderValueRow(String label, IconData icon, String valueLabel)
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
              valueLabel,
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
