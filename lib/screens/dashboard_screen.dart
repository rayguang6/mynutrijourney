import 'package:flutter/material.dart';
import 'package:mynutrijourney/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // final UserProvider userProvider = Provider.of<UserProvider>(context);

    final userProvider = Provider.of<UserProvider>(context);
    User? user = userProvider.getUser;
    
    print("DASHBOARD DATA: " + user.toJson().toString());

    return Column(
      children: [
        Text(user.username),
        Center(
          child: Text(userProvider.getUser.toJson().toString()),
        ),
      ],
    );
  }
}
