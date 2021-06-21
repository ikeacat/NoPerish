// main.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 19 June 2021

import 'package:flutter/material.dart';
import 'package:noperish/LandingWidget.dart';

void main() => runApp(NoPerish());

class NoPerish extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoPerish',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: LandingPage(),
    );
  }
}
