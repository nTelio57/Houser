import 'package:flutter/material.dart';
import 'package:houser/models/widget_data/multi_button_selection.dart';
import 'package:houser/widgets/WG_slider.dart';
import 'package:houser/widgets/WG_multi_button.dart';

class PersonalDetailsSecondaryInfo extends StatefulWidget {
  const PersonalDetailsSecondaryInfo({Key? key}) : super(key: key);

  @override
  _PersonalDetailsSecondaryInfoState createState() => _PersonalDetailsSecondaryInfoState();
}

class _PersonalDetailsSecondaryInfoState extends State<PersonalDetailsSecondaryInfo> {

  List<MultiButtonSelection> studySelections = [MultiButtonSelection('Studijuoju', const Icon(Icons.school)),  MultiButtonSelection('Nestudijuoju', const Icon(Icons.home))];
  List<MultiButtonSelection> workSelections = [MultiButtonSelection('Nedirbu', const Icon(Icons.work_off)), MultiButtonSelection('Dirbu', const Icon(Icons.work))];
  List<MultiButtonSelection> smokeSelections = [MultiButtonSelection('Nerūkau', const Icon(Icons.smoke_free)), MultiButtonSelection('Rūkau', const Icon(Icons.smoking_rooms))];

  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body()
  {
    return Column(
      children: [
        animalCountRow(),
        WGSlider(min: 0, max: 5, canBeMoreThanMax: true),
        WGMultiButton(selections: studySelections),
        WGMultiButton(selections: workSelections),
        WGMultiButton(selections: smokeSelections),
        const SizedBox(height: 50,),
      ],
    );
  }

  Widget animalCountRow()
  {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          const Icon(Icons.pets, color:  Color.fromRGBO(0, 153, 204, 1)),
          const SizedBox(width: 8,),
          const Text(
            'Kiek turite gyvūnų:',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromRGBO(0, 153, 204, 1)
            ),
          ),
          Expanded(child: Container()),
          //animalCountTextField(),
        ],
      ),
    );
  }

  Widget animalCountTextField()
  {
    return const SizedBox(
      width: 75,
      child: TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
      ),
    );
  }

}
