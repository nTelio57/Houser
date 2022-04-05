import 'package:flutter/material.dart';
import 'package:houser/enums/BedType.dart';
import 'package:houser/extensions/int_extensions.dart';
import 'package:houser/models/CurrentLogin.dart';
import 'package:houser/models/Offer.dart';
import 'package:houser/models/widget_data/multi_button_selection.dart';
import 'package:houser/services/api_client.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/widgets/WG_multi_button.dart';
import 'package:houser/widgets/WG_snackbars.dart';
import 'package:houser/widgets/WG_toggle_icon_button.dart';
import 'package:intl/intl.dart';

class OfferFormView extends StatefulWidget {

  final ApiService _apiService = ApiService();

  List<MultiButtonSelection> bedTypeSelections =
  [
    MultiButtonSelection('Nėra', null),
    MultiButtonSelection('Viengulė', null),
    MultiButtonSelection('Dvigulė', null),
    MultiButtonSelection('Sofa', null)
  ];
  DateTime? _dateFrom;
  DateTime? _dateTo;
  final TextEditingController _dateFromText = TextEditingController();
  final TextEditingController _dateToText = TextEditingController();

  final TextEditingController _titleText = TextEditingController();
  final TextEditingController _cityText = TextEditingController();
  final TextEditingController _addressText = TextEditingController();
  final TextEditingController _priceText = TextEditingController();
  final TextEditingController _areaText = TextEditingController();
  final TextEditingController _freeRoomText = TextEditingController();
  final TextEditingController _totalRoomText = TextEditingController();
  final TextEditingController _bedCountText = TextEditingController();

  WGToggleIconButton smokingRuleButton = WGToggleIconButton(icon: Icons.smoking_rooms);
  WGToggleIconButton animalRuleButton = WGToggleIconButton(icon: Icons.pets);
  WGMultiButton? bedTypeButton;

  WGToggleIconButton accommodationTv = WGToggleIconButton(icon: Icons.tv);
  WGToggleIconButton accommodationAc = WGToggleIconButton(icon: Icons.air);
  WGToggleIconButton accommodationWifi = WGToggleIconButton(icon: Icons.wifi);
  WGToggleIconButton accommodationParking = WGToggleIconButton(icon: Icons.local_parking_outlined);
  WGToggleIconButton accommodationBalcony = WGToggleIconButton(icon: Icons.balcony_outlined);
  WGToggleIconButton accommodationDisability = WGToggleIconButton(icon: Icons.accessible_outlined);

  bool isEditingMode = false;
  Offer? offerToEdit;

  OfferFormView(
  {
    Key? key,
    this.isEditingMode = false,
    this.offerToEdit
  }
  ) : super(key: key)
  {
    bedTypeButton = WGMultiButton(selections: bedTypeSelections);
  }

  @override
  _OfferFormViewState createState() => _OfferFormViewState();
}

class _OfferFormViewState extends State<OfferFormView> {

  final _formKey = GlobalKey<FormState>();
  bool editInitialized = false;

  @override
  Widget build(BuildContext context) {
    if(widget.isEditingMode)
      {
        if(widget.offerToEdit == null) {
          throw Exception('If editing mode = true, offerToEdit can\'t be null');
        }
        if(!editInitialized){
          setupForEditing(widget.offerToEdit!);
          editInitialized = true;
        }
      }

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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label('Pagrindiniai duomenys'),
              panel(
                children: [
                  textField('Pavadinimas', widget._titleText, titleValidator, icon: Icons.title, maxLength: 50),
                  textField('Miestas', widget._cityText, basicFieldValidator, icon: Icons.location_city),
                  textField('Adresas', widget._addressText, basicFieldValidator, icon: Icons.home),
                  textField('Kaina', widget._priceText, basicFieldValidator, icon: Icons.euro, keyboardType: TextInputType.number),
                  textField('Plotas', widget._areaText, noValidation, icon: Icons.square_foot, keyboardType: TextInputType.number, helperText: 'Neprivaloma'),
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
                  textField('Lovų skaičius', widget._bedCountText, noValidation, icon: Icons.bed, keyboardType: TextInputType.number, helperText: 'Neprivaloma'),
                  bedTypes(),
                  accommodation(),
                ],
              ),
              button(
                widget.isEditingMode ? 'Baigti redaguoti' : 'Paskelbti'
              )
            ],
          ),
        ),
      ),
    );
  }

  void setupForEditing(Offer offer)
  {
    widget._dateTo = offer.availableTo;
    widget._dateToText.text = dateToString(offer.availableTo);
    widget._dateFrom = offer.availableFrom;
    widget._dateFromText.text = dateToString(offer.availableFrom);

    widget._titleText.text = offer.title;
    widget._cityText.text  = offer.city;
    widget._addressText.text  = offer.address;
    widget._priceText.text  = offer.monthlyPrice.toString();
    widget._areaText.text  = offer.area.toString();
    widget._freeRoomText.text  = offer.freeRoomCount.toString();
    widget._totalRoomText.text  = offer.totalRoomCount.toString();
    widget._bedCountText.text  = offer.bedCount.toString();

    widget.smokingRuleButton.isEnabled = offer.ruleSmoking;
    widget.animalRuleButton.isEnabled = offer.ruleAnimals;
    widget.bedTypeButton!.isButtonSelected = BedType.values.map((e) => e.index == offer.bedType.index).toList();

    widget.accommodationTv.isEnabled = offer.accommodationTv;
    widget.accommodationAc.isEnabled = offer.accommodationAc;
    widget.accommodationWifi.isEnabled = offer.accommodationWifi;
    widget.accommodationParking.isEnabled = offer.accommodationParking;
    widget.accommodationBalcony.isEnabled = offer.accommodationBalcony;
    widget.accommodationDisability.isEnabled = offer.accommodationDisability;
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
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: widget.bedTypeButton!,
    );
  }

  Widget accommodation()
  {
    return Container(
      padding: const EdgeInsets.only(top: 7, bottom: 14),
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

  Widget roomCount()
  {
    return Container(
      padding: const EdgeInsets.only(top: 7, bottom: 7),
      child: Row(
        children: [
          textField('Laisvų', widget._freeRoomText, freeRoomCountValidator, keyboardType: TextInputType.number, icon: Icons.meeting_room_outlined),
          const SizedBox(width: 16),
          textField('Iš viso', widget._totalRoomText, totalRoomCountValidator, keyboardType: TextInputType.number, icon: Icons.home_outlined),
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
    var firstDate = DateTime.now();
    var lastDate = DateTime(firstDate.year + 100);

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
                hintText: 'MM/dd/yyyy',
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

  Widget button(String text)
  {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        height: 90,
        width: double.infinity,
        child: TextButton(
          onPressed: () async {
            if(!_formKey.currentState!.validate()) {
              return;
            }
            if(widget.isEditingMode) {
              await updateOffer();
            } else {
              await uploadOffer();
            }
          },
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

  Future updateOffer() async
  {
    var newOffer = getOfferByForm(replacer: widget.offerToEdit);

    var result = await widget._apiService.UpdateOfer(widget.offerToEdit!.id, newOffer);
    if(result)
    {
      Navigator.pop(context);
    }
  }

  Future uploadOffer() async
  {
    var newOffer = getOfferByForm();

    ApiResponse result = await widget._apiService.PostOffer(newOffer);
    if(result.statusCode.isSuccessStatusCode)
      {
        Navigator.pop(context);
      }
  }

  Offer getOfferByForm({Offer? replacer})
  {
    Offer newOffer;
    if(replacer != null)
      {
        newOffer = replacer;
      }
    else
      {
        newOffer = Offer(title: widget._titleText.text);
      }

    newOffer.ownerId = CurrentLogin().user!.id;
    newOffer.city = widget._cityText.text;
    newOffer.address = widget._addressText.text;
    newOffer.monthlyPrice = double.parse(widget._priceText.text);
    newOffer.area = double.tryParse(widget._areaText.text);
    newOffer.availableFrom =DateFormat('MM/dd/yyyy').parse(widget._dateFromText.text);
    newOffer.availableTo = DateFormat('MM/dd/yyyy').parse(widget._dateToText.text);
    newOffer.ruleSmoking = widget.smokingRuleButton.isEnabled;
    newOffer.ruleAnimals = widget.animalRuleButton.isEnabled;
    newOffer.freeRoomCount = int.parse(widget._freeRoomText.text);
    newOffer.totalRoomCount = int.parse(widget._totalRoomText.text);
    newOffer.bedCount = int.tryParse(widget._bedCountText.text);
    newOffer.bedType = BedType.values[widget.bedTypeButton!.isButtonSelected.indexOf(true)];

    newOffer.accommodationTv = widget.accommodationTv.isEnabled;
    newOffer.accommodationAc = widget.accommodationAc.isEnabled;
    newOffer.accommodationWifi = widget.accommodationWifi.isEnabled;
    newOffer.accommodationParking = widget.accommodationParking.isEnabled;
    newOffer.accommodationBalcony = widget.accommodationBalcony.isEnabled;
    newOffer.accommodationDisability = widget.accommodationDisability.isEnabled;

    //empty values
    newOffer.area ??= 0;
    newOffer.bedCount ??= 0;

    return newOffer;
  }

  String dateToString(DateTime dateTime)
  {
    return DateFormat('MM/dd/yyyy').format(dateTime);
  }

  String? titleValidator(String? value){
    if(value == null || value.isEmpty)
    {
      ScaffoldMessenger.of(context).showSnackBar(validationFailed);
      return 'Įveskite skelbimo pavadinimą';
    }
    if(value.length > 50)
    {
      ScaffoldMessenger.of(context).showSnackBar(validationFailed);
      return 'Neviršykite 50 simbolių';
    }
    return null;
  }

  String? basicFieldValidator(String? value){
    if(value == null || value.isEmpty)
    {
      ScaffoldMessenger.of(context).showSnackBar(validationFailed);
      return 'Įveskite reikšmę';
    }
    return null;
  }

  String? freeRoomCountValidator(String? value){
    if(value == null || value.isEmpty)
    {
      ScaffoldMessenger.of(context).showSnackBar(validationFailed);
      return 'Įveskite reikšmę';
    }
    if(int.parse(value) > int.parse(widget._totalRoomText.text))
    {
      ScaffoldMessenger.of(context).showSnackBar(validationFailed);
      return 'Bloga reikšmė';
    }
    return null;
  }

  String? totalRoomCountValidator(String? value){
    if(value == null || value.isEmpty)
    {
      ScaffoldMessenger.of(context).showSnackBar(validationFailed);
      return 'Įveskite reikšmę';
    }
    return null;
  }

  String? noValidation(String? value){
    return null;
  }

  String? dateFromValidator(String? value)
  {
    if(value == null || value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(validationFailed);
      return 'Įveskite datą';
    }
    DateTime? dateFrom, dateTo;
    try{
      dateFrom = DateFormat('MM/dd/yyyy').parse(widget._dateFromText.text);
    } on FormatException{
      ScaffoldMessenger.of(context).showSnackBar(validationFailed);
      return 'Įveskite datą';
    }

    try{
      dateTo = DateFormat('MM/dd/yyyy').parse(widget._dateToText.text);
    } on FormatException{
      dateTo = null;
    }

    if(dateTo == null || dateFrom.isAfter(dateTo) || dateFrom.isAtSameMomentAs(dateTo)) {
      ScaffoldMessenger.of(context).showSnackBar(validationFailed);
      return 'Klaidingas laikotarpis';
    }
    return null;
  }

  String? dateToValidator(String? value)
  {
    if(value == null || value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(validationFailed);
      return 'Įveskite datą';
    }
    try{
      DateFormat('MM/dd/yyyy').parse(widget._dateToText.text);
    } on FormatException{
      ScaffoldMessenger.of(context).showSnackBar(validationFailed);
      return 'Įveskite datą';
    }
    return null;
  }

}
