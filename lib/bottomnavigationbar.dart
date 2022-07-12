import 'package:fireauth/HomePage.dart';
import 'package:fireauth/groups.dart';
import 'package:flutter/material.dart';

class Bottomnavigationbar extends StatefulWidget {
  static const String id = '/hp';
  @override
  _BottomnavigationbarState createState() => _BottomnavigationbarState();
}

class _BottomnavigationbarState extends State<Bottomnavigationbar> {
  int selectedPage = 0;

  final _pageOptions = [
    HomePage(),
    Groups(),
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: _pageOptions[selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          showSelectedLabels: false,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'groups'),
            // BottomNavigationBarItem(
            //   icon: Padding(
            //     padding: EdgeInsets.fromLTRB(
            //         height / 400, height / 168, height / 400, height / 168),
            //     child: CircleAvatar(
            //       radius: height * 0.015,
            //       backgroundImage: AssetImage("assets/storyimage1.jpg"),
            //     ),
            //   ),
            //   label: 'search',
            // ),
          ],
          selectedItemColor: Colors.blue,
          elevation: 5.0,
          unselectedItemColor: Colors.black,
          currentIndex: selectedPage,
          backgroundColor: Colors.white,
          onTap: (index) {
            setState(() {
              selectedPage = index;
            });
          },
        ));
  }
}
