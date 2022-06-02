// LandingWidget.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 2 June 2022

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:noperish/ConfigWidgets/BranchToPlatformWidget.dart';
import 'package:noperish/InstallWidgets/RepairConfigWidget.dart';
import 'package:noperish/InstallWidgets/UninstallConfirmWidget.dart';
import 'package:noperish/misc/ChangelogWidget.dart';
import 'package:noperish/misc/GotIssuesWidget.dart';
import 'package:noperish/misc/Header.dart';
import 'package:noperish/misc/UpdateWidget.dart';
import 'package:noperish/misc/VersionConstant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LandingPage extends StatefulWidget {
  LandingPage({Key? key}) : super(key: key);

  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  ButtonStyle updatesStyle =
      ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.purple));

  var lock = false;

  void isLatest(BuildContext context) async {
    if (lock) {
      return;
    }
    lock = true;
    var githubReq = await http.get(
        Uri.parse("https://api.github.com/repos/ikeacat/NoPerish/releases"));

    if (githubReq.statusCode != 200) {
      return;
    }

    var latestDec = jsonDecode(githubReq.body);
    var latest = latestDec[0]["tag_name"];

    if (latest == "v" + versionNoPerish) {
      setState(() {
        updatesStyle = ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green));
      });
    } else {
      setState(() {
        updatesStyle = ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.redAccent));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    isLatest(context);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            HeaderWidget(),
            SizedBox(height: 15),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BranchToPlatformWidget()));
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UninstallConfirmWidget()));
              },
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: 10, top: 10, left: 24, right: 24),
                child: Text('Uninstall',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 7),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RepairConfig()));
                },
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: 10, top: 10, left: 24, right: 24),
                  child: Text(
                    'Change Credentials',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
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
              ),
              style: updatesStyle,
            ),
            SizedBox(height: 7),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => GotIssues()));
                },
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: 10, top: 10, left: 24, right: 24),
                  child: Text(
                    'Got Issues?',
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
                    color: Colors.blueGrey, fontStyle: FontStyle.italic)),
            Text(
                'Source code is avaliable at https://github.com/ikeacat/NoPerish',
                style: TextStyle(
                    color: Colors.blueGrey, fontStyle: FontStyle.italic)),
            SizedBox(height: 7),
            RichText(
              text: TextSpan(
                  text: 'NoPerish is licensed under the ',
                  style: TextStyle(
                      color: Colors.blueGrey, fontStyle: FontStyle.italic),
                  children: [
                    TextSpan(
                        text: 'GNU General Public License v3.0',
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ]),
            ),
            RichText(
              text: TextSpan(
                  text:
                      'The license was bundled with this release & repo in the file "LICENSE", or you can get a copy at ',
                  style: TextStyle(
                      color: Colors.blueGrey, fontStyle: FontStyle.italic),
                  children: [
                    TextSpan(
                        text:
                            'https://www.gnu.org/licenses/gpl-3.0-standalone.html',
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
