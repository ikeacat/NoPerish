// NPStartup-Windows.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 26 March 2022

import 'dart:io';
import 'package:http/http.dart';

void main(List<String> args) async {
  // get %USERPROFILE%
  var upProc = await Process.run('echo', ['%USERPROFILE%'], runInShell: true);
  var up = upProc.stdout.toString().trim().replaceAll(r'\', '/');

  // get config
  final config =
      await File('$up/AppData/Local/NoPerish/combo.cfg').readAsString();
  final creds = config.split(' ');

  // ping NationStates
  final Response response = await post(
      Uri.parse('https://www.nationstates.net/cgi-bin/api.cgi'),
      headers: {
        'User-Agent': 'NoPerish <mfryk268@gmail.com>',
        'X-Autologin': creds[1].trim()
      },
      body: {
        'nation': creds[0].trim(),
        'q': 'ping'
      });

  var logfile = await File('$up/AppData/Local/NoPerish/startup.log').create();
  var now = DateTime.now();

  if (response.body.contains('<PING>1</PING>')) {
    await logfile.writeAsString(
        '\n[${now.day}.${now.month}.${now.year} ${now.hour}:${now.minute} INFO] Ping was successful.',
        mode: FileMode.append,
        flush: true);
    exit(0);
  } else if (response.body.contains('403 Forbidden')) {
    print('Incorrect Credentials!!!');
    await logfile.writeAsString(
        '\n[${now.day}.${now.month}.${now.year} ${now.hour}:${now.minute} ERROR] Ping was unsuccessful! Credentials were unsuccessful.',
        mode: FileMode.append,
        flush: true);
    exit(1);
  }
}
