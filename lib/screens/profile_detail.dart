import 'package:flutter/material.dart';
import 'package:mynutrijourney/utils/constants.dart';

DateTime scheduleTime = DateTime.now();

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({
    super.key,
  });

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: kPrimaryGreen,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Name"),
            Text("Email"),
            Text(""),
          ],
        ),
      ),
    );
  }
}
