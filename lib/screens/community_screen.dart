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
  List<String> availableTags = [
    "All",
    "Sharing",
    "Questions",
    "Recipe",
    "Tips & Tricks",
    "Experience"
  ];
  String selectedTag = 'All'; // Initially selected tag is 'All'

  @override
  void dispose() {
    super.dispose();
  }

  void _filterPostsByTag(String tag) {
    setState(() {
      selectedTag = tag;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      backgroundColor: Colors.green.shade50,
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
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              children: List<Widget>.generate(availableTags.length, (index) {
                final tag = availableTags[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTag = tag; // Update the selected tag
                    });
                  },
                  child: Chip(
                    label: Text(tag),
                    backgroundColor:
                        selectedTag == tag ? kPrimaryGreen : kWhite,
                    labelStyle: TextStyle(
                        color:
                            selectedTag == tag ? Colors.white : kPrimaryGreen),
                  ),
                );
              }),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .where('tag',
                              isEqualTo:
                                  selectedTag != 'All' ? selectedTag : null)
                          .orderBy('datePublished', descending: true)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.data!.docs.length == 0) {
                          return Center(child: Text('No Post Found with this tag'));  
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (ctx, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: PostCard(
                              post: snapshot.data!.docs[index].data(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
