// InitialConfigWidget.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 9 June 2021

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:noperish/DoingInstallWidget.dart';

class InitialConfigWidget extends StatefulWidget {
  InitialConfigWidget({Key? key}) : super(key: key);

  ICWState createState() => ICWState();
}

class ICWState extends State<InitialConfigWidget> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  final combokey = GlobalKey<FormState>();

  var currentItem = 'Linux (Systemd)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
              padding: EdgeInsets.only(left: 15, top: 10, right: 15),
              child: Column(
                children: [
                  // Header Texts
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
                      'Linux (Systemd)',
                      'Linux (Crontab)',
                      'macOS (launchd)',
                      'Windows (Windows Task Scheduler)',
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

                  // Submit Button
                  ElevatedButton(
                    onPressed: () {
                      if (combokey.currentState != null) {
                        var val = combokey.currentState!.validate();
                        print(val);
                        if (!val) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text('Fields on the form cannot be empty thx.'),
                            duration: Duration(seconds: 5),
                          ));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DoingInstallWidget(
                                    username: username.text,
                                    password: password.text,
                                    platform: currentItem,
                                  )));
                        }
                      } else {
                        print('ballz');
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
                  )
                ],
              ))),
    );
  }
}
