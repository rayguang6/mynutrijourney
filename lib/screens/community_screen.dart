import 'package:flutter/material.dart';
import 'package:mynutrijourney/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => CommunityScreenState();
}

class CommunityScreenState extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
        final User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Community',
          style: TextStyle(color: kPrimaryGreen),
        ),
        iconTheme: const IconThemeData(color: kPrimaryGreen),
        actions: [
          GestureDetector(
            onTap: () {
              // Handle the profile image click
              // Example: Navigate to profile screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
              
            },
            child: CircleAvatar(
              
              backgroundImage: NetworkImage(user!.profileImage), // Replace with your profile image
            ),
          ),
        ],
        
      ),
      body: SingleChildScrollView(

      ),
    ) ;
  }
}
