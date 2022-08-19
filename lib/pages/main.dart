import 'package:flutter/material.dart';
import 'package:e_library_mobile/pages/home/index.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainState();
}

class _MainState extends State<MainPage> {
  int _activePage = 0;

  void _changeSelectedNavbar(int idx) {
    setState(() {
      _activePage = idx;
    });
  }

  final List<Widget> _menuList = [
    const HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _menuList[_activePage],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Buku',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Akun',
          ),
        ],
        currentIndex: _activePage,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF14907A),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _changeSelectedNavbar
      ),
    );
  }
}