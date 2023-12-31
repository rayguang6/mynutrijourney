import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mynutrijourney/screens/responsive/responsive_screen.dart';
import 'package:provider/provider.dart';

import 'providers/user_provider.dart';
import 'screens/signin_screen.dart';
import 'screens/responsive/mobile_screen.dart';
import 'screens/responsive/web_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/launcher_icon',
      // null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white),
        NotificationChannel(
          channelKey: 'scheduled_channel',
          channelDescription: 'Notification channel for basic tests',
          channelName: 'Scheduled Notifications',
          defaultColor: Colors.teal,
          locked: true,
          importance: NotificationImportance.High,
          // soundSource: 'resource://raw/res_custom_notification',
        ),
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);

  // check if we are initialized it with web app or mobile
  //only if it is web application, then we have to pass the firebase options
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyAQAskANlWDty-ntxSJeIPAx9rMDjMIsDs",
      authDomain: "mynutrijourney-a4a38.firebaseapp.com",
      projectId: "mynutrijourney-a4a38",
      storageBucket: "mynutrijourney-a4a38.appspot.com",
      messagingSenderId: "426461717287",
      appId: "1:426461717287:web:ec2ec9340bac5037033f02",
    ));
  } else {
    //if it is mobile app, then just initialize firebase without passing
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ErrorWidget.builder = (FlutterErrorDetails details) => Container(
    //   child: Scaffold(body: Center(child: Image.asset('assets/images/vertical_logo.png'),),),
    // );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Nutri Journey',
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const ResponsiveScreen(
                  mobileScreen: MobileScreen(),
                  webScreen: WebScreen(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('ERROR IN SNAPSHOT! : ${snapshot.error}'),
                );
              } else {
                return const SignInScreen();
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const SignInScreen();
          },
        ),
      ),
    );
  }
}
