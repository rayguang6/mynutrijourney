import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mynutrijourney/screens/recipe_screen.dart';
import 'package:mynutrijourney/screens/responsive/mobile_screen.dart';
import 'package:mynutrijourney/utils/constants.dart';
import 'package:mynutrijourney/utils/utils.dart';
import 'package:provider/provider.dart';

import 'dart:math';

import 'package:d_chart/d_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../widgets/progress_chart_painter.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  DateTime currentDate = DateTime.now();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, num> mealCalories = {
    'Breakfast': 0,
    'Lunch': 0,
    'Dinner': 0,
    'Total': 0,
    // 'Snack': 0,
  };
  Map<String, num> mealCarbs = {
    'Breakfast': 0,
    'Lunch': 0,
    'Dinner': 0,
    'Total': 0,
    // 'Snack': 0,
  };
  Map<String, num> mealProteins = {
    'Breakfast': 0,
    'Lunch': 0,
    'Dinner': 0,
    'Total': 0,
    // 'Snack': 0,
  };
  Map<String, num> mealFats = {
    'Breakfast': 0,
    'Lunch': 0,
    'Dinner': 0,
    'Total': 0,
    // 'Snack': 0,
  };

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (selected != null && selected != currentDate) {
      setState(() {
        currentDate = selected;
      });
    }
  }

  void goToPreviousDay() {
    setState(() {
      currentDate = currentDate.subtract(const Duration(days: 1));
    });
  }

  void goToNextDay() {
    setState(() {
      currentDate = currentDate.add(const Duration(days: 1));
    });
  }

  void _confirmDeleteMeal(userEmail, documentId, date) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this meal?'),
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
                _deleteMealItem(userEmail, documentId, date);
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

  Future<void> _deleteMealItem(userEmail, documentId, date) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('planner')
          .doc(date)
          .collection(date)
          .doc(documentId)
          .delete();

      showSnackBar(context, "Meal Deleted!");
    } catch (error) {
      // Handle any errors that occur during deletion
      print('Error deleting meal item: $error');
    }
  }

  void _calculateTotalCalories() {
    num totalCalories =
        mealCalories.values.reduce((sum, calories) => sum + calories);
    setState(() {
      mealCalories['Total'] = totalCalories;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context, listen: false).getUser;

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: Text("Meal Planner"),
        backgroundColor: kPrimaryGreen,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: goToPreviousDay,
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(currentDate),
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: goToNextDay,
                ),
              ],
            ),
            // const SizedBox(
            //   height: 32,
            // ),
            const Text(
              'Meal Plan',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSummaryContainer(user),
                    _buildMealContainer('Breakfast', 'Breakfast', user),
                    _buildMealContainer('Lunch', 'Lunch', user),
                    _buildMealContainer('Dinner', 'Dinner', user),
                    // _buildMealContainer('Snack', 'Snack', user),
                  ],
                ),
              ),
            ),
            // const SizedBox(height: 20.0),
            // _buildSummary(user),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryContainer(User user) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kWhite,
        // border: Border.all(color: kLightGreen),
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SUMMARY',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: kBlack,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Implement your logic to add a plan
                },
                child: const Text('Add Plan'),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection('users')
                .doc(user.email)
                .collection('planner')
                .doc(_formatDate(currentDate))
                .collection(_formatDate(currentDate))
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Text("No Meal Found, ADD MEAL to see your progress! "),
                  ),
                );
              }

              num targetCalories = 10000; // temp
              num totalCalories = 0;
              num totalCarbs = 0;
              num totalProteins = 0;
              num totalFats = 0;

              mealCalories["Total"] ??= 0; // Initialize to 0 if null
              mealCarbs["Total"] ??= 0; // Initialize to 0 if null
              mealProteins["Total"] ??= 0; // Initialize to 0 if null
              mealFats["Total"] ??= 0; // Initialize to 0 if null

              snapshot.data!.docs.forEach((doc) {
                var meal = doc.data() as Map<String, dynamic>;
                var calories = meal['calories'] as num?;
                var carbs = meal['carbohydrates'] as num?;
                var proteins = meal['proteins'] as num?;
                var fats = meal['fats'] as num?;

                if (calories != null) {
                  totalCalories += calories;
                  mealCalories["Total"] =
                      (mealCalories["Total"] ?? 0) + calories;
                }
                if (carbs != null) {
                  totalCarbs += carbs;
                  mealCarbs["Total"] = (mealCarbs["Total"] ?? 0) + carbs;
                }

                if (proteins != null) {
                  totalProteins += proteins;
                  mealProteins["Total"] =
                      (mealProteins["Total"] ?? 0) + proteins;
                }
                if (fats != null) {
                  totalFats += fats;
                  mealFats["Total"] = (mealFats["Total"] ?? 0) + fats;
                }
              });

              return Column(
                children: [
                  // Container(
                  //   width: 100,
                  //   height: 100,
                  //   child: DChartPie(
                  //     data: [
                  //       {'domain': 'Flutter', 'measure': 28},
                  //       {'domain': 'React Native', 'measure': 27},
                  //       {'domain': 'Ionic', 'measure': 20},
                  //       {'domain': 'Cordova', 'measure': 15},
                  //     ],
                  //     fillColor: (pieData, index) => Colors.purple,
                  //   ),
                  // ),

                  // Container(
                  //   width: 200,
                  //   height: 200,
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     color: Colors.grey[300],
                  //   ),
                  //   child: CustomPaint(
                  //     painter: ProgressChartPainter(
                  //       targetPercentage: 80,
                  //       currentPercentage: 60,
                  //       strokeWidth: 10,
                  //       progressColor: Colors.red,
                  //     ),
                  //   ),
                  // ),
                  Text("Your Progress Today"),

                  Text("$totalCalories / $targetCalories cal"),
                  Container(
                    width: 200,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.grey[300],
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: totalCalories / targetCalories,
                      // 0.85, // Change this value to represent the progress
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: Colors.blue[300],
                        ),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Container(
                        height: 150, // Adjust the height as needed
                        width: 150, // Adjust the width as needed
                        child: SfCircularChart(
                          series: <CircularSeries>[
                            PieSeries<dynamic, String>(
                              dataSource: [
                                {'macro': 'Carbs', 'value': totalCarbs},
                                {'macro': 'Proteins', 'value': totalProteins},
                                {'macro': 'Fats', 'value': totalFats},
                              ],
                              xValueMapper: (dynamic data, _) => data['macro'],
                              yValueMapper: (dynamic data, _) => data['value'],
                              dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.inside,
                                textStyle: TextStyle(
                                  fontSize: 8,
                                  color: kWhite,
                                ),
                              ),
                              pointColorMapper: (dynamic data, _) {
                                switch (data['macro']) {
                                  case 'Carbs':
                                    return Colors.orange;
                                  case 'Proteins':
                                    return Colors.green;
                                  case 'Fats':
                                    return Colors.blue;
                                  default:
                                    return Colors.grey;
                                }
                              },
                              dataLabelMapper: (dynamic data, _) =>
                                  '${data['macro']} \n${data['value']}g',
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Calories: $totalCalories',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text('Total Carbs: $totalCarbs g'),
                          Text('Total Proteins: $totalProteins g'),
                          Text('Total Fats: $totalFats g'),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMealContainer(String title, String mealType, User user) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kWhite,
        // border: Border.all(color: kLightGreen),
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: kBlack,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const RecipeScreen()),
                  // );
                },
                child: const Text('Add Plan'),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection('users')
                .doc(user.email)
                .collection('planner')
                .doc(_formatDate(currentDate))
                .collection(_formatDate(currentDate))
                .where('mealType', isEqualTo: mealType)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Text("No Meal Found, ADD MEAL NOW"),
                  ),
                );
              }

              num totalCalories = 0;
              num totalCarbs = 0;
              num totalProteins = 0;
              num totalFats = 0;

              mealCalories[mealType] ??= 0; // Initialize to 0 if null
              mealCarbs[mealType] ??= 0; // Initialize to 0 if null
              mealProteins[mealType] ??= 0; // Initialize to 0 if null
              mealFats[mealType] ??= 0; // Initialize to 0 if null

              snapshot.data!.docs.forEach((doc) {
                var meal = doc.data() as Map<String, dynamic>;
                var calories = meal['calories'] as num?;
                var carbs = meal['carbohydrates'] as num?;
                var proteins = meal['proteins'] as num?;
                var fats = meal['fats'] as num?;

                if (calories != null) {
                  totalCalories += calories;
                  mealCalories[mealType] =
                      (mealCalories[mealType] ?? 0) + calories;
                }
                if (carbs != null) {
                  totalCarbs += carbs;
                  mealCarbs[mealType] = (mealCarbs[mealType] ?? 0) + carbs;
                }

                if (proteins != null) {
                  totalProteins += proteins;
                  mealProteins[mealType] =
                      (mealProteins[mealType] ?? 0) + proteins;
                }
                if (fats != null) {
                  totalFats += fats;
                  mealFats[mealType] = (mealFats[mealType] ?? 0) + fats;
                }
              });

              return Column(
                children: [
                  Text(
                    '$mealType Calories :  $totalCalories',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Text('Total Carbs: $totalCarbs'),
                  // Text('Total Proteins: $totalProteins'),
                  // Text('Total Fats: $totalFats'),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var meal = snapshot.data!.docs[index].data();
                      var documentId = snapshot.data!.docs[index].id;
                      return _buildMealPlanItem(meal, documentId, user.email);
                    },
                  ),
                  const SizedBox(height: 10.0),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMealPlanItem(meal, documentId, userEmail) {
    return Container(
      margin: EdgeInsets.all(4),
      // decoration: BoxDecoration(border: Border.all(color: kPrimaryGreen)),
      child: ListTile(
        title: Text(
          meal['mealName'],
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${meal['calories']} cal',
              style: const TextStyle(fontSize: 16.0),
            ),
            // Text(
            //   'Carbs: ${meal['carbohydrates']} g',
            //   style: const TextStyle(fontSize: 16.0),
            // ),
            // Text(
            //   'Proteins: ${meal['proteins']} g',
            //   style: const TextStyle(fontSize: 16.0),
            // ),
            // Text(
            //   'Fats: ${meal['fats']} g',
            //   style: const TextStyle(fontSize: 16.0),
            // ),
          ],
        ),
        leading: Image.network(
          meal['imageUrl'],
          width: 60.0,
          height: 60.0,
          fit: BoxFit.cover,
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.redAccent.shade200,
          ),
          onPressed: () {
            _confirmDeleteMeal(userEmail, documentId, _formatDate(currentDate));
          },
        ),
      ),
    );
  }

  // Widget _buildSummary(User user) {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: firestore
  //         .collection('users')
  //         .doc(user.email)
  //         .collection('planner')
  //         .doc(_formatDate(currentDate))
  //         .collection(_formatDate(currentDate))
  //         .snapshots(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const CircularProgressIndicator();
  //       }
  //       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  //         return const SizedBox();
  //       }
  //       num totalCalories = 0;
  //       snapshot.data!.docs.forEach((doc) {
  //         totalCalories += doc['calories'];
  //       });

  //       num targetCalories = 2000; // Set your target calories here

  //       return Column(
  //         children: [
  //           const Divider(),
  //           const SizedBox(height: 10.0),
  //           Text(
  //             'Total Calories: $totalCalories',
  //             style: const TextStyle(fontSize: 18.0),
  //           ),
  //           const SizedBox(height: 10.0),
  //           LinearProgressIndicator(
  //             value: totalCalories.toDouble() / targetCalories.toDouble(),
  //             backgroundColor: Colors.grey[200],
  //             valueColor: AlwaysStoppedAnimation<Color>(
  //               totalCalories > targetCalories ? Colors.red : Colors.green,
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date).toString();
  }
}
