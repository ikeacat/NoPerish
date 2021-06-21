// Header.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 19 June 2021

import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'NoPerish',
          style: TextStyle(
              fontSize: 80,
              color: Colors.deepPurple,
              fontWeight: FontWeight.w900,
              letterSpacing: 3),
        ),
        Text(
          'Never perish. Ever.',
          style: TextStyle(fontSize: 15, color: Colors.purple),
        ),
      ],
    );
  }
}
