import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:houser/enums/BedType.dart';
import 'package:houser/extensions/int_extensions.dart';
import 'package:houser/models/Image.dart' as apiImage;
import 'package:houser/utils/current_login.dart';
import 'package:houser/models/Room.dart';
import 'package:houser/models/widget_data/multi_button_selection.dart';
import 'package:houser/services/api_client.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/widgets/WG_album_slider.dart';
import 'package:houser/widgets/WG_multi_button.dart';
import 'package:houser/widgets/WG_snackbars.dart';
import 'package:houser/widgets/WG_toggle_icon_button.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class RoomFormView extends StatefulWidget {

  final ApiService _apiService = ApiService();

  List<apiImage.Image> roomImages = [];
  List<apiImage.Image> imagesToDelete = [];

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
  Room? roomToEdit;

  RoomFormView(
  {
    Key? key,
    this.isEditingMode = false,
    this.roomToEdit
  }
  ) : super(key: key)
  {
    bedTypeButton = WGMultiButton(selections: bedTypeSelections);
    if(roomToEdit != null)
      {
        roomImages = roomToEdit!.images;
      }
  }

  @override
  _RoomFormViewState createState() => _RoomFormViewState();
}

class _RoomFormViewState extends State<RoomFormView> {

  final _formKey = GlobalKey<FormState>();
  bool editInitialized = false;
  bool _isLoginButtonEnabled = true;

  @override
  Widget build(BuildContext context) {
    if(widget.isEditingMode)
      {
        if(widget.roomToEdit == null) {
          throw Exception('If editing mode = true, roomToEdit can\'t be null');
        }
        if(!editInitialized){
          setupForEditing(widget.roomToEdit!);
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
                  textField('Adresas', widget._addressText, basicFieldValidator, icon: Icons.location_on_outlined),
                  textField('Kaina', widget._priceText, basicFieldValidator, icon: Icons.euro, keyboardType: TextInputType.number),
                  textField('Plotas', widget._areaText, noValidation, icon: Icons.square_foot, keyboardType: TextInputType.number, helperText: 'Neprivaloma'),
                  durationDates(),
                ],
              ),
              label('Nuotraukos'),
              panel(
                children: [
                  imagePicker()
                ]
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

  void setupForEditing(Room room)
  {
    widget._dateTo = room.availableTo;
    widget._dateToText.text = dateToString(room.availableTo);
    widget._dateFrom = room.availableFrom;
    widget._dateFromText.text = dateToString(room.availableFrom);

    widget._titleText.text = room.title;
    widget._cityText.text  = room.city;
    widget._addressText.text  = room.address;
    widget._priceText.text  = room.monthlyPrice.toString();
    widget._areaText.text  = room.area.toString();
    widget._freeRoomText.text  = room.freeRoomCount.toString();
    widget._totalRoomText.text  = room.totalRoomCount.toString();
    widget._bedCountText.text  = room.bedCount.toString();

    widget.smokingRuleButton.isEnabled = room.ruleSmoking;
    widget.animalRuleButton.isEnabled = room.ruleAnimals;
    widget.bedTypeButton!.isButtonSelected = BedType.values.map((e) => e.index == room.bedType.index).toList();

    widget.accommodationTv.isEnabled = room.accommodationTv;
    widget.accommodationAc.isEnabled = room.accommodationAc;
    widget.accommodationWifi.isEnabled = room.accommodationWifi;
    widget.accommodationParking.isEnabled = room.accommodationParking;
    widget.accommodationBalcony.isEnabled = room.accommodationBalcony;
    widget.accommodationDisability.isEnabled = room.accommodationDisability;
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
          onPressed: !_isLoginButtonEnabled ? null : () async {
            setState(() {
              _isLoginButtonEnabled = false;
            });

            if(!_formKey.currentState!.validate()) {
              _isLoginButtonEnabled = true;
              return;
            }
            if(widget.roomImages.isEmpty)
              {
                ScaffoldMessenger.of(context).showSnackBar(roomHasToHaveImages);
                _isLoginButtonEnabled = true;
                return;
              }

            if(widget.isEditingMode) {
              await updateRoom();
            } else {
              await uploadRoom();
            }

            setState(() {
              _isLoginButtonEnabled = true;
            });
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

  Future updateRoom() async
  {
    var newRoom = getRoomByForm();
    newRoom.images = widget.roomToEdit!.images;

    var result = await widget._apiService.UpdateOfer(widget.roomToEdit!.id, newRoom);
    if(!result)
    {
      return false;
    }

    for (var image in widget.roomImages) {
      if(image.id == 0) {
        image.roomId = widget.roomToEdit!.id;
        await widget._apiService.PostRoomImage(image.path, widget.roomToEdit!.id);
      }
    }

    for (var image in widget.imagesToDelete) {
      if(image.id != 0) {
        await widget._apiService.DeleteImage(image.id);
      }
    }

    var mainImage = widget.roomImages.firstWhere((image) => image.isMain);
    await widget._apiService.UpdateImage(mainImage.id, mainImage);

    Navigator.pop(context);
  }

  Future uploadRoom() async
  {
    var newRoom = getRoomByForm();

    ApiResponse roomPostResult = await widget._apiService.PostRoom(newRoom);
    if(!roomPostResult.statusCode.isSuccessStatusCode)
      {
        return false;
      }
    var roomResult = Room.fromJson(roomPostResult.body);

    var mainImage = widget.roomImages.firstWhere((image) => image.isMain);
    for (var image in widget.roomImages) {
      image.roomId = roomResult.id;
      var imageUploadResponse = await widget._apiService.PostRoomImage(image.path, roomResult.id);
      var uploadedImage = apiImage.Image.fromJson(imageUploadResponse.body);
      if(image.isMain)
        {
          mainImage.id = uploadedImage.id;
        }
    }

    await widget._apiService.UpdateImage(mainImage.id, mainImage);

    Navigator.pop(context);
  }

  Room getRoomByForm()
  {
    Room newRoom = Room(title: widget._titleText.text);
    newRoom.ownerId = CurrentLogin().user!.id;
    newRoom.city = widget._cityText.text;
    newRoom.address = widget._addressText.text;
    newRoom.monthlyPrice = double.parse(widget._priceText.text);
    newRoom.area = double.tryParse(widget._areaText.text);
    newRoom.availableFrom =DateFormat('MM/dd/yyyy').parse(widget._dateFromText.text);
    newRoom.availableTo = DateFormat('MM/dd/yyyy').parse(widget._dateToText.text);
    newRoom.ruleSmoking = widget.smokingRuleButton.isEnabled;
    newRoom.ruleAnimals = widget.animalRuleButton.isEnabled;
    newRoom.freeRoomCount = int.parse(widget._freeRoomText.text);
    newRoom.totalRoomCount = int.parse(widget._totalRoomText.text);
    newRoom.bedCount = int.tryParse(widget._bedCountText.text);
    newRoom.bedType = BedType.values[widget.bedTypeButton!.isButtonSelected.indexOf(true)];

    newRoom.accommodationTv = widget.accommodationTv.isEnabled;
    newRoom.accommodationAc = widget.accommodationAc.isEnabled;
    newRoom.accommodationWifi = widget.accommodationWifi.isEnabled;
    newRoom.accommodationParking = widget.accommodationParking.isEnabled;
    newRoom.accommodationBalcony = widget.accommodationBalcony.isEnabled;
    newRoom.accommodationDisability = widget.accommodationDisability.isEnabled;

    //empty values
    newRoom.area ??= 0;
    newRoom.bedCount ??= 0;

    return newRoom;
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

  Widget imagePicker()
  {
    return WGAlbumSlider(widget.roomImages.reversed.toList(), onImageUpload, onImageDelete, onImageSetAsMain);
  }

  Future onImageUpload(File file) async
  {
    var image = apiImage.Image(0, file.path, CurrentLogin().user!.id, null, false);
    if(widget.roomImages.isEmpty) {
      image.isMain = true;
    }

    widget.roomImages.add(image);
    setState(() {

    });
    return true;
  }

  Future onImageSetAsMain(apiImage.Image image) async
  {
    for(apiImage.Image i in widget.roomImages)
    {
      i.isMain = false;
      if(i == image)
        {
          i.isMain = true;
        }
    }
    setState(() {

    });
  }

  Future onImageDelete(apiImage.Image image) async
  {
    widget.imagesToDelete.add(image);
    widget.roomImages.remove(image);
    if(image.isMain && widget.roomImages.isNotEmpty)
      {
        widget.roomImages.last.isMain = true;
      }
    setState(() {
    });
  }

}
