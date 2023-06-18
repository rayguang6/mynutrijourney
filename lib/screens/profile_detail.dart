import 'package:flutter/material.dart';

import '../utils/constants.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() => ProfileDetailScreenState();
}

class ProfileDetailScreenState extends State<ProfileDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: kPrimaryGreen,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Text('Profile Detail')
        ]),
      ),
    );
  }
}