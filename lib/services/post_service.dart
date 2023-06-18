import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynutrijourney/utils/utils.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class PostService{
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//function to create post into database
  Future<String> createPost(title, content, _image, uid, username, profileImage) async {
    // String profileImage =
    //     await StorageMethods().uploadImageToStorage('posts', file, true);
    String res = "";

    try {
      String postId = const Uuid().v1();
      String postImageLink = "";

      postImageLink = await uploadImageToStorage('posts', _image);

      Post post = Post(
        title: title,
        content: content,
        uid: uid,
        username: username,
        likes: [],
        datePublished: DateTime.now(),
        postId: postId,
        postUrl: postImageLink,
        profileImage :profileImage,
      );

      
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  //update post 
  Future<String> updatePost(postId, title, content) async {

    String res = "";

    try {
      await _firestore.collection('posts').doc(postId).update({
        'title': title,
        'content': content,
      });

      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }



  Future<String> deletePost(String postId) async {
    String res = "error deleting post";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

}