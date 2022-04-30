// DoingInstallWidget.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 29 April 2022

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:io';

import 'package:noperish/DoneWidgets/DoneWidgetLinux.dart';
import 'package:noperish/DoneWidgets/DoneWidgetWin.dart';

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
      return;
    }
    lock = true;

    // Ping NS to verify credentials.
    updateMessage('Verifying Credentials with NS.');
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

    if (widget.platform == null) {
      errorAlertAndPop(
          'Platform was null. Make sure a platform is selected.', context);
      return;
    }

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
        updateMessage(
            'Writing username & autologin to /etc/noperish/combo.cfg');
        await File('/etc/noperish/combo.cfg')
            .writeAsString('${widget.username} ${ping.headers["x-autologin"]}');

        updateMessage('Copying startup binary to /usr/sbin');
        if (!await Directory('lib/premades').exists()) {
          errorAlertAndPop('Premades directory does not exist.', context);
        }
        if (widget.platform!.contains("x64")) {
          try {
            await File('lib/premades/dist/NPStartup-Linux-amd64')
                .copy('/usr/sbin/noperish');
          } catch (err) {
            if (err is FileSystemException) {
              if (err.message.contains('No such file or directory')) {
                errorAlertAndPop(
                    'lib/premades/dist/NPStartup-Linux-amd64 does not exist. The program cannot go on.',
                    context);
                return;
              }
            }
          }
        } else if (widget.platform!.contains("arm64")) {
          try {
            await File('lib/premades/dist/NPStartup-Linux-arm64')
                .copy('/usr/sbin/noperish');
          } catch (err) {
            if (err is FileSystemException) {
              if (err.message.contains('No such file or directory')) {
                errorAlertAndPop(
                    'lib/premades/dist/NPStartup-Linux-arm64 does not exist. The program cannot go on.',
                    context);
                return;
              }
            }
          }
        }

        if (widget.platform!.startsWith('Linux (Systemd)')) {
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
      var userDirectoryNT = userDirectoryProcess.stdout.toString().trim();
      var userDirectory = userDirectoryNT.replaceAll(r'\', '/');

      // Write Configuration
      updateMessage('Writing Username & Autologin.');
      await Directory('$userDirectory/AppData/Local/NoPerish').create();
      await File('$userDirectory/AppData/Local/NoPerish/combo.cfg')
          .writeAsString('${widget.username} ${ping.headers["x-autologin"]}',
              flush: true);

      // Write the program to Program Files
      updateMessage(
          'Copying startup script to C:/Program Files/NoPerish/noperish.exe');
      await Directory("C:/Program Files/NoPerish").create();
      if (widget.platform!.contains("x64")) {
        await File('lib/premades/dist/NPStartup-Windows-amd64.exe')
            .copy('C:/Program Files/NoPerish/noperish.exe');
      } else {
        errorAlertAndPop(
            "Failed to get specified architecture from platform.", context);
        return;
      }
      updateMessage('Making link in Startup to noperish.exe');
      var mklink = await Process.run(
          'mklink',
          [
            '$userDirectoryNT' +
                r'\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\NoPerish.lnk',
            r'C:\Program Files\NoPerish\noperish.exe'
          ],
          runInShell: true);

      if (mklink.stderr.toString().contains('Access is denied')) {
        errorAlertAndPop('Access was denied while creating symlink.', context);
        return;
      } else if (mklink.stderr
          .toString()
          .contains('Cannot create a file when that file already exists')) {
        updateMessage('Symlink already exists, thats fine.');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => DoneWidgetWin(
                  whathappened: keepTrack,
                )));
        return;
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => DoneWidgetWin(
                  whathappened: keepTrack,
                )));
        return;
      }
    }
  }

  void updateMessage(String message) {
    keepTrack.add(message);
    setState(() {
      currentMessage = message;
    });
  }

  void removeFiles() async {
    // Show Cleaning Dialog
    AlertDialog cleaningUpDialog = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Padding(
            child: Text('Cleaning Up...'),
            padding: EdgeInsets.only(left: 17),
          )
        ],
      ),
    );
    showDialog(
        context: context,
        builder: (context) {
          return cleaningUpDialog;
        });

    // Remove files based on platform.
    // Also btw, we are assuming root / admin.
    if (widget.platform!.startsWith('Linux')) {
      try {
        await Process.run('rm', ['-Rf', '/etc/NoPerish']);
      } catch (err) {
        // Dont do anything
      }

      if (widget.platform == 'Linux (Systemd)') {
        try {
          await Process.run('rm', ['/etc/systemd/system/noperish.service']);
        } catch (err) {
          // Dont do anything
        }
      }
    } else if (widget.platform! == 'Windows') {
      // TODO: Windows deletion
    }

    Navigator.of(context).pop();
    return;
  }

  void errorAlertAndPop(String message, BuildContext context,
      {bool shouldAttemptRemovalOfFiles = false}) {
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
              if (shouldAttemptRemovalOfFiles) {
                removeFiles();
              }
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
