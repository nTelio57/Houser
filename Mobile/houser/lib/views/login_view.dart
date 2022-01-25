import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  bool _passwordVisible = false;

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
      color: const Color.fromRGBO(0, 153, 204, 1),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                emailTextField(),
                passwordTextField(),
                loginButton(),
                forgotPasswordButton(),
              ],
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

  Widget emailTextField()
  {
    return Container(
      padding: const EdgeInsets.only(top: 14, bottom: 7),
      child: const TextField(
        decoration: InputDecoration(
          labelText: 'El. paštas',
          helperText: '',
          prefixIcon: Icon(Icons.email),
          border: OutlineInputBorder()
        ),
      ),
    );
  }

  Widget passwordTextField()
  {
    return Container(
      padding: const EdgeInsets.only(top: 7, bottom: 7),
      child: TextField(
        obscureText: !_passwordVisible,
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

  Widget loginButton()
  {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 7),
      child: TextButton(
        onPressed: ()
        {
          if (kDebugMode) {
            print('Login clicked');
          }
        },
        child: const Text(
          'Prisijungti',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: const Color.fromRGBO(0, 153, 204, 1),
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
