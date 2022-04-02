import 'package:flutter/material.dart';
import 'package:houser/enums/BedType.dart';
import 'package:houser/extensions/int_extensions.dart';
import 'package:houser/models/CurrentLogin.dart';
import 'package:houser/models/Offer.dart';
import 'package:houser/models/widget_data/multi_button_selection.dart';
import 'package:houser/services/api_client.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/widgets/WG_multi_button.dart';
import 'package:houser/widgets/WG_toggle_icon_button.dart';
import 'package:intl/intl.dart';

class NewOfferView extends StatefulWidget {

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

  NewOfferView({Key? key}) : super(key: key)
  {
    bedTypeButton = WGMultiButton(selections: bedTypeSelections);
  }

  @override
  _NewOfferViewState createState() => _NewOfferViewState();
}

class _NewOfferViewState extends State<NewOfferView> {

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
                textField('Pavadinimas', widget._titleText, icon: Icons.title),
                textField('Miestas', widget._cityText, icon: Icons.location_city),
                textField('Adresas', widget._addressText, icon: Icons.home),
                textField('Kaina', widget._priceText, icon: Icons.euro, keyboardType: TextInputType.number),
                textField('Plotas', widget._areaText, icon: Icons.square_foot, keyboardType: TextInputType.number),
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
                textField('Lovų skaičius', widget._bedCountText, icon: Icons.bed, keyboardType: TextInputType.number),
                bedTypes(),
                accommodation(),
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
          dateField(widget._dateFrom, widget._dateFromText, 'Nuo', Icons.today),
          const SizedBox(width: 16),
          dateField(widget._dateTo, widget._dateToText, 'Iki', Icons.event),
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
          textField('Laisvų', widget._freeRoomText, keyboardType: TextInputType.number, icon: Icons.meeting_room_outlined),
          const SizedBox(width: 16),
          textField('Iš viso', widget._totalRoomText, keyboardType: TextInputType.number, icon: Icons.home_outlined),
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

  Widget textField(String label, TextEditingController controller, {IconData? icon, TextInputType keyboardType = TextInputType.text})
  {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.only(top: 7, bottom: 7),
        child: TextField(
          keyboardType: keyboardType,
          controller: controller,
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
          onPressed: () async {
            await uploadOffer();
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

  Future uploadOffer() async{
    String title = widget._titleText.text;
    String address = widget._addressText.text;
    double price = double.parse(widget._priceText.text);
    double area = double.parse(widget._areaText.text);
    DateTime dateFrom = DateFormat('dd/MM/yyyy').parse(widget._dateFromText.text);
    DateTime dateTo = DateFormat('dd/MM/yyyy').parse(widget._dateToText.text);

    bool ruleSmoking = widget.smokingRuleButton.isEnabled;
    bool ruleAnimal = widget.animalRuleButton.isEnabled;

    int freeRoomCount = int.parse(widget._freeRoomText.text);
    int totalRoomCount = int.parse(widget._totalRoomText.text);
    int bedCount = int.parse(widget._bedCountText.text);
    BedType bedType = BedType.values[widget.bedTypeButton!.isButtonSelected.indexOf(true)];

    bool accommodationTv = widget.accommodationTv.isEnabled;
    bool accommodationAc = widget.accommodationAc.isEnabled;
    bool accommodationWifi = widget.accommodationWifi.isEnabled;
    bool accommodationParking = widget.accommodationParking.isEnabled;
    bool accommodationBalcony = widget.accommodationBalcony.isEnabled;
    bool accommodationDisability = widget.accommodationDisability.isEnabled;

    Offer newOffer = Offer(title: title);
    newOffer.ownerId = CurrentLogin().user!.id;
    newOffer.city = widget._cityText.text;
    newOffer.address = address;
    newOffer.monthlyPrice = price;
    newOffer.area = area;
    newOffer.availableFrom = dateFrom;
    newOffer.availableTo = dateTo;
    newOffer.ruleSmoking = ruleSmoking;
    newOffer.ruleAnimals = ruleAnimal;
    newOffer.freeRoomCount = freeRoomCount;
    newOffer.totalRoomCount = totalRoomCount;
    newOffer.bedCount = bedCount;
    newOffer.bedType = bedType;

    newOffer.accommodationTv = accommodationTv;
    newOffer.accommodationAc = accommodationAc;
    newOffer.accommodationWifi = accommodationWifi;
    newOffer.accommodationParking = accommodationParking;
    newOffer.accommodationBalcony = accommodationBalcony;
    newOffer.accommodationDisability = accommodationDisability;

    ApiResponse result = await widget._apiService.PostOffer(newOffer);
    if(result.statusCode.isSuccessStatusCode)
      {
        Navigator.pop(context);
      }
  }

  String dateToString(DateTime dateTime)
  {
    return DateFormat('MM/dd/yyyy').format(dateTime);
  }

}
