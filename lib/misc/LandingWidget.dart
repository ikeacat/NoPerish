// LandingWidget.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 24 June 2021

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:noperish/misc/ChangelogWidget.dart';
import 'package:noperish/InstallWidgets/InitialConfigWidget.dart';
import 'package:noperish/misc/Header.dart';
import 'package:noperish/misc/UpdateWidget.dart';
import 'package:noperish/misc/VersionConstant.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            HeaderWidget(),
            SizedBox(height: 15),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => InitialConfigWidget()));
                },
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: 10, top: 10, left: 24, right: 24),
                  child: Text(
                    'Install',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
            SizedBox(height: 7),
            ElevatedButton(
              onPressed: () {
                return;
              },
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: 10, top: 10, left: 24, right: 24),
                child: Text('Uninstall',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey)),
            ),
            SizedBox(height: 7),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChangelogWidget()));
                },
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: 10, top: 10, left: 24, right: 24),
                  child: Text(
                    'Changelog',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
            SizedBox(height: 7),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => UpdateWidget()));
                },
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: 10, top: 10, left: 24, right: 24),
                  child: Text(
                    'Updates',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
            SizedBox(height: 7),
            ElevatedButton(
                onPressed: () {
                  exit(0);
                },
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: 10, top: 10, left: 24, right: 24),
                  child: Text(
                    'Exit',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Text('NoPerish v$versionNoPerish',
                style: TextStyle(
                    color: Colors.blueGrey, fontStyle: FontStyle.italic))
          ],
        ),
      ),
    );
  }
}
