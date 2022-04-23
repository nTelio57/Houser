import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:houser/views/login_view.dart';
import 'package:houser/views/register_view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  _WelcomeViewState createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {

  @override
  void didChangeDependencies() {
    setupLoader();
    super.didChangeDependencies();
  }

  void setupLoader()
  {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..maskType = EasyLoadingMaskType.custom
      ..backgroundColor = Theme.of(context).primaryColor
      ..textColor = Colors.white
      ..indicatorColor = Colors.white
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..fontSize = 16
      ..contentPadding = const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0)
      ..maskColor = Colors.black.withOpacity(0.2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: body());
  }

  Widget body()
  {
    return Stack(
      children: [
        background(),
        logo(),
        buttonsColumn()
      ],
    );
  }

  Widget background()
  {
    return Container(
      color: Theme.of(context).primaryColor,
    );
  }

  Widget logo()
  {
    return Container(
      padding: const EdgeInsets.only(top: 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: Image.asset('assets/logo/v2.png'),
            width: 75,
          ),
          const Text(
            'ouser',
            style: TextStyle(
              fontSize: 65,
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonsColumn()
  {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 175),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          whiteTextButton('Prisijungti', onLoginClicked),
          const SizedBox(height: 20),
          whiteTextButton('Registruotis', onRegisterClicked)
        ],
      ),
    );
  }

  Widget whiteTextButton(String text, Function() handler)
  {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
          onPressed: handler,
          child: Text(
              text,
            style: const TextStyle(
              fontSize: 18
            ),
          ),
        style: TextButton.styleFrom(
          backgroundColor: Colors.white
        )
      ),
    );
  }
  
  void onLoginClicked()
  {
    if (kDebugMode) {
      print('Login clicked');
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginView()));
  }

  void onRegisterClicked()
  {
    if (kDebugMode) {
      print('Register clicked');
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterView()));
  }
}
