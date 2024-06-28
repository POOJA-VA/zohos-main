import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zohomain/src/presentation/views/User/Regularization.dart';
import 'package:zohomain/src/presentation/views/User/Report.dart';
import 'package:zohomain/src/presentation/views/User/Home.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Home(),
    Report(),
    Approvals(role: "User"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Color.fromARGB(218, 71, 167, 163), // Set background color here
        selectedItemColor: Colors.white, // Set selected item color
        unselectedItemColor: const Color.fromARGB(255, 249, 248, 248), // Set unselected item color
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: AppLocalizations.of(context)!.report,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined),
            label: AppLocalizations.of(context)!.approvals,
          ),
        ],
      ),
    );
  }
}
