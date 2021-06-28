// GotIssuesWidget.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 28 June 2021

import 'package:flutter/material.dart';
import 'package:noperish/misc/BoldTextBar.dart';

class GotIssues extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoldTextBar(title: 'Got Issues?'),
          Text(
            'Do you have issues with this app?',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          Text(
            'Do you want to report these issues and make this app an overall better app?',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          Text(
            'Well I have just the site for you!',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic),
          ),
          RichText(
            text: TextSpan(
              text: "You can report issues at ",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w900),
              children: [
                TextSpan(
                    text: "https://www.github.com/ikeacat/NoPerish/issues",
                    style: TextStyle(color: Colors.red))
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
