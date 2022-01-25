import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  _WelcomeViewState createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
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
      color: const Color.fromRGBO(0, 153, 204, 1),
    );
  }

  Widget logo()
  {
    return Container(
      padding: const EdgeInsets.only(top: 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
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
          whiteTextButton('Prisijungti'),
          //buttonDivider(),
          const SizedBox(height: 20),
          whiteTextButton('Registruotis')
        ],
      ),
    );
  }

  Widget buttonDivider()
  {
    return Row(
      children: [
        Expanded(child:
          Container(
            color: Colors.white,
            height: 2,
          )
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
              'Don\'t have an account?',
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
        Expanded(child: Container
          (
            color: Colors.white,
            height: 2,
          )
        ),
      ],
    );
  }

  Widget whiteTextButton(String text)
  {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
          onPressed: () {
            if (kDebugMode) {
              print('White button clicked');
            }
          },
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

}
