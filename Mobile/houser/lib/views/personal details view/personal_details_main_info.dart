import 'package:flutter/material.dart';
import 'package:houser/widgets/WG_multi_button.dart';
import 'package:houser/models/language_bubble.dart';
import 'package:intl/intl.dart';

import '../../models/multi_button_selection.dart';

class PersonalDetailsMainInfo extends StatefulWidget {
  const PersonalDetailsMainInfo({Key? key}) : super(key: key);

  @override
  _PersonalDetailsMainInfoState createState() => _PersonalDetailsMainInfoState();
}

class _PersonalDetailsMainInfoState extends State<PersonalDetailsMainInfo> {

  DateTime? _birthDate;
  final TextEditingController _birthFieldText = TextEditingController();
  List<MultiButtonSelection> sexSelections = [MultiButtonSelection('Vyras', const Icon(Icons.male)), MultiButtonSelection('Moteris', const Icon(Icons.female)), MultiButtonSelection('Kita', const Icon(Icons.transgender))];

  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body()
  {
    return Column(
      children: [
        nameTextField(),
        birthDateField(),
        MultiButton(selections: sexSelections),
        //label('Kalbos'),
        //languagesContainer()
      ],
    );
  }

  Widget nameTextField()
  {
    return Container(
      padding: const EdgeInsets.only(top: 14, bottom: 7),
      child: const TextField(
        decoration: InputDecoration(
            labelText: 'Vardas',
            helperText: '',
            prefixIcon: Icon(Icons.account_circle),
            border: OutlineInputBorder()
        ),
      ),
    );
  }

  Widget label(String text)
  {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black54
        ),
      ),
    );
  }

  final List<bool> _isSexButtonSelected = [true, false, false];

  Widget sexButtons()
  {
    return Container(
      padding: const EdgeInsets.only(bottom: 14),
      child: ToggleButtons(
        isSelected: _isSexButtonSelected,
        color: Colors.black54,
        onPressed: (int index) {
          setState(() {
            for (int buttonIndex = 0; buttonIndex < _isSexButtonSelected.length; buttonIndex++) {
              if (buttonIndex == index) {
                _isSexButtonSelected[buttonIndex] = true;
              } else {
                _isSexButtonSelected[buttonIndex] = false;
              }
            }
          });
        },
        children: [
          SizedBox(
            width: (MediaQuery.of(context).size.width-64)/3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.male),
                SizedBox(width: 10),
                Text('Vyras'),
              ],
            )
          ),
          SizedBox(
              width: (MediaQuery.of(context).size.width-64)/3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.female),
                  SizedBox(width: 10),
                  Text('Moteris'),
                ],
              )
          ),
          SizedBox(
              width: (MediaQuery.of(context).size.width-64)/3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.transgender),
                  SizedBox(width: 10),
                  Text('Kita'),
                ],
              )
          ),
        ],
      ),
    );
  }

  Widget birthDateField()
  {
    return Container(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        child: TextField(
          readOnly: true,
          controller: _birthFieldText,
          decoration: const InputDecoration(
            helperText: '',
            label: Text('Gimimo data'),
            hintText: 'mm/dd/yyyy',
            prefixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder()
          ),
          onTap: () {
            showDatePicker(
                context: context,
                initialDate: _birthDate == null ? DateTime.now() : _birthDate!,
                firstDate: DateTime(1900),
                lastDate: DateTime.now()
            ).then((value) {
              setState(() {
                if(value == null) return;
                _birthDate = value;
                _birthFieldText.text = dateToString(value);
              });
            });
          },
        ),
      ),
    );
  }

  String dateToString(DateTime dateTime)
  {
    return DateFormat('MM/dd/yyyy').format(dateTime);
  }

  Widget languagesContainer()
  {
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      spacing: 12,
      runSpacing: 12,
      children: languageBubbles,
    );
  }

  List<Widget> languageBubbles = [
    LanguageBubble(language: 'LIETUVIŲ'),
    LanguageBubble(language: 'english'),
    LanguageBubble(language: 'Español'),
    LanguageBubble(language: 'latviešu'),
    LanguageBubble(language: 'Deutsch'),
    LanguageBubble(language: 'Français'),
    LanguageBubble(language: 'Italiano'),
    LanguageBubble(language: 'Eesti'),
    LanguageBubble(language: 'Русский'),
    LanguageBubble(language: 'polski'),
  ];

}
