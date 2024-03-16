import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

List<String> cmdoptions = ['o', 'l', 'exit', 'clear', 'b', 'i'];

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
  bool? accessstorage;
  var installedapps;
  var homecontent;
  @override
  void getInstalledApps() async {
    installedapps = await DeviceApps.getInstalledApplications(
      // includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: false,
    );
    setState(() {
      homecontent = installedapps.length.toString() + ' apps installed';
    });
  }

  void initState() {
    accessstorage = false;
    super.initState();
    getInstalledApps();
    // installedapps =
    handlepermissions().then((value) => {accessstorage = value});
  }

  Future<bool?> handlepermissions() async {
    PermissionStatus storagepermissionstatus = await _getpermissionsatus();
    if (storagepermissionstatus == PermissionStatus.granted) {
      return true;
    } else {
      _getpermissionsatus();
    }
  }

  Future<PermissionStatus> _getpermissionsatus() async {
    PermissionStatus status = await Permission.storage.status;
    if (status != PermissionStatus.granted ||
        status != PermissionStatus.denied) {
      status = await Permission.storage.request();
    }
    return status ?? PermissionStatus.denied;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 44, 47, 54),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: Text(
          'WATERLESS',
          style: TextStyle(
            color: const Color.fromARGB(255, 252, 252, 252),
            fontSize: 20,
            fontFamily: 'code',
            letterSpacing: 5.0,
            // wordSpacing: 0.1,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(homecontent.toString()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await input(context, controller);
          if(controller.text.length != 0){
              log(controller.text);

              List<String> splitted_input = controller.text.split(" ");
              List<dynamic> Availableoptions;
              if (splitted_input[0] == 'o') {
                Availableoptions = installedapps;
                List<String> appname = [];
                Availableoptions.forEach((element) {
                  appname.add(element.appName.toString().toLowerCase());
                });
                log(appname.toString());
                var indexes =
                    findIndexesOfSimilarSubstring(splitted_input[1], appname);
                if (indexes.length >= 1) {
                  DeviceApps.openApp(Availableoptions[indexes[0]].packageName);
                } else {
                  var snackBar = SnackBar(content: Text('No such app found'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              } else {
                Availableoptions =
                    await cmd(splitted_input[0], installedapps: installedapps);
              }
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
                      Icons.keyboard_return,
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

Future<List<dynamic>> cmd(String cmd, {installedapps}) async {
  List<dynamic> out = [];
  if (cmdoptions.contains(cmd) == false) return [];
  switch (cmd) {
    case 'l':
      List<Application> apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true,
      );
      out = apps;
      break;
    case 'o':
      out = installedapps;
      break;
    case 'exit':
      break;
    case 'clear':
      break;

    case 'i':
      break;
    default:
      return [];
  }
  return out;
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
