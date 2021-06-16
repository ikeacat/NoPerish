// DoingInstallWidget.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 16 June 2021

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:io';

import 'package:noperish/DoneWidgetLinux.dart';
import 'package:noperish/DoneWidgetWin.dart';

class DoingInstallWidget extends StatefulWidget {
  DoingInstallWidget({Key? key, this.platform, this.username, this.password})
      : super(key: key);

  final String? platform;
  final String? username;
  final String? password;

  DIState createState() => DIState();
}

class DIState extends State<DoingInstallWidget> {
  var currentMessage = '';
  var lock = false;
  var keepTrack = <String>[];

  void doInstall(BuildContext context) async {
    // So that when setState rebuilds the request doesnt do this again.
    if (lock) {
      print('lock');
      return;
    }
    lock = true;

    // Ping NS to verify credentials.
    updateMessage('Verifying Credentials with NS.');
    var ping = await pingNS();
    print(ping.headers);
    //print(ping.body);
    print(ping.statusCode);
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

    if (widget.platform == null) {
      errorAlertAndPop(
          'Platform was null. Make sure a platform is selected.', context);
      return;
    }

    //setState(() {
    //  currentMessage = 'Running root check (id)';
    //});

    // This is where it gets platform specific.
    if (widget.platform!.startsWith('Linux')) {
      updateMessage('Checking for root.');
      var rootcheck = await Process.run('id', []);
      if (!rootcheck.stdout.toString().contains('uid=0')) {
        errorAlertAndPop('Run as root.', context);
        return;
      }

      updateMessage('Creating /etc/noperish');
      var etcDirectory = await Directory('/etc/noperish').create();
      if (await etcDirectory.exists()) {
        updateMessage('Writing username & PIN to /etc/noperish/combo.cfg');
        await File('/etc/noperish/combo.cfg')
            .writeAsString('${widget.username} ${ping.headers["x-pin"]}');

        updateMessage('Copying NPStartup binary to etc directory');
        print(Directory.current);
        if (!await Directory('lib/premades').exists()) {
          errorAlertAndPop('Premades directory does not exist.', context);
        }
        try {
          await File('lib/premades/dist/NPStartup-Linux')
              .copy('/etc/noperish/NPStartup-Linux');
        } catch (err) {
          if (err is FileSystemException) {
            if (err.message.contains('No such file or directory')) {
              errorAlertAndPop(
                  'lib/premades/dist/NPStartup-Linux does not exist. The program cannot go on.',
                  context);
              return;
            }
          }
        }

        if (widget.platform! == 'Linux (Systemd)') {
          updateMessage('Copying and Installing noperish.service');
          try {
            await File('lib/premades/noperish.service')
                .copy('/etc/systemd/system/noperish.service');
          } catch (err) {
            if (err is FileSystemException) {
              if (err.message.contains('No such file or directory')) {
                errorAlertAndPop(
                    'lib/premades/dist/noperish.service does not exist. The program cannot go on.',
                    context);
                return;
              }
            }
          }

          // Enable NoPerish in Systemd
          updateMessage('Enabling noperish service');
          var systemctl =
              await Process.run('systemctl', ['enable', 'noperish']);
          if (systemctl.stdout.toString().contains('could not be found')) {
            errorAlertAndPop(
                'Error while enabling service: ${systemctl.stdout}', context);
            return;
          } else {
            updateMessage('Done!');
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => DoneWidgetLinux(
                      whathappened: keepTrack,
                    )));
          }
        } else if (widget.platform! == 'Linux (Crontab)') {
          updateMessage('Writing to system crontab at /var/spool/cron/root');
          var rootCron = await File('/var/spool/cron/root').create();
          await rootCron.writeAsString('@reboot /etc/noperish/NPStartup-Linux',
              mode: FileMode.append);

          updateMessage('Verifying crontab file');
          var cronverify =
              await Process.run('crontab', ['-T', '/var/spool/cron/root']);
          print(cronverify.exitCode);
          print(cronverify.stderr);
          print(cronverify.stdout);
          if (cronverify.stdout.toString().contains('No syntax issues')) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => DoneWidgetLinux(
                      whathappened: keepTrack,
                    )));
            return;
          } else if (cronverify.stderr.contains('Invalid crontab file') ||
              cronverify.stdout.contains('Invalid crontab file')) {
            errorAlertAndPop(
                'Crontab file is invalid.\n stderr: ${cronverify.stderr.toString()}',
                context);
            return;
          } else {
            errorAlertAndPop(
                'There was an unknown error while verifying the crontab.' +
                    cronverify.stderr.toString() +
                    cronverify.stdout.toString(),
                context);
            return;
          }
        }
      } else {
        errorAlertAndPop('Could not create /etc/noperish/', context);
        return;
      }
    } else if (widget.platform!.startsWith('Windows')) {
      // Get the UserProfile environment variable.
      var userDirectoryProcess =
          await Process.run('echo', ['%USERPROFILE%'], runInShell: true);
      var userDirectory = userDirectoryProcess.stdout.toString().trim();
      userDirectory = userDirectory.replaceAll(r'\', '/');

      updateMessage('Creating directory in User directory');
      await Directory('$userDirectory/NoPerish').create();

      updateMessage(
          'Writing Username & PIN to $userDirectory/NoPerish/combo.cfg');
      await File('$userDirectory/NoPerish/combo.cfg').writeAsString(
          '${widget.username} ${ping.headers["x-pin"]}',
          flush: true);

      updateMessage(
          'Copying startup script to $userDirectory/NoPerish/noperish.exe');
      await File('lib/premades/dist/NPStartup-Windows.exe')
          .copy('$userDirectory/NoPerish/noperish.exe');

      updateMessage('Filling in username in RegisterTask.xml');
      var regTask = await File('lib/premades/RegisterTask.xml').readAsString();
      var winUsername =
          await Process.run('echo', ['%username%'], runInShell: true);

      regTask = regTask.replaceFirst('UserName', winUsername.stdout.trim());
      print(regTask);

      updateMessage(
          'Writing modified XML Task to $userDirectory/NoPerish/RegisterTask.xml');
      await File('$userDirectory/NoPerish/RegisterTask.xml')
          .writeAsString(regTask, flush: true);

      updateMessage('Registering Task');
      var registerTask = await Process.run('schtasks', [
        '/Create',
        '/TN',
        'NoPerish',
        '/XML',
        '$userDirectory/NoPerish/RegisterTask.xml'
      ]);
      if (registerTask.stdout.toString().contains('SUCCESS') ||
          registerTask.stderr.toString().contains('SUCCESS')) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => DoneWidgetWin(
                  whathappened: keepTrack,
                )));
      } else {
        if (registerTask.stderr
            .toString()
            .contains('Cannot create a file when that file already exists.')) {
          updateMessage(
              'Task is already registered; Removing task and reregistering.');

          await Process.run('schtasks', ['/Delete', '/TN', 'NoPerish', '/F']);
          var registerTask2 = await Process.run('schtasks', [
            '/Create',
            '/TN',
            'NoPerish',
            '/XML',
            '$userDirectory/NoPerish/RegisterTask.xml'
          ]);
          print(registerTask2.stdout);
          print('err: ${registerTask2.stderr}');
          if (registerTask2.stdout.toString().contains('SUCCESS') ||
              registerTask2.stderr.toString().contains('SUCCESS')) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => DoneWidgetWin(
                      whathappened: keepTrack,
                    )));
          } else {
            errorAlertAndPop('Could not register task on reregister.', context);
          }
        } else {
          errorAlertAndPop(
              'Could not register task. STDERR: ${registerTask.stderr.toString()}, STDOUT: ${registerTask.stdout.toString()}',
              context);
        }
      }
    }
  }

  void updateMessage(String message) {
    keepTrack.add(message);
    setState(() {
      currentMessage = message;
    });
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

  Future<Response> pingNS() async {
    final Response response = await post(
        Uri.parse('https://www.nationstates.net/cgi-bin/api.cgi'),
        headers: {
          'User-Agent': 'NoPerish <mfryk268@gmail.com>',
          'X-Password': widget.password!
        },
        body: {
          'nation': widget.username!,
          'q': 'ping'
        });
    return response;
  }

  @override
  Widget build(BuildContext context) {
    doInstall(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: CircularProgressIndicator()),
            Text(
              "Installing for platform '${widget.platform}'",
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
