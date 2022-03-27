import 'package:flutter/material.dart';
import 'package:houser/models/widget_data/multi_button_selection.dart';
import 'package:houser/widgets/WG_multi_button.dart';


class PersonalDetailsThirdInfo extends StatefulWidget {
  const PersonalDetailsThirdInfo({Key? key}) : super(key: key);

  @override
  _PersonalDetailsThirdInfoState createState() => _PersonalDetailsThirdInfoState();
}

class _PersonalDetailsThirdInfoState extends State<PersonalDetailsThirdInfo> {

  List<MultiButtonSelection> guestCountSelections = [MultiButtonSelection('0-1', null), MultiButtonSelection('2-3', null), MultiButtonSelection('4-5', null), MultiButtonSelection('6-7', null), MultiButtonSelection('>8', null)];
  List<MultiButtonSelection> partyCountSelections = [MultiButtonSelection('0-1', null), MultiButtonSelection('2', null), MultiButtonSelection('3', null), MultiButtonSelection('4', null), MultiButtonSelection('>5', null)];
  List<MultiButtonSelection> sleepTimeSelections = [MultiButtonSelection('Vyturys', const Icon(Icons.wb_sunny)), MultiButtonSelection('Nei vienas', const Icon(Icons.compare_arrows)), MultiButtonSelection('Pelėda', const Icon(Icons.nights_stay))];
  List<String> hours =  ['12h', '13h', '14h', '15h', '16h', '17h', '18h', '19h', '20h', '21h', '22h', '23h', '24h', '00h', '01h', '02h', '03h', '04h', '05h', '06h', '07h', '08h', '09h', '10h' , '11h',];

  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body()
  {
    return Column(
      children: [
        label('Kokiomis valandomis dažniausiai miegate:'),
        WGMultiButton(selections: sleepTimeSelections),
        label('Kiek kartų į mėnesį lankysis svečiai:'),
        WGMultiButton(selections: guestCountSelections),
        label('Kiek kartų į mėnesį planuojate turėti vakarėlių:'),
        WGMultiButton(selections: partyCountSelections),
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
