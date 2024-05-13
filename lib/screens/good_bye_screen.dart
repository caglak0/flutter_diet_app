import 'package:flutter/material.dart';
import 'package:flutter_diet_app/screens/signin_screen.dart';
import 'package:flutter_diet_app/widgets/custom_scaffold.dart';
import 'package:flutter_diet_app/widgets/welcome_button.dart';

class GoodByePage extends StatelessWidget {
  const GoodByePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 3,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 40.0),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Hoşçakal :(',
                          style: TextStyle(
                              fontSize: 45.0, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              '\n\nSeni göremeyeceğimiz için üzüldük. Yeniden gelmek için lütfen giriş yap!',
                          style: TextStyle(
                              fontSize: 20, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          const Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    Expanded(
                        child: WelcomeButton(
                      buttonText: 'Giriş Yap',
                      onTap: SigninScreen(),
                      color: Colors.transparent,
                      textColor: Colors.white,
                    )),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
