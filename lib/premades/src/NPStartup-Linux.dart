// NPStartup.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 9 June 2021

import 'dart:io';
import 'package:http/http.dart';

void main(List<String> args) async {
  // get config

  final config = await File('/etc/noperish/combo.cfg').readAsString();
  final creds = config.split(' ');

  // ping NationStates
  final Response response = await post(
      Uri.parse('https://www.nationstates.net/cgi-bin/api.cgi'),
      headers: {
        'User-Agent': 'NoPerish <mfryk268@gmail.com>',
        'X-Pin': creds[1].trim()
      },
      body: {
        'nation': creds[0].trim(),
        'q': 'ping'
      });

  if (response.body.contains('<PING>1</PING>')) {
    exit(0);
  } else if (response.body.contains('403 Forbidden')) {
    print('Incorrect Credentials!!!');
    exit(1);
  }
}
