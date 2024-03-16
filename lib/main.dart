import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

var installedapps;
List<Widget> homecontent = [];
bool popui = false;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'code'),
      home: waterlesshomepage(),
    );
  }
}

class waterlesshomepage extends StatefulWidget {
  const waterlesshomepage({super.key});

  @override
  State<waterlesshomepage> createState() => _waterlesshomepageState();
}

class _waterlesshomepageState extends State<waterlesshomepage> {
  TextEditingController controller = TextEditingController();

  // List<Widget> homecontent = [];
  @override
  void getInstalledApps() async {
    installedapps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );
    setState(() {
      homecontent.add(ListTile(
        contentPadding: EdgeInsets.all(0.0),
        leading: const Icon(Icons.keyboard_double_arrow_right),
        title: Text(
          installedapps.length.toString() + ' apps Found in Device',
          overflow: TextOverflow.visible,
          style: TextStyle(
            color: const Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'code',
          ),
        ),
      ));
    });
  }

  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    getInstalledApps();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 44, 47, 54),
      body: PopScope(
        canPop: popui,
        child: SafeArea(
          
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ListView.builder(
                itemCount: homecontent.length,
                scrollDirection: Axis.vertical,
                itemBuilder: homecontent.length == 0
                    ? (BuildContext context, int index) {
                        return Text('Loading...');
                      }
                    : (BuildContext context, int index) {
                        return homecontent[index];
                      },
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await input(context, controller);
          if (controller.text.length != 0) {
            log(controller.text);
            homecontent.add(ListTile(
              leading: const Icon(Icons.keyboard_double_arrow_right),
              contentPadding: EdgeInsets.all(0.0),
              title: Text(
                controller.text,
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontFamily: 'code',
                ),
                overflow: TextOverflow.visible,
              ),
            ));
            setState(() {
              homecontent = homecontent;
            });
            List<String> splitted_input = controller.text.split(" ");
            await cmd(
              splitted_input,
            );
            setState(() {});
          }
        },
        child: const Icon(
          Icons.terminal,
          color: Colors.white,
          size: 30,
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }
}

Future<dynamic> input(BuildContext context, TextEditingController controller) {
  controller.clear();
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shadowColor: Color.fromARGB(255, 44, 47, 54),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color.fromARGB(255, 44, 47, 54),
            ),
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        helperStyle: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontFamily: 'code'),
                        border: InputBorder.none,
                        hintText: 'Prompt here...',
                        hintStyle: TextStyle(
                          color: const Color.fromARGB(185, 255, 255, 255),
                          fontFamily: 'code',
                        ),
                        prefixIcon: Icon(
                          Icons.arrow_forward_ios,
                          color: const Color.fromARGB(185, 255, 255, 255),
                          size: 30,
                        ),
                      ),
                      cursorColor: Colors.transparent,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        // backgroundColor: const Color.fromARGB(255, 44, 47, 54),
                      ),
                      cursorWidth: 2.0,
                      cursorRadius: Radius.circular(1.0),
                      showCursor: true,
                      autofocus: true,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.keyboard_command_key,
                      // Icons.keyboard_option_key,
                      color: const Color.fromARGB(185, 255, 255, 255),
                      size: 30,
                    ),
                    // color: const Color(0xFF1BC0C5),
                  )
                ],
              ),
            ),
          ),
        );
      });
}

Future<void> cmd(dynamic cmd) async {
  List<dynamic> out = [];
  var msg = '';
  bool terminal_icon_required = false;
  List<String> appname = [];
  switch (cmd[0]) {
    case 'l':
      installedapps.forEach((element) {
        appname.add(element.appName.toString().toLowerCase());
      });
      // log("appnames list : " + appname.toString());
      var indexes = findIndexesOfSimilarSubstring(cmd[1], appname);
      if (indexes.length >= 1) {
        msg = 'opening ' + installedapps[indexes[0]].toString();
        DeviceApps.openApp(installedapps[indexes[0]].packageName);
      } else {
        msg = 'No such app found';
        // var snackBar = SnackBar(content: Text('No such app found'));
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      out = installedapps;
      break;
    case 'exit':
      popui = true;
      if (popui) {
        SystemNavigator.pop();
      } else {
        msg =
            'Cannot exit as it is your default launcher try changing it first...';
      }
      break;
    case 'clear':
      homecontent = [];
      msg = 'console Cleared...';
      break;
    case 'set':
      try {
        cmd[1] = cmd[2].toLowerCase();
      } catch (e) {
        msg = 'Invalid set command';
      }
      break;
    case 'ls':
      switch (cmd[1] ?? '-1') {
        case '-a':
          msg = 'ls command \n' + installedapps.toString();
          break;
        case '-1':
          msg = appname.toString().toLowerCase();
          break;
        default:
          msg = 'Invalid ls command';

          // msg = appname.toString().toLowerCase();
          break;
      }
      break;
    case 'help':
      msg = 'l <appname> : open app\n'
          'exit : exit this terminal launcher \n'
          'clear : clear console\n'
          'set <key> <value> : set values within app\n'
          'ls : list apps\n'
          'ls -a : list apps with detailed view\n'
          'help : show help';
      break;
    default:
      msg = 'Invalid terminal cammand';
      break;
  }
  homecontent.add(ListTile(
    contentPadding: EdgeInsets.all(0.0),
    leading:
        terminal_icon_required ? Icon(Icons.keyboard_double_arrow_right) : null,
    title: Text(
      msg,
      overflow: TextOverflow.visible,
      style: TextStyle(
        color: Color.fromARGB(255, 255, 244, 85),
        fontFamily: 'code',
      ),
    ),
  ));

  // return out;
}

List<int> findIndexesOfSimilarSubstring(String input, List<String> strings) {
  List<int> indexes = [];

  if (input.isEmpty || strings.isEmpty) return indexes;

  for (int i = 0; i < strings.length; i++) {
    String currentString = strings[i];
    if (currentString.isNotEmpty && currentString.startsWith(input)) {
      indexes.add(i);
    }
  }

  return indexes;
}
