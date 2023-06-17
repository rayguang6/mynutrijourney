import 'package:flutter/material.dart';
import 'package:mynutrijourney/screens/helper_screens/preference_screen.dart';
import 'package:mynutrijourney/screens/helper_screens/weight_height.dart';
import 'package:mynutrijourney/screens/profile_screen.dart';

import '../../utils/constants.dart';
import '../community_screen.dart';
import '../dashboard_screen.dart';
import '../planner_screen.dart';
import '../recipe_screen.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({Key? key}) : super(key: key);

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    //  WeightHeightScreen(),
    //  PreferenceScreen(),
    const DashboardScreen(),
    const PlannerScreen(),
    const RecipeScreen(),
    const CommunityScreen()
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Nutri Journey!',
          style: TextStyle(color: kPrimaryGreen),
        ),
        iconTheme: const IconThemeData(color: kPrimaryGreen),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
               Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              );
            },
          ),
        ],
        
      ),

      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _page,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: kPrimaryGreen,
        unselectedItemColor: kGrey,
        iconSize: 24,
        onTap: updatePage,
        items: [
          _buildBottomNavigationBarItem(0, Icons.dashboard, 'Dashboard'),
          _buildBottomNavigationBarItem(1, Icons.calendar_today, 'Planner'),
          _buildBottomNavigationBarItem(2, Icons.restaurant_menu, 'Recipe'),
          _buildBottomNavigationBarItem(3, Icons.people, 'Community'),
        ],
      ),
    );
  }

  // reusable widget for Bottom Navbar Item
  BottomNavigationBarItem _buildBottomNavigationBarItem(
      int pageNumber, IconData icon, String label) {
    return BottomNavigationBarItem(
        icon: SizedBox(
            width: bottomBarWidth,
            child: Icon(icon)),
        label: label);
  }
}
