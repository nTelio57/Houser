import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'personal_details_main_info.dart';
import 'personal_details_secondary_info.dart';

import 'personal_details_third_info.dart';

class PersonalDetailsCreateStepper extends StatefulWidget {
  const PersonalDetailsCreateStepper({Key? key}) : super(key: key);

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
          _currentStep = step;
        }),
        onStepContinue: () {
          setState(() {
            if(isLastStep())
              {
                if (kDebugMode) {
                  print('Completed');
                }
                return;
              }
            _currentStep += 1;
          });
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
                  child: const Text(
                    'TOLIAU',
                    style: TextStyle(
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

  bool isLastStep()
  {
    return _currentStep == personalDetailsSteps().length - 1;
  }

  List<Step> personalDetailsSteps() => [
    Step(
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      isActive: _currentStep >= 0,
      title: const Text(''),
      content: const PersonalDetailsMainInfo(),
    ),
    Step(
      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: _currentStep >= 1,
      title: const Text(''),
      content: const PersonalDetailsSecondaryInfo(),
    ),
    Step(
      state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      isActive: _currentStep >= 2,
      title: const Text(''),
      content: const PersonalDetailsThirdInfo(),
    ),
  ];
  
}
