import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../utils/constants.dart';

class ResponsiveScreen extends StatefulWidget {
  final Widget mobileScreen;
  final Widget webScreen;
  const ResponsiveScreen({
    Key? key,
    required this.mobileScreen,
    required this.webScreen,
  }) : super(key: key);

  @override
  State<ResponsiveScreen> createState() => _ResponsiveScreenState();
}

class _ResponsiveScreenState extends State<ResponsiveScreen> {
  @override
  void initState() {
    super.initState();

    // setUserData();

    setState(() {
     setUserData();
    });

  }


  setUserData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
        
    _userProvider.setUser();

    // Wait for the user data to be initialized
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > kWebScreenSize) {
        // 600 can be changed to 900 if you want to display tablet screen with mobile screen layout

        return widget.webScreen;
      }
      return widget.mobileScreen;
    });
  }
}
