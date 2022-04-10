import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:houser/extensions/string_extensions.dart';
import 'package:houser/models/AuthRequest.dart';
import 'package:houser/utils/current_login.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/views/offer%20view/offer_view.dart';
import 'package:houser/views/personal%20details%20view/personal_details_create_stepper.dart';
import 'package:houser/widgets/WG_snackbars.dart';

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  final ApiService _apiService = ApiService();

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

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
              loginForm()
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
            padding: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
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
    if(!value.isValidEmail)
    {
      return 'Įveskite tinkamą el. paštą';
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

  Widget loginForm()
  {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 180),
      child: Column(
        children: [
          loginLabel(),
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
                  emailTextField(emailValidator),
                  passwordTextField(passwordValidator),
                  loginButton(),
                  forgotPasswordButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginLabel()
  {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      alignment: Alignment.centerLeft,
      child: const Text(
        'Prisijungti',
        style: TextStyle(
            color: Colors.white,
            fontSize: 40
        ),
      ),
    );
  }

  Widget emailTextField(Function(String?) validator)
  {
    return Container(
      padding: const EdgeInsets.only(top: 14, bottom: 7),
      child: TextFormField(
        controller: _emailTextController,
        validator: (value){
          return validator(value);
        },
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: 'El. paštas',
          helperText: '',
          prefixIcon: Icon(Icons.email),
          border: OutlineInputBorder()
        ),
      ),
    );
  }

  Widget passwordTextField(Function(String?) validator)
  {
    return Container(
      padding: const EdgeInsets.only(top: 7, bottom: 7),
      child: TextFormField(
        obscureText: !_passwordVisible,
        controller: _passwordTextController,
        validator: (value){
          return validator(value);
        },
        decoration: InputDecoration(
          labelText: 'Slaptažodis',
          helperText: '',
          prefixIcon: const Icon(Icons.lock),
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
      ),
    );
  }

  bool _isLoginButtonEnabled = true;

  Widget loginButton()
  {
    CurrentLogin currentLogin = CurrentLogin();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 7),
      child: TextButton(

        onPressed: !_isLoginButtonEnabled ? null : () async
        {

          setState(() {
            _isLoginButtonEnabled = false;
          });

          if (kDebugMode) {
            print('Login clicked');
          }
          if(_formKey.currentState!.validate())
            {
              AuthRequest authRequest = AuthRequest(_emailTextController.text, _passwordTextController.text);
              try{
                var authResult = await widget._apiService.Login(authRequest).timeout(const Duration(seconds: 5));
                if(authResult.success!)
                {
                  currentLogin.jwtToken = authResult.token!;
                  currentLogin.user = authResult.user!;
                  currentLogin.saveUserDataToSharedPreferences();

                  if(CurrentLogin().user!.name == null) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalDetailsCreateStepper()));
                  } else {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const OfferView()), (Route<dynamic> route) => false);
                  }
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authResult.errors!.first)));
                }
              } on SocketException {
                ScaffoldMessenger.of(context).showSnackBar(noConnectionSnackbar);
              } on TimeoutException {
                ScaffoldMessenger.of(context).showSnackBar(serverErrorSnackbar);
              } on Exception {
                ScaffoldMessenger.of(context).showSnackBar(failedLogin);
              }
            }
          setState(() {
            _isLoginButtonEnabled = true;
          });
        },
        child: const Text(
          'Prisijungti',
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

  Widget forgotPasswordButton()
  {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          if (kDebugMode) {
            print('Forgot password clicked');
          }
        },
        child: const Text(
            'Pamiršai slaptažodį?'
        ),
      ),
    );
  }
}
