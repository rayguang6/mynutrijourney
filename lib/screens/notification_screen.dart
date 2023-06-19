import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:intl/intl.dart';
import 'package:mynutrijourney/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/notification.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../services/notification_service.dart';
import '../utils/notification_utils.dart';
import '../utils/utils.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // List<BlogPost> _blogPosts = [];
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  List<String> notificationList = [
    
    "Daily, 10:00",
    "Daily, 13:00",
    "Daily, 16:00",
    "Daily, 20:00",
  
  ];

  // pickedSchedule
  NotificationWeekAndTime? pickedSchedule = getInitialData();

  DateTime currentTime = DateTime.now();

  String getFormattedDateTime(NotificationWeekAndTime pickedSchedule) {
    String dayOfWeek = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'
    ][pickedSchedule.dayOfTheWeek - 1];

    String timeOfDay = pickedSchedule.timeOfDay.format(context);

    return '$dayOfWeek, $timeOfDay';
  }

  // void _addPost() {
  //   setState(() {
  //     final newPost = BlogPost(
  //       title: _titleController.text,
  //       content: _contentController.text,
  //     );
  //     _blogPosts.add(newPost);
  //     _titleController.clear();
  //     _contentController.clear();
  //   });
  // }

  void _deleteReminder(int index) {
    showSnackBar(context, "Deleted Reminder");
    setState(() {
      notificationList.removeAt(index);
    });
  }

  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryGreen,
        title: Text("Reminders"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showNotificationDialog(context);
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: notificationList.length,
              itemBuilder: (context, index) {
                final notification = notificationList[index];
                // print("my noti  $notification");
                return Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kPrimaryGreen,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListTile(
                    title: Text(notification.toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // IconButton(
                        //   onPressed: () => _editPost(index),
                        //   icon: const Icon(Icons.edit),
                        // ),
                        IconButton(
                          onPressed: () => _deleteReminder(index),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showNotificationDialog(BuildContext context) {
    final User user = Provider.of<UserProvider>(context, listen: false).getUser;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Notification'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('Date'),
                    trailing: TextButton(
                      onPressed: () async {
                        NotificationWeekAndTime? schedule =
                            await pickSchedule(context);

                        // final DateTime? picked = await showDatePicker(
                        //   context: context,
                        //   initialDate: selectedDate,
                        //   firstDate: DateTime.now(),
                        //   lastDate: DateTime(2100),
                        // );
                        if (schedule != null && schedule != pickedSchedule) {
                          setState(() {
                            pickedSchedule = schedule;
                          });
                        }
                      },
                      child: Text(
                        getFormattedDateTime(pickedSchedule!),
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (pickedSchedule != null) {
                  print("Day of Week:");
                  print(pickedSchedule!.dayOfTheWeek);
                  print("Time of Day :");
                  print(pickedSchedule!.timeOfDay);

                  String notificationId = const Uuid().v1();

                  createWaterReminderNotification(pickedSchedule!);

                  String formattedString =
                      getFormattedDateTime(pickedSchedule!);
                  setState(() {
                    notificationList.add(formattedString);
                  });

                  showSnackBar(context, "Added Reminder on $formattedString");
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

NotificationWeekAndTime getInitialData() {
  DateTime currentTime = DateTime.now();
  int currentDayOfWeek = currentTime.weekday;
  TimeOfDay currentTimeOfDay = TimeOfDay.fromDateTime(currentTime);

  return NotificationWeekAndTime(
    dayOfTheWeek: currentDayOfWeek,
    timeOfDay: currentTimeOfDay,
  );
}
