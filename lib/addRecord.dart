import 'package:flutter/material.dart';
import 'constants.dart';

class AddRecord extends StatefulWidget {
  final RecordType type;
  const AddRecord({ Key? key, required this.type }) : super(key: key);

  @override
  _AddRecordState createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add ' + widget.type.stringValue)), body: AddRecordForm());
  }
}

class AddRecordForm extends StatefulWidget {
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
        RecordTextField(type: TextFieldType.amount),
        RecordTextField(type: TextFieldType.description),
        RecordTextField(type: TextFieldType.date),
        AddButton()
      ],
    );
  }
}

class RecordTextField extends StatefulWidget {
  final TextFieldType type;
  const RecordTextField({ Key? key, required this.type }) : super(key: key);

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
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: widget.type.labelTextValue,
            alignLabelWithHint: true),
      ),
    ));
  }
}

// class RecordTextField extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: Padding(
//       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//       child: TextFormField(
//         textAlign: TextAlign.center,
//         decoration: InputDecoration(
//             border: UnderlineInputBorder(),
//             labelText: 'Enter amount',
//             alignLabelWithHint: true),
//       ),
//     ));
//   }
// }

class AddButton extends StatelessWidget {
  const AddButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Align(
            alignment: Alignment.center,
            child: TextButton(
                onPressed: () {},
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
