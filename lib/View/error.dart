import 'package:flutter/material.dart';

class CustomError extends StatelessWidget {
  const CustomError({Key? key, required this.errorMessage}) : super(key: key);
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Text(errorMessage,
            style: TextStyle(fontSize: 30), textAlign: TextAlign.center),
      ),
    );
  }
}
