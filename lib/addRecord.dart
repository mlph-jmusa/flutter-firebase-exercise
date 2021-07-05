import 'package:flutter/material.dart';

class AddRecord extends StatelessWidget {
  const AddRecord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add Expense')), body: MyCustomForm());
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RecordTextField(),
        RecordTextField(),
        RecordTextField()
      ],
    );
  }
}

class RecordTextField extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: TextFormField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Enter amount',
          alignLabelWithHint: true
        ),
      ),
    ));
  }
}
