import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:houser/enums/SleepType.dart';
import 'package:houser/models/CurrentLogin.dart';
import 'package:houser/models/User.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/views/offer%20view/offer_view.dart';
import 'personal_details_main_info.dart';
import 'personal_details_secondary_info.dart';

import 'personal_details_third_info.dart';

class PersonalDetailsCreateStepper extends StatefulWidget {

  final ApiService _apiService = ApiService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PersonalDetailsMainInfo? _detailsA;
  PersonalDetailsSecondaryInfo? _detailsB;
  PersonalDetailsThirdInfo? _detailsC;

  PersonalDetailsCreateStepper({Key? key}) : super(key: key){
    _detailsA = PersonalDetailsMainInfo(_formKey);
    _detailsB = PersonalDetailsSecondaryInfo();
    _detailsC = PersonalDetailsThirdInfo();
  }

  @override
  _PersonalDetailsCreateStepperState createState() => _PersonalDetailsCreateStepperState();

}

class _PersonalDetailsCreateStepperState extends State<PersonalDetailsCreateStepper> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
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

    var animalCount = widget._detailsB!.animalCountSlider.selectedValue.toInt();
    var isStudying = widget._detailsB!.studyButtons!.isButtonSelected.indexOf(true)== 0 ? false : true;
    var isWorking = widget._detailsB!.workButtons!.isButtonSelected.indexOf(true)== 0 ? false : true;
    var isSmoking = widget._detailsB!.smokeButtons!.isButtonSelected.indexOf(true)== 0 ? false : true;

    var sleepType = SleepType.values[widget._detailsC!.sleepButtons!.isButtonSelected.indexOf(true)];
    var guestCount = widget._detailsC!.guestCountButtons!.isButtonSelected.indexOf(true) * 2;
    var partyCount = widget._detailsC!.partyCountButtons!.isButtonSelected.indexOf(true)+1;

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

    bool result = await widget._apiService.UpdateUserDetails(CurrentLogin().userId, userUpdate);
    if(result)
      {
        await CurrentLogin().loadUserDataFromSharedPreferences();
        Navigator.push(context, MaterialPageRoute(builder: (context) => const OfferView()));
      }
    return;
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
