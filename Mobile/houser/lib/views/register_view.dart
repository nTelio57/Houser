import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:houser/views/personal%20details%20view/personal_details_create_stepper.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  bool _passwordVisible = false;
  bool _passwordConfirmVisible = false;

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                basicTextField('El. paštas', const Icon(Icons.email)),
                passwordTextField('Slaptažodis', _passwordVisible, passwordVisibility),
                passwordTextField('Pakartoti slaptažodį', _passwordConfirmVisible, passwordConfirmVisibility),
                registerButton(),
              ],
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

  Widget basicTextField(String label, Widget icon)
  {
    return Container(
      padding: const EdgeInsets.only(top: 14, bottom: 7),
      child: TextField(
        decoration: InputDecoration(
            labelText: label,
            helperText: '',
            prefixIcon: icon,
            border: const OutlineInputBorder()
        ),
      ),
    );
  }

  Widget passwordTextField(String label, bool isVisible, Function() onSuffixPressed)
  {
    return Container(
      padding: const EdgeInsets.only(bottom: 7),
      child: TextField(
        obscureText: !isVisible,
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 7, bottom: 14),
      child: TextButton(
        onPressed: ()
        {
          if (kDebugMode) {
            print('Register clicked');
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalDetailsCreateStepper()));
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
