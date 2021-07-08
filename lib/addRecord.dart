// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class AddRecord extends StatefulWidget {
  final RecordType type;

  const AddRecord({Key? key, required this.type}) : super(key: key);

  @override
  _AddRecordState createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  final amountController = TextEditingController();
  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add ' + widget.type.stringValue)),
        body: AddRecordForm(
            amountController: amountController,
            descController: descController));
  }
}

class AddRecordForm extends StatefulWidget {
  final TextEditingController amountController;
  final TextEditingController descController;
  // final

  const AddRecordForm(
      {Key? key, required this.amountController, required this.descController})
      : super(key: key);

  @override
  AddRecordFormState createState() {
    return AddRecordFormState();
  }
}

class AddRecordFormState extends State<AddRecordForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RecordTextField(
            type: TextFieldType.amount, controller: widget.amountController),
        RecordTextField(
            type: TextFieldType.description, controller: widget.descController),
        DateButton(),
        AddButton(
          amountController: widget.amountController,
          descController: widget.descController,
        )
      ],
    );
  }
}

class RecordTextField extends StatefulWidget {
  final TextFieldType type;
  final TextEditingController? controller;
  const RecordTextField({Key? key, required this.type, this.controller})
      : super(key: key);

  @override
  _RecordTextFieldState createState() => _RecordTextFieldState();
}

class _RecordTextFieldState extends State<RecordTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: TextFormField(
        controller: widget.controller,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: widget.type.labelTextValue,
            alignLabelWithHint: true),
      ),
    ));
  }
}

class AddButton extends StatelessWidget {
  final TextEditingController amountController;
  final TextEditingController descController;
  const AddButton(
      {Key? key, required this.amountController, required this.descController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Align(
            alignment: Alignment.center,
            child: TextButton(
                onPressed: () {
                  // FirebaseFirestore.instance.collection('records').add({
                  //   'amount': amountController.text,
                  //   'desc': descController.text,
                  //   'createdAt': DateTime.now(),
                  //   'updatedAt': DateTime.now()
                  // }).then((value) => {
                  //   Navigator.pop(context)
                  // });
                },
                child: Text(
                  'ADD',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                        Size(size.width * 0.6, 55)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue)))),
      ),
    );
  }
}

class DateButton extends StatelessWidget {
  const DateButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: OutlinedButton(
      onPressed: () {
        showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020, 1, 1),
            lastDate: DateTime(2022, 2, 2));
      },
      child: Text('Date lamang'),
    ));
  }
}
