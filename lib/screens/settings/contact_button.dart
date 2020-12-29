import 'package:flutter/material.dart';
import 'package:mailto/mailto.dart';
import 'package:travelconverter/widgets/button.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Align(
            child: Button(onTap: () => sendEmail(), text: 'Contact me'),
            alignment: Alignment.bottomRight));
  }

  sendEmail() async {
    final mailtoLink = Mailto(
      to: ['david@greycastle.se'],
      subject: 'About TravelRates',
      body: 'Hi!\nI am emailing about TravelRates.',
    );

    await launch('$mailtoLink');
  }
}
