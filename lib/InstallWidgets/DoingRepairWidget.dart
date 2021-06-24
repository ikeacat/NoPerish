// DoingRepairWidget.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 24 June 2021

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart';
import 'package:noperish/DoneWidgets/DoneWidgetRepair.dart';

class DoingRepair extends StatefulWidget {
  DoingRepair(
      {Key? key,
      required this.platform,
      required this.nation,
      required this.pw})
      : super(key: key);

  final String platform;
  final String nation;
  final String pw;

  DR createState() => DR();
}

class DR extends State<DoingRepair> {
  var currentMessage = '';
  var lock = false;
  var keepTrack = <String>[];

  void doCC() async {
    // Prevent rerun on setState or rebuild
    if (lock) {
      return;
    }
    lock = true;

    // Do root check
    updateMessage('Root / Administrator check');
    if (widget.platform.startsWith('Linux')) {
      var rootcheck = await Process.run('id', []);
      if (!rootcheck.stdout.toString().contains('uid=0')) {
        errorAlertAndPop('Run as root.', context);
        return;
      }
    } else if (widget.platform == 'Windows') {
      // TODO: Admin check for Windows.
    }

    updateMessage('Verifying new credentials');
    var ping = await pingNS();

    if (ping.statusCode == 403) {
      errorAlertAndPop(
          "The password provided for this nation is invalid. (Status Code 403 Forbidden)",
          context);
      return;
    } else if (ping.statusCode == 409) {
      errorAlertAndPop(
          'There was a conflict in the request. (Status Code 409 Conflict)',
          context);
      return;
    } else if (ping.statusCode == 418) {
      errorAlertAndPop(
          'NationStates is a teapot. (Status Code 418 Im a Teapot.)', context);
      return;
    } else if (ping.statusCode == 429) {
      errorAlertAndPop(
          'There were too many requests to the NationStates API from this device. Try again in ${ping.headers["X-Retry-After"]} seconds. (Status Code 429 Too Many Requests)',
          context);
      return;
    } else if (ping.statusCode == 200) {
      // This is wanted. Just to exclude it from the else statement.
    } else {
      errorAlertAndPop(
          "NationStates didn't respond with a 200 status code. (HTTP Status Code ${ping.statusCode})",
          context);
      return;
    }

    String? dirWrite;
    if (widget.platform.startsWith('Linux')) {
      // Linux sequence
      // Check directory for existence
      updateMessage('Checking for /etc/noperish');
      var checkForETC = await Directory('/etc/noperish').exists();
      if (!checkForETC) {
        errorAlertAndPop(
            'Could not detect existing installation. Are you sure you have an installation?',
            context);
        return;
      }

      dirWrite = '/etc/noperish/combo.cfg';
    } else if (widget.platform == 'Windows') {
      updateMessage('Checking for install directory');
      var userDirectoryProcess =
          await Process.run('echo', ['%USERPROFILE%'], runInShell: true);
      var userDirectoryNT = userDirectoryProcess.stdout.toString().trim();
      var userDirectory = userDirectoryNT.replaceAll(r'\', '/');

      var checkForINSDIR = await Directory('$userDirectory/NoPerish').exists();
      if (!checkForINSDIR) {
        errorAlertAndPop(
            'Could not detect existing installation. Are you sure you have an installation?',
            context);
        return;
      }

      dirWrite = '$userDirectory/NoPerish/combo.cfg';
    }

    if (dirWrite != null) {
      updateMessage('Writing new config file');
      await File(dirWrite).writeAsString(
          '${widget.nation} ${ping.headers["x-autologin"]}',
          flush: true);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => DoneRepair(whatHappened: keepTrack)));
    } else {
      errorAlertAndPop('dirWrite is not supposed to be null.', context);
      return;
    }
  }

  void updateMessage(String message) {
    keepTrack.add(message);
    setState(() {
      currentMessage = message;
    });
  }

  Future<Response> pingNS() async {
    final Response response = await post(
        Uri.parse('https://www.nationstates.net/cgi-bin/api.cgi'),
        headers: {
          'User-Agent': 'NoPerish <mfryk268@gmail.com>',
          'X-Password': widget.pw
        },
        body: {
          'nation': widget.nation,
          'q': 'ping'
        });
    return response;
  }

  void errorAlertAndPop(String message, BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text(
        'Error',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Text(message),
      actions: [
        TextButton(
            onPressed: () {
              // Pop to the form
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              'Ok',
              style: TextStyle(color: Colors.purple),
            ))
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  @override
  Widget build(BuildContext context) {
    doCC();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: CircularProgressIndicator()),
            Text(
              "Repairing for platform '${widget.platform}'",
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic),
            ),
            Text(
              currentMessage,
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
