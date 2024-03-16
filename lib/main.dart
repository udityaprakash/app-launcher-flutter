import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

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
  List<Application>? apps;
  bool exitui = false;
  @override
  void initState() {
    super.initState();
    _getapps();
  }

  void _getapps() async {
    List<Application> applist = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );
    setState(() {
      apps = applist;
      log(apps!.length.toString());
    });
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
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                exitui = !exitui;
              });
              SystemNavigator.pop();
            },
            icon: Icon(
              exitui ? Icons.exit_to_app : Icons.exit_to_app_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: PopScope(
        canPop: exitui,
        child: Container(
            child: apps != null
                ? GridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    physics: BouncingScrollPhysics(),
                    children:
                        List.generate(apps != null ? apps!.length : 0, (index) {
                      log("app details here : " +
                          apps![index].appName.toString());
                      return GestureDetector(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              iconcontainer(index, apps),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                apps![index].appName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          DeviceApps.openApp(apps![index].packageName);
                        },
                      );
                    }),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      // backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  )),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _getapps();
      //   },
      //   child: Icon(Icons.refresh),
      // ),
    );
  }
}

iconcontainer(index, apps) {
  try {
    return CircleAvatar(
      radius: 25,
      backgroundImage: MemoryImage(
          apps[index].icon != null ? apps[index].icon : Uint8List(0)),
      // child: Image.memory(
      //     apps[index].icon != null ? apps[index].icon : Uint8List(0),
      //     height: 50,
      //     width: 50),
    );
  } catch (e) {
    return Container(
      height: 50,
      width: 50,
      color: Colors.white,
    );
  }
}