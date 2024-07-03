import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:studiovity_assignment/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
      home: Scaffold(
        appBar: AppBar(
          leadingWidth: 20,
          leading: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Icon(
              Icons.table_chart_outlined,
              // color: Colors.blue,
            ),
          ),
          title: const Text(
            'Report Table',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.info,
                  color: Colors.blue,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.menu,
                  color: Colors.blue,
                )),
          ],
        ),
        body: const Home(),
      ),
    );
  }
}
