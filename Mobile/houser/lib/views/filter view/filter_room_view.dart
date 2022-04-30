import 'package:flutter/material.dart';
import 'package:houser/extensions/dateTime_extensions.dart';
import 'package:houser/models/Filter.dart';
import 'package:houser/models/RoomFilter.dart';
import 'package:houser/utils/current_login.dart';
import 'package:houser/widgets/WG_snackbars.dart';
import 'package:houser/widgets/WG_toggle_icon_button.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class FilterRoomView extends StatefulWidget {
  FilterRoomView({Key? key}) : super(key: key);

  DateTime? _dateFrom;
  DateTime? _dateTo;
  final TextEditingController _cityText = TextEditingController();
  final TextEditingController _priceText = TextEditingController();
  final TextEditingController _areaText = TextEditingController();
  final TextEditingController _freeRoomText = TextEditingController();
  final TextEditingController _bedCountText = TextEditingController();
  final TextEditingController _dateFromText = TextEditingController();
  final TextEditingController _dateToText = TextEditingController();

  WGToggleIconButton smokingRuleButton = WGToggleIconButton(icon: Icons.smoking_rooms);
  WGToggleIconButton animalRuleButton = WGToggleIconButton(icon: Icons.pets);

  WGToggleIconButton accommodationTv = WGToggleIconButton(icon: Icons.tv);
  WGToggleIconButton accommodationAc = WGToggleIconButton(icon: Icons.air);
  WGToggleIconButton accommodationWifi = WGToggleIconButton(icon: Icons.wifi);
  WGToggleIconButton accommodationParking = WGToggleIconButton(icon: Icons.local_parking_outlined);
  WGToggleIconButton accommodationBalcony = WGToggleIconButton(icon: Icons.balcony_outlined);
  WGToggleIconButton accommodationDisability = WGToggleIconButton(icon: Icons.accessible_outlined);

  @override
  _FilterUserViewState createState() => _FilterUserViewState();

  void setFormByFilter(RoomFilter filter)
  {
    _dateFrom = filter.availableFrom;
    _dateTo = filter.availableTo;
    _dateFromText.text = _dateFrom.dateToString();
    _dateToText.text = _dateTo.dateToString();
    _cityText.text = filter.city == null ? '' : filter.city!;
    _priceText.text = filter.monthlyPrice == null ? '' : filter.monthlyPrice!.toString();
    _areaText.text = filter.area == null ? '' : filter.area!.toString();
    _freeRoomText.text = filter.freeRoomCount == null ? '' : filter.freeRoomCount!.toString();
    _bedCountText.text = filter.bedCount == null ? '' : filter.bedCount!.toString();

    smokingRuleButton.isEnabled = filter.ruleSmoking == null ? false : filter.ruleSmoking!;
    animalRuleButton.isEnabled = filter.ruleAnimals == null ? false : filter.ruleAnimals!;

    accommodationTv.isEnabled = filter.accommodationTv == null ? false : filter.accommodationTv!;
    accommodationAc.isEnabled = filter.accommodationAc == null ? false : filter.accommodationAc!;
    accommodationWifi.isEnabled = filter.accommodationWifi == null ? false : filter.accommodationWifi!;
    accommodationParking.isEnabled = filter.accommodationParking == null ? false : filter.accommodationParking!;
    accommodationBalcony.isEnabled = filter.accommodationBalcony == null ? false : filter.accommodationBalcony!;
    accommodationDisability.isEnabled = filter.accommodationDisability == null ? false : filter.accommodationDisability!;
  }

  Filter getFilterByForm()
  {
    DateTime? dateFromTry, dateToTry;

    try{
      dateFromTry = DateFormat('MM/dd/yyyy').parse(_dateFromText.text);
    }catch (e){
      dateFromTry = null;
    }
    try{
      dateToTry = DateFormat('MM/dd/yyyy').parse(_dateToText.text);
    }catch (e){
      dateToTry = null;
    }

    return RoomFilter(
        0,
        CurrentLogin().user!.id,
        double.tryParse(_areaText.text),
        double.tryParse(_priceText.text),
        _cityText.text,
        dateFromTry,
        dateToTry,
        int.tryParse(_freeRoomText.text),
        int.tryParse(_bedCountText.text),
        smokingRuleButton.isEnabled,
        animalRuleButton.isEnabled,
        accommodationTv.isEnabled,
        accommodationWifi.isEnabled,
        accommodationAc.isEnabled,
        accommodationParking.isEnabled,
        accommodationBalcony.isEnabled,
        accommodationDisability.isEnabled
    );
  }
}

class _FilterUserViewState extends State<FilterRoomView> {
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
            label('Laikotarpis'),
            dateField(widget._dateFrom, widget._dateFromText, dateFromValidator, 'Nuo', Icons.today),
            dateField(widget._dateTo, widget._dateToText, dateToValidator, 'Iki', Icons.event),
            label('Papildoma informacija'),
            textField('Miestas', widget._cityText, noValidation, icon: Icons.location_city),
            textField('Kaina', widget._priceText, noValidation, icon: Icons.euro, keyboardType: TextInputType.number),
            //durationDates(),
            textField('Plotas', widget._areaText, noValidation, icon: Icons.square_foot, keyboardType: TextInputType.number),
            textField('Laisvų', widget._freeRoomText, noValidation, keyboardType: TextInputType.number, icon: Icons.meeting_room_outlined),
            textField('Lovų skaičius', widget._bedCountText, noValidation, icon: Icons.bed, keyboardType: TextInputType.number),
            label('Buto taisyklės'),
            apartmentRules(),
            label('Privalumai'),
            accommodation(),
          ],
        ),
      ),
    );
  }

  Widget durationDates()
  {
    return Container(
      padding: const EdgeInsets.only(top: 7, bottom: 7),
      child: Row(
        children: [
          dateField(widget._dateFrom, widget._dateFromText, dateFromValidator, 'Nuo', Icons.today),
          const SizedBox(width: 16),
          dateField(widget._dateTo, widget._dateToText, dateToValidator, 'Iki', Icons.event),
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
          widget.smokingRuleButton,
          widget.animalRuleButton,
        ],
      ),
    );
  }

  Widget accommodation()
  {
    return Container(
      padding: const EdgeInsets.only(top: 7, bottom: 14),
      width: double.infinity,
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        alignment: WrapAlignment.spaceEvenly,
        children: [
          widget.accommodationTv,
          widget.accommodationAc,
          widget.accommodationWifi,
          widget.accommodationParking,
          widget.accommodationBalcony,
          widget.accommodationDisability
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

  Widget dateField(DateTime? value, TextEditingController controller, Function(String?) validator, String label, IconData icon)
  {
    var firstDate = DateTime(1900);
    var lastDate = DateTime(2200);

    return Flexible(
      child: Container(
        padding: const EdgeInsets.only(bottom: 7),
        child: GestureDetector(
          child: TextFormField(
            readOnly: true,
            controller: controller,
            validator: (value){
              return validator(value);
            },
            decoration: InputDecoration(
                helperText: '',
                label: Text(label),
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
                if(newValue == null) return;
                value = newValue;
                controller.text = dateToString(newValue);
                setState(() {

                });
              });
            },
          ),
        ),
      ),
    );
  }

  String dateToString(DateTime dateTime)
  {
    return DateFormat('MM/dd/yyyy').format(dateTime);
  }

  String? noValidation(String? value){
    return null;
  }

  String? dateFromValidator(String? value)
  {
    DateTime? dateFrom, dateTo;
    try{
      dateFrom = DateFormat('MM/dd/yyyy').parse(widget._dateFromText.text);
    } on FormatException{
      dateFrom = null;
    }

    try{
      dateTo = DateFormat('MM/dd/yyyy').parse(widget._dateToText.text);
    } on FormatException{
      dateTo = null;
    }

    if(dateFrom != null && dateTo != null) {
      if(dateFrom.isAfter(dateTo) || dateFrom.isAtSameMomentAs(dateTo))
        {
          ScaffoldMessenger.of(context).showSnackBar(validationFailed);
          return 'Klaidingas laikotarpis';
        }
    }

    return null;
  }

  String? dateToValidator(String? value)
  {
    return null;
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
}
