import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'p',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'iz',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'on',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }
}