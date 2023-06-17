import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mynutrijourney/screens/helper_screens/preference_screen.dart';
import 'package:mynutrijourney/screens/signin_screen.dart';
import 'package:mynutrijourney/utils/constants.dart';
import 'package:mynutrijourney/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/user_provider.dart';

class WeightHeightScreen extends StatefulWidget {
  const WeightHeightScreen({super.key});

  

  @override
  State<WeightHeightScreen> createState() => _WeightHeightScreenState();

  
}

class _WeightHeightScreenState extends State<WeightHeightScreen> {
  double weight = 0;
  double height = 0;
  String gender = "male";

  bool isMale = true;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).setUser();
  }  


  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, _) {
      
      final User? user = userProvider.getUser;

      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Onboarding NutriJourney",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 32,
              ),
              const Text('Enter your weight(KG) :'),
              const SizedBox(height: 10),
              Text(
                "${weight.round()} KG",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Slider(
                // thumbColor: kPrimaryGreen,
                inactiveColor: kDarkGreen,
                activeColor: kPrimaryGreen,
                min: 0,
                max: 200,
                value: weight,
                onChanged: (value) {
                  setState(() {
                    weight = value;
                  });
                },
              ),
              const Text('Enter your height:'),
              Text(
                height.round().toString() + " cm",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Slider(
                inactiveColor: kDarkGreen,
                activeColor: kPrimaryGreen,
                min: 0,
                max: 300,
                value: height,
                onChanged: (value) {
                  setState(() {
                    height = value;
                  });
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        gender = "male";
                        isMale = true;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isMale ? kPrimaryGreen : Colors.white,
                        border: Border.all(
                          color: kPrimaryGreen,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: (Text(
                        "Male",
                        style: TextStyle(
                            color: isMale ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        gender = "female";
                        isMale = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: isMale ? Colors.white54 : kPrimaryGreen,
                          border: Border.all(
                            color: kPrimaryGreen,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8)),
                      child: (Text(
                        "Female",
                        style: TextStyle(
                            color: isMale ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              InkWell(
                onTap: () async {
                  try {
                    final userDocRef = FirebaseFirestore.instance
                        .collection('users')
                        .doc(user?.email);
                    print("curr sett pref   " + user!.email);
                    await userDocRef.update({
                      'weight': weight.round(),
                      'height': height.round(),
                      'gender': gender,
                    });
                    showSnackBar(context, "Updated User Info!");

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>  PreferenceScreen(),
                      ),
                    );
                  } catch (error) {
                    showSnackBar(context, error.toString());
                  }
                },
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
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      );
    });
  }
}
