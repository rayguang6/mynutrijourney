import 'package:flutter/material.dart';

//to create answer options button

class AnswerButton extends StatelessWidget {
  final VoidCallback selectHandler;
  final String answerText;

  AnswerButton(this.selectHandler, this.answerText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        // color: Colors.blue,
        // textColor: Colors.white,
        onPressed: selectHandler,
        child: Text(answerText),
      ),
    );
  }
}
