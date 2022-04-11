import 'package:flutter/material.dart';
import 'package:houser/models/widget_data/multi_button_selection.dart';
import 'package:houser/widgets/WG_multi_button.dart';

// ignore: must_be_immutable
class PersonalDetailsThirdInfo extends StatefulWidget {

  final List<MultiButtonSelection> _sleepTimeSelections = [MultiButtonSelection('Vyturys', const Icon(Icons.wb_sunny)), MultiButtonSelection('Nei vienas', const Icon(Icons.compare_arrows)), MultiButtonSelection('Pelėda', const Icon(Icons.nights_stay))];
  final List<MultiButtonSelection> _studySelections = [ MultiButtonSelection('Nestudijuoju', const Icon(Icons.home)), MultiButtonSelection('Studijuoju', const Icon(Icons.school))];
  final List<MultiButtonSelection> _workSelections = [MultiButtonSelection('Nedirbu', const Icon(Icons.work_off)), MultiButtonSelection('Dirbu', const Icon(Icons.work))];
  final List<MultiButtonSelection> _smokeSelections = [MultiButtonSelection('Nerūkau', const Icon(Icons.smoke_free)), MultiButtonSelection('Rūkau', const Icon(Icons.smoking_rooms))];

  WGMultiButton? sleepButtons;
  WGMultiButton? studyButtons;
  WGMultiButton? workButtons;
  WGMultiButton? smokeButtons;

  PersonalDetailsThirdInfo({Key? key}) : super(key: key){
    sleepButtons = WGMultiButton(selections: _sleepTimeSelections);
    studyButtons = WGMultiButton(selections: _studySelections);
    workButtons = WGMultiButton(selections: _workSelections);
    smokeButtons = WGMultiButton(selections: _smokeSelections);
  }

  @override
  _PersonalDetailsThirdInfoState createState() => _PersonalDetailsThirdInfoState();
}

class _PersonalDetailsThirdInfoState extends State<PersonalDetailsThirdInfo> {

  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body()
  {
    return Column(
      children: [
        label('Kuriam tipui prisiskirtumėte save:'),
        widget.sleepButtons!,
        label('Informacija apie jus:'),
        widget.studyButtons!,
        widget.workButtons!,
        widget.smokeButtons!,
      ],
    );
  }

  Widget label(String label)
  {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        label,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: 16,
          color: Color.fromRGBO(0, 153, 204, 1),
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}
