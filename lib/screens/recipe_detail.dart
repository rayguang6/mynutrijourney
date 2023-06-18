import 'package:flutter/material.dart';

import '../utils/constants.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipeId = recipe['recipeId'].toString();
    final title = recipe['title'].toString();
    final description = recipe['description'].toString();
    final image = recipe['image'].toString();
    final calories = double.parse(recipe['calories'].toString());
    final fats = double.parse(recipe['fats'].toString());
    final proteins = double.parse(recipe['proteins'].toString());
    final carbohydrates = double.parse(recipe['carbohydrates'].toString());
    final time = int.parse(recipe['time'].toString());
    final uid = recipe['uid'].toString();
    final createdBy = recipe['createdBy'].toString();
    final instructions = recipe['instructions'].toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: kPrimaryGreen,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(image),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(description),
                  const SizedBox(height: 16),
                  const Text(
                    'Nutritional Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNutritionItem('Calories', calories),
                      _buildNutritionItem('Fats', fats),
                      _buildNutritionItem('Proteins', proteins),
                      _buildNutritionItem('Carbohydrates', carbohydrates),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Time',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('$time mins'),
                  const SizedBox(height: 16),
                  const Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(instructions),
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   itemCount: instructions.length,
                  //   itemBuilder: (context, index) {
                  //     final stepNumber = index + 1;
                  //     final instruction = instructions[index];
                  //     return ListTile(
                  //       leading: CircleAvatar(
                  //         backgroundColor: kPrimaryGreen,
                  //         child: Text(
                  //           '$stepNumber',
                  //           style: const TextStyle(color: Colors.white),
                  //         ),
                  //       ),
                  //       title: Text(instruction),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionItem(String label, double value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(value.toString()),
      ],
    );
  }
}
