import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:houser/enums/FilterType.dart';
import 'package:houser/enums/SleepType.dart';
import 'package:houser/extensions/dateTime_extensions.dart';
import 'package:houser/models/Filter.dart';
import 'package:houser/models/RoomFilter.dart';
import 'package:houser/models/UserFilter.dart';
import 'package:houser/services/current_login.dart';
import 'package:houser/models/User.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/services/offer%20manager/offer_card_manager.dart';
import 'package:houser/views/filter%20view/filter_base.dart';
import 'package:houser/views/offer%20view/offer_view.dart';
import 'package:provider/provider.dart';
import 'personal_details_main_info.dart';
import 'personal_details_secondary_info.dart';
import 'package:collection/collection.dart';

import 'personal_details_third_info.dart';

// ignore: must_be_immutable
class PersonalDetailsCreateStepper extends StatefulWidget {

  final ApiService _apiService = ApiService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PersonalDetailsMainInfo? _detailsA;
  PersonalDetailsSecondaryInfo? _detailsB;
  PersonalDetailsThirdInfo? _detailsC;

  bool isEditingMode = false;
  User? userToEdit;

  PersonalDetailsCreateStepper({Key? key, this.isEditingMode = false, this.userToEdit}) : super(key: key){
    _detailsA = PersonalDetailsMainInfo(_formKey);
    _detailsB = PersonalDetailsSecondaryInfo();
    _detailsC = PersonalDetailsThirdInfo();
  }

  @override
  _PersonalDetailsCreateStepperState createState() => _PersonalDetailsCreateStepperState();

}

class _PersonalDetailsCreateStepperState extends State<PersonalDetailsCreateStepper> {
  int _currentStep = 0;
  bool editInitialized = false;

  @override
  Widget build(BuildContext context) {
    if(widget.isEditingMode)
    {
      if(widget.userToEdit == null) {
        throw Exception('If editing mode = true, userToEdit can\'t be null');
      }
      if(!editInitialized){
        setupForEditing(widget.userToEdit!);
        editInitialized = true;
      }
    }

    return Scaffold(body: personalDetailsCreateForm());
  }

  Widget body()
  {
    return Stack(
      children: [
        background(),
        SingleChildScrollView(
          child: Stack(
            children: [
              topBar(),
              personalDetailsCreateForm()
            ],
          ),
        ),
      ],
    );
  }

  Widget background()
  {
    return Container(
      color: const Color.fromRGBO(0, 153, 204, 1),
    );
  }

  Widget topBar()
  {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 32, right: 32),
      child: Row(
        children: [
          Expanded(child: Container())
        ],
      ),
    );
  }

  Widget personalDetailsCreateForm()
  {
    return SafeArea(
      child: Stepper(
        type: StepperType.horizontal,
        steps: personalDetailsSteps(),
        currentStep: _currentStep,
        onStepTapped: (step) => setState(() {
          if(_currentStep != 0 || widget._formKey.currentState!.validate())
            {
              _currentStep = step;
            }
        }),
        onStepContinue: () {
          if(_currentStep != 0 || widget._formKey.currentState!.validate())
            {
              setState(() {
                if(isLastStep())
                {
                  if (kDebugMode) {
                    print('Completed');
                  }
                  onCompleted();
                  return;
                }
                _currentStep += 1;
              });
            }
        },
        onStepCancel: () {
          _currentStep == 0 ?
          null :
          setState(() {
            _currentStep -= 1;
          });
        },
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Container(
            margin: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: const EdgeInsetsDirectional.only(start: 8.0),
                  child: TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text(
                      'ATGAL',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: details.onStepContinue,
                  child: Text(
                    isLastStep() ? 'BAIGTI' : 'TOLIAU',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 153, 204, 1),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2)))
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future onCompleted() async
  {
    var name = widget._detailsA!.nameFieldText.text;
    var birthDate = widget._detailsA!.birthDate;
    var sex = widget._detailsA!.sexSelectionButtons!.isButtonSelected.indexOf(true);

    var animalCount = widget._detailsB!.animalCountSliderValue.toInt();
    var guestCount = widget._detailsB!.guestCountSliderValue.toInt();
    var partyCount = widget._detailsB!.partyCountSliderValue.toInt();

    var isStudying = widget._detailsC!.studyButtons!.isButtonSelected.indexOf(true)== 0 ? false : true;
    var isWorking = widget._detailsC!.workButtons!.isButtonSelected.indexOf(true)== 0 ? false : true;
    var isSmoking = widget._detailsC!.smokeButtons!.isButtonSelected.indexOf(true)== 0 ? false : true;

    var sleepType = SleepType.values[widget._detailsC!.sleepButtons!.isButtonSelected.indexOf(true)];
    
    User userUpdate = User('', '');
    userUpdate.name = name;
    userUpdate.birthDate = birthDate;
    userUpdate.sex = sex;

    userUpdate.animalCount = animalCount;
    userUpdate.isStudying = isStudying;
    userUpdate.isWorking = isWorking;
    userUpdate.isSmoking = isSmoking;

    userUpdate.sleepType = sleepType;
    userUpdate.guestCount = guestCount;
    userUpdate.partyCount = partyCount;

    EasyLoading.show();
    bool result = await widget._apiService.UpdateUserDetails(CurrentLogin().user!.id, userUpdate);
    if(result)
      {
        await CurrentLogin().loadUserDataFromSharedPreferences();
        EasyLoading.dismiss();
        if(widget.isEditingMode)
          {
            Navigator.pop(context);
            return;
          }
        else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => FilterBaseView(onFilterChanged)));
          return;
        }
      }
    EasyLoading.dismiss();
    return;
  }

  void setupForEditing(User user)
  {
    widget._detailsA!.nameFieldText.text = user.name!;
    widget._detailsA!.birthDate = user.birthDate!;
    widget._detailsA!.birthFieldText.text = user.birthDate!.dateToString();
    widget._detailsA!.sexSelectionButtons!.isButtonSelected = widget._detailsA!.sexSelections.mapIndexed((index, element) => index == user.sex).toList();

    widget._detailsB!.animalCountSliderValue = user.animalCount == null ? 0 : user.animalCount!.toDouble();
    widget._detailsB!.guestCountSliderValue = user.guestCount == null ? 0 : user.guestCount!.toDouble();
    widget._detailsB!.partyCountSliderValue = user.partyCount == null ? 0 : user.partyCount!.toDouble();

    widget._detailsC!.sleepButtons!.isButtonSelected = user.sleepType == null ? widget._detailsC!.sleepTimeSelections.map((e) => false).toList()
        : SleepType.values.map((element) => element == user.sleepType).toList();
    widget._detailsC!.studyButtons!.isButtonSelected = user.isStudying == null ? widget._detailsC!.studySelections.map((e) => false).toList()
        : widget._detailsC!.studySelections.mapIndexed((index, element) => index == (user.isStudying! ? 1 : 0)).toList();
    widget._detailsC!.workButtons!.isButtonSelected = user.isWorking == null ? widget._detailsC!.workSelections.map((e) => false).toList()
        : widget._detailsC!.workSelections.mapIndexed((index, element) => index == (user.isWorking! ? 1 : 0)).toList();
    widget._detailsC!.smokeButtons!.isButtonSelected = user.isSmoking == null ? widget._detailsC!.smokeSelections.map((e) => false).toList()
        : widget._detailsC!.smokeSelections.mapIndexed((index, element) => index == (user.isSmoking! ? 1 : 0)).toList();
  }

  Future onFilterChanged(Filter newFilter) async {
    CurrentLogin().user!.filter = newFilter;
    final provider = Provider.of<OfferCardManager>(context, listen: false);

    switch(newFilter.filterType){
      case FilterType.room:
        await widget._apiService.PostFilter(newFilter as RoomFilter);
        break;
      case FilterType.user:
        await widget._apiService.PostFilter(newFilter as UserFilter);
        break;
      case FilterType.none:
    }
    await CurrentLogin().loadUserDataFromSharedPreferences();
    await provider.loadOffersAsync(3, 0);
    provider.loadOffersSync(7, 3);

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OfferView()), (Route<dynamic> route) => false);
  }

  bool isLastStep()
  {
    return _currentStep == personalDetailsSteps().length - 1;
  }

  List<Step> personalDetailsSteps() => [
    Step(
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      isActive: _currentStep >= 0,
      title: const Text(''),
      content: widget._detailsA!,
    ),
    Step(
      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: _currentStep >= 1,
      title: const Text(''),
      content: widget._detailsB!,
    ),
    Step(
      state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      isActive: _currentStep >= 2,
      title: const Text(''),
      content: widget._detailsC!,
    ),
  ];
  
}
