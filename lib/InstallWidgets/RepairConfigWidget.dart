// RepairConfigWidget.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 24 June 2021

import 'package:flutter/material.dart';
import 'package:noperish/misc/BoldTextBar.dart';

class RepairConfig extends StatefulWidget {
  RepairConfig({Key? key}) : super(key: key);

  RC createState() => RC();
}

class RC extends State<RepairConfig> {
  var currentItem = 'Select your installed platform...';
  final repairComboKey = GlobalKey<FormState>();
  final nation = TextEditingController();
  final pw = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              BoldTextBar(title: 'Change Credentials'),
              Form(
                key: repairComboKey,
                child: Column(
                  children: [
                    TextFormField(
                      autocorrect: false,
                      decoration: InputDecoration(labelText: 'Nation Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty || value == '') {
                          return 'Nation field cannot be empty.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      autocorrect: false,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty || value == '') {
                          return 'Password field cannot be empty.';
                        }
                        return null;
                      },
                    )
                  ],
                ),
              ),
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
                  'Select your installed platform...',
                  'Linux (Systemd)',
                  'Linux (Crontab) (integrated but not supported yet)',
                  'macOS (not supported yet)',
                  'Windows',
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
                        content: Text('The new dropdown item was null. Yikes.'),
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
              SizedBox(height: 5),
              ElevatedButton(
                  onPressed: () {
                    if (repairComboKey.currentState != null) {
                      // Validate Nation & Password fields
                      var rckval = repairComboKey.currentState!.validate();
                      if (rckval) {
                        // Validate platform
                        if (currentItem ==
                            'Select your installed platform...') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Please select a platform :)'),
                              duration: Duration(seconds: 4)));
                          return;
                        }
                        if (currentItem == 'Linux (Systemd)' ||
                            currentItem == 'Windows') {
                          // TODO: Make sure to update this IF statement when macOS or Crontab is supported :)
                          // TODO: Push to Repair
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Linux (Crontab) and macOS arent supported yet. You sure you're installed?"),
                              duration: Duration(seconds: 4)));
                          return;
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Combination key currentState null.'),
                          duration: Duration(seconds: 9)));
                      return;
                    }
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.only(bottom: 5, top: 5, left: 12, right: 12),
                    child: Text('Submit',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  )),
              SizedBox(height: 5),
              RichText(
                  text: TextSpan(
                      text: 'This only changes your credentials ',
                      style: TextStyle(color: Colors.blueGrey),
                      children: <TextSpan>[
                    TextSpan(
                        text: 'on an existing installation',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ', it does not install.')
                  ])),
              Text(
                'Your credentials are only sent to NationStates and never stored in plain-text on the device. It is stored in an encrypted version.',
                style: TextStyle(color: Colors.blueGrey),
              ),
            ],
          )),
    );
  }
}
