import 'package:flutter/material.dart';


DateTime scheduleTime = DateTime.now();

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key, required this.title});

  final String title;

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("EOEELE"),
          ],
        ),
      ),
    );
  }
}
