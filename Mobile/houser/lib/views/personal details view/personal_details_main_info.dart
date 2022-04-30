import 'package:flutter/material.dart';
import 'package:houser/models/widget_data/multi_button_selection.dart';
import 'package:houser/widgets/WG_multi_button.dart';
import 'package:houser/models/widget_data/language_bubble.dart';
import 'package:intl/intl.dart';


class PersonalDetailsMainInfo extends StatefulWidget {

  final GlobalKey<FormState> formKey;

  final TextEditingController nameFieldText = TextEditingController();
  final TextEditingController birthFieldText = TextEditingController();
  DateTime? birthDate;
  List<MultiButtonSelection> sexSelections = [MultiButtonSelection('Vyras', const Icon(Icons.male)), MultiButtonSelection('Moteris', const Icon(Icons.female)), MultiButtonSelection('Kita', const Icon(Icons.transgender))];
  WGMultiButton? sexSelectionButtons;

  PersonalDetailsMainInfo(this.formKey, {Key? key}) : super(key: key){
    sexSelectionButtons = WGMultiButton(selections: sexSelections);
  }

  @override
  _PersonalDetailsMainInfoState createState() => _PersonalDetailsMainInfoState();
}

class _PersonalDetailsMainInfoState extends State<PersonalDetailsMainInfo> {


  List<MultiButtonSelection> sexSelections = [MultiButtonSelection('Vyras', const Icon(Icons.male)), MultiButtonSelection('Moteris', const Icon(Icons.female)), MultiButtonSelection('Kita', const Icon(Icons.transgender))];

  @override
  Widget build(BuildContext context) {
    return body();
  }

  String? nameValidator(String? value)
  {
    if(value == null || value.isEmpty)
    {
      return 'Įveskite vardą';
    }
    return null;
  }

  String? birthDateValidator(String? value)
  {
    if(value == null || value.isEmpty) {
      return 'Įveskite gimimo datą';
    }
    if(widget.birthDate == null) {
      return 'Įveskite gimimo datą';
    }
    var now = DateTime.now();
    var adultDateTime = DateTime(now.year - 18, now.month, now.day);
    if(widget.birthDate!.isAfter(adultDateTime)) {
      return 'Turite turėti 18 metų.';
    }
    if(widget.birthDate!.isAfter(DateTime.now()) || widget.birthDate!.isAtSameMomentAs(DateTime.now())) {
      return 'Įvesta netinkama data';
    }
    return null;
  }

  Widget body()
  {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          nameTextField(nameValidator, widget.nameFieldText),
          birthDateField(birthDateValidator),
          widget.sexSelectionButtons!,
          //label('Kalbos'),
          //languagesContainer()
        ],
      ),
    );
  }

  Widget nameTextField(Function(String?) validator, TextEditingController controller)
  {
    return Container(
      padding: const EdgeInsets.only(top: 14, bottom: 7),
      child: TextFormField(
        validator: (value){
          return validator(value);
        },
        controller: controller,
        decoration: const InputDecoration(
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

  Widget birthDateField(Function(String?) validator)
  {
    return Container(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        child: TextFormField(
          readOnly: true,
          controller: widget.birthFieldText,
          validator: (value){
            return validator(value);
          },
          decoration: const InputDecoration(
            helperText: '',
            label: Text('Gimimo data'),
            prefixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder()
          ),
          onTap: () {
            showDatePicker(
                context: context,
                initialDate: widget.birthDate == null ? DateTime.now() : widget.birthDate!,
                firstDate: DateTime(1900),
                lastDate: DateTime.now()
            ).then((value) {
              setState(() {
                if(value == null) return;
                widget.birthDate = value;
                widget.birthFieldText.text = dateToString(value);
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
