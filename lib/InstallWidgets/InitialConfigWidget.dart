// InitialConfigWidget.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 29 April 2022

import 'package:flutter/material.dart';
import 'package:noperish/misc/BoldTextBar.dart';
import 'package:noperish/InstallWidgets/DoingInstallWidget.dart';

class InitialConfigWidget extends StatefulWidget {
  InitialConfigWidget({Key? key}) : super(key: key);

  ICWState createState() => ICWState();
}

class ICWState extends State<InitialConfigWidget> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  final combokey = GlobalKey<FormState>();

  var currentItem = 'Select a platform...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
              padding: EdgeInsets.only(left: 15, top: 10, right: 15),
              child: Column(
                children: [
                  // Header Texts
                  BoldTextBar(title: 'Install'),
                  // Combo Form
                  Form(
                    key: combokey,
                    child: Column(
                      children: [
                        TextFormField(
                          autocorrect: false,
                          decoration: InputDecoration(labelText: 'Username'),
                          controller: username,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username field cannot be empty.';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          autocorrect: false,
                          decoration: InputDecoration(
                            labelText: 'Password',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty || value == '') {
                              return 'Password field cannot be empty.';
                            }
                            return null;
                          },
                          controller: password,
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),

                  // Platform
                  DropdownButton(
                    focusColor: Colors.white,
                    value: currentItem,
                    style: TextStyle(color: Colors.white),
                    iconSize: 0,
                    isExpanded: true,
                    hint: Text(
                      'Choose your platform please.',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    items: <String>[
                      'Select a platform...',
                      'Linux (Systemd) (x64)',
                      'Linux (Systemd) (arm64)',
                      'Windows (x64)',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.blueGrey),
                          ));
                    }).toList(),
                    onChanged: (String? val) {
                      setState(() {
                        if (val != null) {
                          currentItem = val;
                        } else if (val == null) {
                          // Show alert dialog
                          AlertDialog nullalert = AlertDialog(
                            title: Text(
                              'Error!!!!!',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w800),
                            ),
                            content:
                                Text('The new dropdown item was null. Yikes.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Ok',
                                  style: TextStyle(color: Colors.purple),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                ),
                              )
                            ],
                          );
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return nullalert;
                              });
                        }
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Submit Button
                      ElevatedButton(
                        onPressed: () {
                          if (combokey.currentState != null) {
                            var val = combokey.currentState!.validate();
                            if (!val) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    'Fields on the form cannot be empty thx.'),
                                duration: Duration(seconds: 5),
                              ));
                            } else {
                              if (currentItem.startsWith('Linux (Systemd)') ||
                                  currentItem.startsWith('Windows')) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DoingInstallWidget(
                                          username: username.text,
                                          password: password.text,
                                          platform: currentItem,
                                        )));
                              } else if (currentItem ==
                                  'Select a platform...') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "You need to select a platform."),
                                        duration: Duration(seconds: 5)));
                                return;
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "macOS and Linux (Crontab) aren't supported yet. Sorry!"),
                                    duration: Duration(seconds: 7)));
                                return;
                              }
                            }
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: 5, top: 5, left: 12, right: 12),
                          child: Text(
                            'Submit',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    'Your password will never be stored in plaintext on the device & is only sent to NationStates. Only the encrypted password & Nation name is stored.',
                    style: TextStyle(
                        color: Colors.blueGrey, fontStyle: FontStyle.italic),
                  ),
                  Text(
                      'PLEASE NOTE: If you are on Windows, make sure this is being run as administrator, and if you are on Linux, run as root.',
                      style: TextStyle(
                          color: Colors.blueGrey, fontStyle: FontStyle.italic)),
                ],
              ))),
    );
  }
}
