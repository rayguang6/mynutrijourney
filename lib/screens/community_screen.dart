import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mynutrijourney/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';
import '../widgets/post_card.dart';
import 'helper_screens/add_post.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {


  @override
  void dispose() {
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
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
              backgroundImage: NetworkImage(
                  user!.profileImage), // Replace with your profile image
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: Text("Create Post"),
          backgroundColor: kPrimaryGreen,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPostScreen()),
            );
          },
          icon: const Icon(Icons.add),
        ),
      
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PostCard(
                  snap: snapshot.data!.docs[index].data(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
