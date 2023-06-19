// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:mynutrijourney/services/post_service.dart';
// import 'package:mynutrijourney/utils/constants.dart';
// import 'package:provider/provider.dart';

// import '../models/user.dart';
// import '../providers/user_provider.dart';
// import '../utils/utils.dart';
// import '../widgets/comment_card.dart';

// class PostDetailScreen extends StatefulWidget {
//   // final postId;
//   final post;
//   const PostDetailScreen({Key? key, required this.post}) : super(key: key);

//   @override
//   _PostDetailScreenState createState() => _PostDetailScreenState();
// }

// class _PostDetailScreenState extends State<PostDetailScreen> {
//   final TextEditingController commentEditingController =
//       TextEditingController();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   void postComment(String uid, String name, String profilePic) async {
//     try {
//       String res = await PostService().postComment(
//         widget.post['postId'],
//         commentEditingController.text,
//         uid,
//         name,
//         profilePic,
//       );

//       if (res != 'success') {
//         showSnackBar(context, res);
//       }
//       setState(() {
//         commentEditingController.text = "";
//       });
//     } catch (err) {
//       showSnackBar(
//         context,
//         err.toString(),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final User user = Provider.of<UserProvider>(context).getUser;

//     print("POST ID:::::");
//     print("${widget.post['postId']}");

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kPrimaryGreen,
//         title: const Text(
//           'Post Detail',
//         ),
//         centerTitle: false,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             ClipRRect(
//               child: Image.network(
//                 widget.post['postUrl'].toString(),
//                 height: 150.0,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         width: 30,
//                         height: 30,
//                         child: CircleAvatar(
//                           backgroundImage:
//                               NetworkImage(widget.post['profileImage']),
//                         ),
//                       ),
//                       SizedBox(width: 8),
//                       Text(
//                         widget.post['username'],
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Text(
//                     DateFormat().format(widget.post['datePublished'].toDate()),
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   Text(
//                     widget.post['title'].toString(),
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   Text(
//                     widget.post['content'],
//                     style: const TextStyle(
//                       fontSize: 12,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 32,
//                   ),
//                   Text(
//                     "COMMENTS:",
//                     style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: kPrimaryGreen),
//                   ),
//                   StreamBuilder(
//                     stream: FirebaseFirestore.instance
//                         .collection('posts')
//                         .doc(widget.post['postId'])
//                         .collection('comments')
//                         .snapshots(),
//                     builder: (context,
//                         AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
//                             snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       }

//                       //comment
//                       return ListView.builder(
//                         scrollDirection: Axis.vertical,
//                         shrinkWrap: true,
//                         itemCount: snapshot.data!.docs.length,
//                         itemBuilder: (ctx, index) => CommentCard(
//                           snap: snapshot.data!.docs[index],
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),

//       // text input
//       bottomNavigationBar: SafeArea(
//         child: Container(
//           height: kToolbarHeight,
//           margin:
//               EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//           padding: const EdgeInsets.only(left: 16, right: 8),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 backgroundImage: NetworkImage(user.profileImage),
//                 radius: 18,
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 16, right: 8),
//                   child: TextField(
//                     controller: commentEditingController,
//                     keyboardType: TextInputType.text,
//                     decoration: InputDecoration(
//                       hintText: 'Comment as ${user.username}',
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () => postComment(
//                   user.uid.toString(),
//                   user.username.toString(),
//                   user.profileImage.toString(),
//                 ),
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//                   child: const Text(
//                     'Post',
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

