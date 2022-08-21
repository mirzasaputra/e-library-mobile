import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          _drawerHeader(),
          const Padding(
            padding: EdgeInsets.only(
              top: 15.0,
              left: 20.0,
              bottom: 10.0,
            ),
            child: Text(
              'Application',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _drawerItem(
            icon: Icons.folder,
            text: 'Data Genre',
            onTap: () {
              Navigator.pushNamed(context, '/genre');
            }
          ),
          _drawerItem(
            icon: Icons.book,
            text: 'Data Buku',
            onTap: () {
              Navigator.pushNamed(context, '/book');
            }
          ),
          _drawerItem(
            icon: Icons.person,
            text: 'Data Anggota',
            onTap: () {
              Navigator.pushNamed(context, '/member');
            }
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 40.0,
              left: 20.0,
              bottom: 10.0,
            ),
            child: Text(
              'Pengaturan',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _drawerItem(
            icon: Icons.settings,
            text: 'Setting',
            onTap: () {}
          ),
          _drawerItem(
            icon: Icons.person,
            text: 'User',
            onTap: () {
              Navigator.pushNamed(context, '/user');
            }
          ),
          _drawerItem(
            icon: Icons.shield_moon,
            text: 'Role',
            onTap: () {}
          ),
        ],
      ),
    );
  }

  Widget _drawerHeader() {
    return const UserAccountsDrawerHeader(
      accountName: Text('Root'), 
      accountEmail: Text('root@gmail.com'),
      decoration: BoxDecoration(
        color: Color(0xFF14907A),
      ),
    );
  }

  Widget _drawerItem({
    IconData? icon, required String text, GestureTapCallback? onTap
  }) {
    return ListTile(
      title: Row(
        children: [
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}