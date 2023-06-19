import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mynutrijourney/screens/responsive/mobile_screen.dart';
import 'package:mynutrijourney/screens/responsive/responsive_screen.dart';
import 'package:mynutrijourney/screens/responsive/web_screen.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';

class PreferenceScreen extends StatefulWidget {
  const PreferenceScreen({Key? key}) : super(key: key);

  @override
  _PreferenceScreenState createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  List<String> selectedPreferences = [];

  void togglePreference(String preference) {
    setState(() {
      if (selectedPreferences.contains(preference)) {
        selectedPreferences.remove(preference);
      } else {
        selectedPreferences.add(preference);
      }
    });
  }

  void savePreferences() {
    print('Selected preferences: $selectedPreferences');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, _) {
      final User? user = userProvider.getUser;
      return Scaffold(
        appBar: AppBar(
          title: const Text('Meal Preferences'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select your meal preferences:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              PreferenceItem(
                preference: 'Vegetarian',
                isSelected: selectedPreferences.contains('Vegetarian'),
                onTap: () => togglePreference('Vegetarian'),
              ),
              const SizedBox(height: 8),
              PreferenceItem(
                preference: 'Vegan',
                isSelected: selectedPreferences.contains('Vegan'),
                onTap: () => togglePreference('Vegan'),
              ),
              const SizedBox(height: 8),
              PreferenceItem(
                preference: 'Gluten-free',
                isSelected: selectedPreferences.contains('Gluten-free'),
                onTap: () => togglePreference('Gluten-free'),
              ),
              const SizedBox(height: 8),
              PreferenceItem(
                preference: 'Dairy-free',
                isSelected: selectedPreferences.contains('Dairy-free'),
                onTap: () => togglePreference('Dairy-free'),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  try {
                    final userDocRef = FirebaseFirestore.instance
                        .collection('users')
                        .doc(user?.email);

                    // print("curr sett pref   " + user.email);

                    await userDocRef.update({
                      'preference': selectedPreferences,
                    });
                    // showSnackBar(context, "Inserted: $selectedPreferences");

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const ResponsiveScreen(
                          mobileScreen: MobileScreen(),
                          webScreen: WebScreen(),
                        ),
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
  } //
}

class PreferenceItem extends StatelessWidget {
  final String preference;
  final bool isSelected;
  final VoidCallback onTap;

  const PreferenceItem({
    required this.preference,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(preference),
      leading: Icon(
        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
        color: isSelected ? Colors.blue : null,
      ),
      onTap: onTap,
    );
  }
}
