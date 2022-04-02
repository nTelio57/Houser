import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:houser/models/AuthRequest.dart';
import 'package:houser/models/AuthResult.dart';
import 'package:houser/models/CurrentLogin.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/views/personal%20details%20view/personal_details_create_stepper.dart';

class RegisterView extends StatefulWidget {
  RegisterView({Key? key}) : super(key: key);

  final ApiService _apiService = ApiService();

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  bool _passwordVisible = false;
  bool _passwordConfirmVisible = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _passwordRepeatTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: body());
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
              registerForm()
            ],
          ),
        ),
      ],
    );
  }

  Widget background()
  {
    return Container(
      color: Theme.of(context).primaryColor,
    );
  }

  Widget topBar()
  {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 32, right: 32),
      child: Row(
        children: [
          Expanded(child: backButton()),
          Expanded(child: logo()),
          Expanded(child: Container())
        ],
      ),
    );
  }

  Widget backButton()
  {
    return Container(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
          onPressed: ()
          {
            if (kDebugMode) {
              print('Go back clicked');
            }

            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            primary: Colors.white,
            padding: const EdgeInsets.only(right: 32, top: 16, bottom: 16),
          ),
          icon: const Icon(
            Icons.west,
            color: Colors.white,
          ),
          label: const Text(
            'Grįžti',
            style: TextStyle(
              color: Colors.white,
            ),
          )
      ),
    );
  }

  Widget logo()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          child: Image.asset('assets/logo/v2.png'),
          width: 75,
        ),
      ],
    );
  }

  // ignore: prefer_function_declarations_over_variables
  String? Function(String?) emailValidator = (String? value){
    if(value == null || value.isEmpty)
    {
      return 'Įveskite el. paštą';
    }
    return null;
  };

  String? passwordValidator(String? value){
    if(value == null || value.isEmpty)
    {
      return 'Įveskite slaptažodį';
    }
    return null;
  }

  String? passwordRepeatValidator(String? value){
    if(value == null || value.isEmpty)
    {
      return 'Įveskite sutampantį slaptažodį';
    }else if(value != _passwordTextController.text)
    {
      return 'Slaptažodžiai turi sutapti';
    }
    return null;
  }


  Widget registerForm()
  {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 150),
      child: Column(
        children: [
          registerLabel(),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 6, bottom: 6),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4))
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  basicTextField('El. paštas', const Icon(Icons.email), _emailTextController, emailValidator),
                  passwordTextField('Slaptažodis', _passwordVisible, passwordVisibility, _passwordTextController, passwordValidator),
                  passwordTextField('Pakartoti slaptažodį', _passwordConfirmVisible, passwordConfirmVisibility, _passwordRepeatTextController, passwordRepeatValidator),
                  registerButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget registerLabel()
  {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      alignment: Alignment.centerLeft,
      child: const Text(
        'Registruotis',
        style: TextStyle(
            color: Colors.white,
            fontSize: 40
        ),
      ),
    );
  }

  Widget basicTextField(String label, Widget icon, TextEditingController controller, String? Function(String?) validator)
  {
    return Container(
      padding: const EdgeInsets.only(top: 14, bottom: 7),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
            labelText: label,
            helperText: '',
            prefixIcon: icon,
            border: const OutlineInputBorder()
        ),
      ),
    );
  }

  Widget passwordTextField(String label, bool isVisible, Function() onSuffixPressed, TextEditingController controller, Function(String?) validator)
  {
    return Container(
      padding: const EdgeInsets.only(bottom: 7),
      child: TextFormField(
        obscureText: !isVisible,
        controller: controller,
        validator: (value){
          return validator(value);
        },
        decoration: InputDecoration(
          labelText: label,
          helperText: '',
          prefixIcon: const Icon(Icons.lock),
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: onSuffixPressed,
          ),
        ),
      ),
    );
  }

  void passwordVisibility()
  {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void passwordConfirmVisibility()
  {
    setState(() {
      _passwordConfirmVisible = !_passwordConfirmVisible;
    });
  }

  Widget registerButton()
  {
    CurrentLogin currentLogin = CurrentLogin();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 7, bottom: 14),
      child: TextButton(
        onPressed: () async
        {
          if (kDebugMode) {
            print('Register clicked');
          }
          if(_formKey.currentState!.validate())
            {
              AuthRequest authRequest = AuthRequest(_emailTextController.text, _passwordTextController.text);
              AuthResult authResult = await widget._apiService.Register(authRequest);
              if(authResult.success!)
              {
                currentLogin.jwtToken = authResult.token!;
                currentLogin.user = authResult.user!;
                currentLogin.saveUserDataToSharedPreferences();

                Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalDetailsCreateStepper()));
              }
              else{
                //handle failed registration
              }
            }
        },
        child: const Text(
          'Registruotis',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20
          ),
        ),
        style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 12)
        ),
      ),
    );
  }
}
