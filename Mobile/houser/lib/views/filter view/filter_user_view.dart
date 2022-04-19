import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:houser/models/widget_data/multi_button_selection.dart';
import 'package:houser/widgets/WG_multi_button.dart';
import 'package:houser/widgets/WG_slider.dart';

// ignore: must_be_immutable
class FilterUserView extends StatefulWidget {

  final TextEditingController _ageFromText = TextEditingController();
  final TextEditingController _ageToText = TextEditingController();

  WGSlider animalCountSlider = WGSlider(min: 0, max: 5, canBeMoreThanMax: true);
  WGSlider guestCountSlider = WGSlider(min: 0, max: 10, canBeMoreThanMax: true);
  WGSlider partyCountSlider = WGSlider(min: 0, max: 5, canBeMoreThanMax: true);

  final List<MultiButtonSelection> _sexSelections = [MultiButtonSelection('Vyras', const Icon(Icons.male)), MultiButtonSelection('Moteris', const Icon(Icons.female)), MultiButtonSelection('Kita', const Icon(Icons.transgender))];
  final List<MultiButtonSelection> _sleepTimeSelections = [MultiButtonSelection('Vyturys', const Icon(Icons.wb_sunny)), MultiButtonSelection('Pelėda', const Icon(Icons.nights_stay))];
  final List<MultiButtonSelection> _studySelections = [ MultiButtonSelection('Nestudijuoja', const Icon(Icons.home)), MultiButtonSelection('Studijuoja', const Icon(Icons.school))];
  final List<MultiButtonSelection> _workSelections = [MultiButtonSelection('Nedirba', const Icon(Icons.work_off)), MultiButtonSelection('Dirba', const Icon(Icons.work))];
  final List<MultiButtonSelection> _smokeSelections = [MultiButtonSelection('Nerūko', const Icon(Icons.smoke_free)), MultiButtonSelection('Rūko', const Icon(Icons.smoking_rooms))];

  WGMultiButton? sexSelectionButtons;
  WGMultiButton? sleepButtons;
  WGMultiButton? studyButtons;
  WGMultiButton? workButtons;
  WGMultiButton? smokeButtons;

  FilterUserView({Key? key}) : super(key: key){
    sexSelectionButtons = WGMultiButton(selections: _sexSelections);
    sleepButtons = WGMultiButton(selections: _sleepTimeSelections);
    studyButtons = WGMultiButton(selections: _studySelections);
    workButtons = WGMultiButton(selections: _workSelections);
    smokeButtons = WGMultiButton(selections: _smokeSelections);
  }

  @override
  _FilterUserViewState createState() => _FilterUserViewState();
}

class _FilterUserViewState extends State<FilterUserView> {

  @override
  void initState() {
    super.initState();
    widget.animalCountSlider.onValueChange = refresh;
    widget.guestCountSlider.onValueChange = refresh;
    widget.partyCountSlider.onValueChange = refresh;
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body()
  {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),

      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label('Amžius'),
            ageRangeFields(),
            widget.sexSelectionButtons!,
            sliderValueRow('Gyvūnų skaičius:',Icons.pets, widget.animalCountSlider),
            widget.animalCountSlider,
            sliderValueRow('Svečių dažnumas:',Icons.groups, widget.guestCountSlider),
            widget.guestCountSlider,
            sliderValueRow('Vakarėlių dažnumas:',Icons.celebration, widget.partyCountSlider),
            widget.partyCountSlider,
            widget.studyButtons!,
            widget.workButtons!,
            widget.smokeButtons!,
            widget.sleepButtons!,
          ],
        ),
      ),
    );
  }

  Widget ageRangeFields()
  {
    return Container(
      padding: const EdgeInsets.only(top: 7, bottom: 7),
      child: Row(
        children: [
          textField('Nuo', widget._ageFromText, noValidation, keyboardType: TextInputType.number),
          const SizedBox(width: 16),
          textField('Iki', widget._ageToText, noValidation, keyboardType: TextInputType.number),
        ],
      ),
    );
  }

  Widget textField(String label, TextEditingController controller, Function(String?) validator, {IconData? icon, TextInputType keyboardType = TextInputType.text, String helperText = '', int? maxLength})
  {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.only(top: 7, bottom: 7),
        child: TextFormField(
          keyboardType: keyboardType,
          controller: controller,
          maxLength: maxLength,
          validator: (value){
            return validator(value);
          },
          decoration: InputDecoration(
              labelText: label,
              helperText: helperText,
              prefixIcon: icon != null ? Icon(icon) : null,
              border: const OutlineInputBorder()
          ),
        ),
      ),
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

  Widget label(String label)
  {
    return Container(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor
        ),
      ),
    );
  }

  String? noValidation(String? value){
    return null;
  }

  void refresh(){
    setState(() {

    });
  }
}
