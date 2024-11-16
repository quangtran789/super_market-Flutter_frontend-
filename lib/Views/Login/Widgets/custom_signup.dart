import 'package:flutter/material.dart';

class CustomCreateaccount extends StatelessWidget {
  final VoidCallback onSignUpPressed;
  final String signUpText;
  const CustomCreateaccount(
      {super.key, required this.onSignUpPressed, required this.signUpText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
              minimumSize: const Size(400, 50),
              side: const BorderSide(color: Colors.white, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )),
          onPressed: onSignUpPressed,
          child: Text(
            signUpText,
            style: const TextStyle(
              fontSize: 22,
              fontFamily: 'Jaldi',
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
