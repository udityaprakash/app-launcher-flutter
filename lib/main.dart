import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

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
  @override
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await input(context, controller);
          
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
                          hintText: 'Promt here...',
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(185, 255, 255, 255),
                            fontFamily: 'code',
                          ),
                          
                          prefixIcon: Icon(Icons.arrow_forward_ios,
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
