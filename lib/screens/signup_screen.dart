import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mynutrijourney/screens/helper_screens/weight_height.dart';
import 'package:mynutrijourney/screens/signin_screen.dart';
import 'package:mynutrijourney/services/auth_service.dart';
import 'package:mynutrijourney/utils/utils.dart';
import 'package:mynutrijourney/widgets/text_input.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../utils/constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // for loading indicator
  Uint8List?
      _image; //initialize the image, we will update it later using setstate

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  //function for calling utils to selectImage
  pickImage() async {
    Uint8List imageUploaded = await selectImage(ImageSource.gallery);

    //use setstate to update the uploaded image, then we can replace the default profile image
    setState(() {
      _image = imageUploaded;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    //set default profile it the user dont want to upload iamge
    String imgPath = 'assets/images/default-profile.png';
    final ByteData bytes = await rootBundle.load(imgPath);
    final Uint8List defaultProfileImage = bytes.buffer.asUint8List();

    // calling helper function from auth method,
    //Args: email,password,username,image file

    String response = await AuthService().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        file: _image ?? defaultProfileImage);

    if (response == "success") {
      Provider.of<UserProvider>(context, listen: false).setUser(); // trigger the auth change
      setState(() {
        _isLoading = false;
      });

      //TODO: When user is signed up, we let them to go onboarding screen first
      //

      // now we just let them to go to main screen which is the responsive ,
      // navigate back to homescreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const WeightHeightScreen(),
          // builder: (context) => const ResponsiveScreen(
          //   mobileScreen: MobileScreen(),
          //   webScreen: WebScreen(),
          // ),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(context, response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                            backgroundColor: Colors.blueAccent,
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage:
                                AssetImage("assets/images/default-profile.png"),
                            backgroundColor: kPrimaryGreen,
                          ),
                    Positioned(
                      bottom: -10,
                      right: 80,
                      child: IconButton(
                        onPressed: pickImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextInputField(
                  hintText: 'Enter your username',
                  textInputType: TextInputType.text,
                  textEditingController: _usernameController,
                ),
                const SizedBox(height: 16),
                TextInputField(
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                        borderSide: Divider.createBorderSide(context)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: Divider.createBorderSide(context)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: Divider.createBorderSide(context)),
                    filled: true,
                    contentPadding: const EdgeInsets.all(8),
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: kPrimaryGreen,
                    ),
                    child: !_isLoading
                        ? const Text(
                            'Sign up',
                            style: TextStyle(color: Colors.white),
                          )
                        : const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 60, // Add a specific height to the container
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text('Already have an account?'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          ' Sign In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
