import 'package:flutter/material.dart';
import 'package:e_library_mobile/routes/main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ThemeData().colorScheme.copyWith(
          primary: const Color(0xFF14907A),
        ),
      ),
      routes: buildRoute(context),
      debugShowCheckedModeBanner: false,
    );
  }
}