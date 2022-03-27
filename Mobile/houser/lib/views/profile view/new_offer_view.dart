import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:houser/models/widget_data/multi_button_selection.dart';
import 'package:houser/widgets/WG_multi_button.dart';
import 'package:houser/widgets/WG_toggle_icon_button.dart';
import 'package:intl/intl.dart';

class NewOfferView extends StatefulWidget {
  const NewOfferView({Key? key}) : super(key: key);

  @override
  _NewOfferViewState createState() => _NewOfferViewState();
}

class _NewOfferViewState extends State<NewOfferView> {

  DateTime? _dateFrom;
  DateTime? _dateTo;
  final TextEditingController _dateFromText = TextEditingController();
  final TextEditingController _dateToText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: body(),
    );
  }

  Widget body()
  {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label('Pagrindiniai duomenys'),
            panel(
              children: [

                textField('Adresas', icon: Icons.home),
                textField('Kaina', icon: Icons.euro, keyboardType: TextInputType.number),
                textField('Plotas', icon: Icons.square_foot, keyboardType: TextInputType.number),
                durationDates(),
              ],
            ),
            label('Buto taisyklės'),
            panel(
              children: [
                apartmentRules(),
              ],
            ),
            label('Kambariai'),
            panel(
              children: [
                roomCount(),
                textField('Lovų skaičius', icon: Icons.bed, keyboardType: TextInputType.number),
                bedTypes(),
                amenities(),
              ],
            ),
            button('Paskelbti')
          ],
        ),
      ),
    );
  }

  Widget label(String label)
  {
    return Container(
      padding: EdgeInsets.only(bottom: 8, top: 16),
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

  Widget panel({required List<Widget> children})
  {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white
      ),
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget bedTypes()
  {
    MultiButtonSelection noBed = MultiButtonSelection('Nėra', null);
    MultiButtonSelection singleBed = MultiButtonSelection('Viengulė', null);
    MultiButtonSelection doubleBed = MultiButtonSelection('Dvigulė', null);
    MultiButtonSelection sofa = MultiButtonSelection('Sofa', null);

    List<MultiButtonSelection> selections =
    [
      noBed,
      singleBed,
      doubleBed,
      sofa
    ];

    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: WGMultiButton(selections: selections),
    );
  }

  Widget amenities()
  {
    return Container(
      padding: const EdgeInsets.only(top: 7, bottom: 14),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        alignment: WrapAlignment.spaceEvenly,
        children: [
          WGToggleIconButton(icon: Icons.tv),
          WGToggleIconButton(icon: Icons.air),
          WGToggleIconButton(icon: Icons.wifi),
          WGToggleIconButton(icon: Icons.local_parking_outlined),
          WGToggleIconButton(icon: Icons.balcony_outlined),
          WGToggleIconButton(icon: Icons.accessible_outlined),
        ],
      ),
    );
  }

  Widget durationDates()
  {
    return Container(
      padding: const EdgeInsets.only(top: 7, bottom: 7),
      child: Row(
        children: [
          dateField(_dateFrom, _dateFromText, 'Nuo', Icons.today),
          const SizedBox(width: 16),
          dateField(_dateTo, _dateToText, 'Iki', Icons.event),
        ],
      ),
    );
  }

  Widget roomCount()
  {
    return Container(
      padding: const EdgeInsets.only(top: 7, bottom: 7),
      child: Row(
        children: [
          textField('Laisvų', keyboardType: TextInputType.number, icon: Icons.meeting_room_outlined),
          const SizedBox(width: 16),
          textField('Iš viso', keyboardType: TextInputType.number, icon: Icons.home_outlined),
        ],
      ),
    );
  }

  Widget apartmentRules()
  {
    return Container(
      padding: const EdgeInsets.only(top: 7, bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WGToggleIconButton(icon: Icons.smoking_rooms),
          WGToggleIconButton(icon: Icons.pets),
        ],
      ),
    );
  }

  Widget textField(String label, {IconData? icon, TextInputType keyboardType = TextInputType.text})
  {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.only(top: 7, bottom: 7),
        child: TextField(
          keyboardType: keyboardType,
          decoration: InputDecoration(
              labelText: label,
              helperText: '',
              prefixIcon: icon != null ? Icon(icon) : null,
              border: const OutlineInputBorder()
          ),
        ),
      ),
    );
  }

  Widget dateField(DateTime? value, TextEditingController controller, String label, IconData icon)
  {
    var firstDate = DateTime.now();
    var lastDate = DateTime(firstDate.year + 100);

    return Flexible(
      child: Container(
        padding: const EdgeInsets.only(bottom: 7),
        child: GestureDetector(
          child: TextField(
            readOnly: true,
            controller: controller,
            decoration: InputDecoration(
                helperText: '',
                label: Text(label),
                hintText: 'mm/dd/yyyy',
                prefixIcon: Icon(icon),
                border: const OutlineInputBorder()
            ),
            onTap: () {
              showDatePicker(
                  context: context,
                  initialDate: value == null ? DateTime.now() : value!,
                  firstDate: firstDate,
                  lastDate: lastDate
              ).then((newValue) {
                setState(() {
                  if(newValue == null) return;
                  value = newValue;
                  controller.text = dateToString(newValue);
                });
              });
            },
          ),
        ),
      ),
    );
  }

  Widget button(String text)
  {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        height: 90,
        width: double.infinity,
        child: TextButton(
          onPressed: (){},
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor
          ),
          child: Text(
            text.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600
            ),
          ),
        ),
      ),
    );
  }

  String dateToString(DateTime dateTime)
  {
    return DateFormat('MM/dd/yyyy').format(dateTime);
  }

}
