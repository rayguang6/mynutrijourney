import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mynutrijourney/screens/helper_screens/edit_post.dart';
import 'package:mynutrijourney/services/post_service.dart';
import 'package:mynutrijourney/utils/utils.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  _editPost() {
    Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditPostScreen(post: widget.snap),
    ),
  );
  }

  _deletePost() async {
    String postId = widget.snap["postId"];

    try {
      String response =  await PostService().deletePost(postId);

      if(response=="success"){
        showSnackBar(context, "Deleted Successful");
      }else{
        showSnackBar(context, response);
      }

    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  void _confirmDeletePost() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete the post "${widget.snap['title']}"?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              _deletePost();
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    // bool isOwner = true;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            widget.snap['postUrl'],
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.snap['profileImage']),
                    ),
                    SizedBox(width: 8),
                    Text(
                      widget.snap['username'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    if (widget.snap['uid'].toString() == user!.uid)
                      PopupMenuButton<String>(
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'edit') {
                            // Handle Edit
                            _editPost();
                          } else if (value == 'delete') {
                            // Handle Delete
                            _confirmDeletePost();
                          }
                        },
                        icon: Icon(Icons.more_vert),
                      ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  widget.snap['title'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.snap['content'],
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style: TextStyle(color: Colors.grey),
                    ),
                    Row(
                      children: [
                        Icon(Icons.comment),
                        SizedBox(width: 4),
                        Text(5.toString()),
                        SizedBox(width: 16),
                        Icon(Icons.thumb_up),
                        SizedBox(width: 4),
                        Text(3.toString()),
                        SizedBox(width: 16),
                        Icon(Icons.bookmark),
                        SizedBox(width: 4),
                        Text(2.toString()),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
