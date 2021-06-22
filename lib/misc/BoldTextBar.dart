// BoldTextBar.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 21 June 2021

import 'package:flutter/material.dart';

class BoldTextBar extends StatelessWidget {
  BoldTextBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Combined Changelog & Back button
        BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        SizedBox(
          width: 10,
        ),
        Text(title,
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.w800)),
      ],
    );
  }
}
