import 'package:flutter/material.dart';
import 'package:e_library_mobile/component/general/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              color: Color(0xFF14907A),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.08,
                left: 15.0,
                right: 15.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'E - Library App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Welcome to Application E - Library App',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: InkWell(
              onTap: () => _scaffoldKey.currentState!.openDrawer(),
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Icon(
                  Icons.dehaze, 
                  color: Colors.white, 
                  size: 30.0,
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}