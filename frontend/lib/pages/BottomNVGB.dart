import 'package:flutter/material.dart';

class AdminBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  AdminBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'ข้อมูลผู้ใช้',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_add),
          label: 'เพิ่มผู้ใช้',
        ),
      ],
    );
  }
}
