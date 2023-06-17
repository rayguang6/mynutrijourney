import 'package:flutter/material.dart';
import 'package:mynutrijourney/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<CalorieData> calorieData = [
    CalorieData(DateTime(2023, 5, 15), 1800),
    CalorieData(DateTime(2023, 5, 16), 2000),
    CalorieData(DateTime(2023, 5, 17), 2200),
    CalorieData(DateTime(2023, 5, 18), 1900),
    CalorieData(DateTime(2023, 5, 19), 2100),
    CalorieData(DateTime(2023, 5, 20), 2300),
    CalorieData(DateTime(2023, 5, 21), 2000),
  ];

  final int targetCalories = 2000;

  final List<MacroData> macroData = [
    MacroData('Fat', 35, Colors.red),
    MacroData('Carbs', 40, Colors.green),
    MacroData('Protein', 25, Colors.blue),
  ];

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Nutri Journey! ${user?.username}',
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
              backgroundImage: NetworkImage(user!.profileImage), // Replace with your profile image
            ),
          ),
        ],
        
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(children: [
                Text('Todays Calories Progress'),
                SizedBox(
                  height: 16,
                ),
                _buildProgressChart(2000, 1200),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Calorie Intake',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 200,
                    child: SfCartesianChart(
                      primaryXAxis: DateTimeAxis(),
                      series: <ChartSeries>[
                        LineSeries<CalorieData, DateTime>(
                          dataSource: calorieData,
                          xValueMapper: (CalorieData data, _) => data.date,
                          yValueMapper: (CalorieData data, _) =>
                              data.calories.toDouble(),
                          name: 'Calories',
                          markerSettings: MarkerSettings(isVisible: true),
                        ),
                        LineSeries<CalorieData, DateTime>(
                          dataSource: calorieData,
                          xValueMapper: (CalorieData data, _) => data.date,
                          yValueMapper: (CalorieData data, int index) =>
                              targetCalories.toDouble(),
                          name: 'Target',
                          markerSettings: MarkerSettings(isVisible: true),
                        ),
                      ],
                      legend: Legend(isVisible: true),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Macronutrient Distribution',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 200,
                    child: SfCircularChart(
                      series: <CircularSeries>[
                        PieSeries<MacroData, String>(
                          dataSource: macroData,
                          xValueMapper: (MacroData data, _) => data.macro,
                          yValueMapper: (MacroData data, _) =>
                              data.percentage.toDouble(),
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside,
                          ),
                          pointColorMapper: (MacroData data, _) => data.color,
                          dataLabelMapper: (MacroData data, _) =>
                              '${data.macro} (${data.percentage}%)',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Weight Progress',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _buildWeightChart(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalorieData {
  CalorieData(this.date, this.calories);
  final DateTime date;
  final int calories;
}

class MacroData {
  MacroData(this.macro, this.percentage, this.color);
  final String macro;
  final double percentage;
  final Color color;
}

//widget for progress chart
Widget _buildProgressChart(int targetCalories, int consumedCalories) {
  double progressPercentage = consumedCalories / targetCalories;

  return SizedBox(
    width: 200.0,
    height: 200.0,
    child: Stack(
      fit: StackFit.expand,
      children: [
        CircularProgressIndicator(
          value: progressPercentage,
          strokeWidth: 10.0,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Consumed',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '$consumedCalories kcal',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Target',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '$targetCalories kcal',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildWeightChart() {
  final List<WeightData> weightData = [
            WeightData(16, 66.1),
            WeightData(17, 65.3),
            WeightData(18, 63.6),
            WeightData(19, 65.8),
            WeightData(20, 67.1),
            WeightData(21, 66.5),
            WeightData(22, 65.9),
        ];

  return Container(
      height: 300.0,
      child: SfCartesianChart(series: <ChartSeries>[
        // Renders line chart
        LineSeries<WeightData, int>(
            dataSource: weightData,
            markerSettings: MarkerSettings(isVisible: true),
            xValueMapper: (WeightData data, _) => data.x,
            yValueMapper: (WeightData data, _) => data.y)
      ]));
}

class WeightData {
        WeightData(this.x, this.y);
        final int x;
        final double y;
    }