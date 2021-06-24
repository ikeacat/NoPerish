// ChangelogWidget.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 24 June 2021

import 'package:flutter/material.dart';
import 'package:noperish/misc/BoldTextBar.dart';

class ChangelogWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoldTextBar(title: 'Changelog'),
          SizedBox(height: 10),
          // START OF SECTION HERE
          ChangelogSection(
            'N/A',
            changes: [
              'Added Landing page',
              'Added Check for Update page',
              'Added Bold Text Bar',
              'Switched Install Widget to Bold text bar'
            ],
          ),
          ChangelogSection(
            '1.1.1',
            changes: [
              'Switched to saving autologin instead of PIN (the pin expires apparently).'
            ],
          ),
          ChangelogSection(
            '1.1.0',
            changes: [
              'Added Windows support',
              'Added root & admin warning',
              'Added this Changelog',
              'Make it so that the default platform isnt Linux (Systemd)'
            ],
          ),
          ChangelogSection('1.0.0', changes: [
            'Initial design of the app',
            'Added Linux (Systemd) support'
          ])
        ],
      ),
    ]));
  }
}

class ChangelogSection extends StatelessWidget {
  ChangelogSection(this.versionNumber, {this.changes});

  final String versionNumber;
  final List<String>? changes;

  List<Widget> generateTexts() {
    List<Widget> listBuild = [];
    if (changes == null) {
      listBuild.add(Text(
        'No changes reported.',
        textAlign: TextAlign.start,
      ));
    } else {
      for (String textc in changes!) {
        listBuild.add(Padding(
            child: Text(
              '- $textc',
              textAlign: TextAlign.left,
            ),
            padding: EdgeInsets.only(left: 20)));
      }
    }
    return listBuild;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('v' + versionNumber,
            style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
        SizedBox(height: 15),
        Column(
            children: generateTexts(),
            crossAxisAlignment: CrossAxisAlignment.start),
        SizedBox(height: 10)
      ]),
      padding: EdgeInsets.only(left: 12),
    );
  }
}
