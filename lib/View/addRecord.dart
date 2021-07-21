import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/Extras/constants.dart';
import '/Extras/extensions.dart';
import '/Model/Record.dart';
import '../main.dart';

class AddRecord extends StatefulWidget {
  final Record record;

  const AddRecord({Key? key, required this.record}) : super(key: key);

  @override
  _AddRecordState createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  final amountController = TextEditingController();
  final descController = TextEditingController();
  late Record record;

  @override
  void initState() {
    record = widget.record;
    amountController.text = record.amount.toString();
    descController.text = record.desc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add ' + widget.record.type.stringValue)),
        body: AddRecordForm(
            amountController: amountController,
            descController: descController,
            record: record));
  }
}

class AddRecordForm extends StatefulWidget {
  final TextEditingController amountController;
  final TextEditingController descController;
  final Record record;

  const AddRecordForm(
      {Key? key,
      required this.amountController,
      required this.descController,
      required this.record})
      : super(key: key);

  @override
  AddRecordFormState createState() {
    return AddRecordFormState();
  }
}

class AddRecordFormState extends State<AddRecordForm> {
  late Record record;
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    record = widget.record;
    widget.amountController.text =
        record.amount <= 0.0 ? "" : record.amount.toString();
    widget.descController.text = record.desc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RecordTextField(
              type: TextFieldType.amount,
              controller: widget.amountController,
              onTextChanged: (text) {
                record.amount = double.tryParse(text) ?? 0.0;
              },
              formKey: formkey,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter amount";
                }

                if (!value.isNumeric()) {
                  return "Please enter numbers only";
                }

                return null;
              }),
          RecordTextField(
              type: TextFieldType.description,
              controller: widget.descController,
              onTextChanged: (text) {
                record.desc = text;
              },
              formKey: formkey,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter description";
                }

                return null;
              }),
          DateWidget(
              selectedDate: record.createdAt,
              onSelect: (selectedDate) {
                var now = DateTime.now();
                if (DateTime(now.year, now.month, now.day)
                        .difference(DateTime(selectedDate.year,
                            selectedDate.month, selectedDate.day))
                        .inDays ==
                    0) {
                  record.createdAt = now;
                  return;
                }
                record.createdAt = selectedDate;
              }),
          AddButton(record: record, formKey: formkey)
        ],
      ),
    );
  }
}

class RecordTextField extends StatefulWidget {
  final TextFieldType type;
  final TextEditingController? controller;
  final Function(String text) onTextChanged;
  final GlobalKey<FormState> formKey;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const RecordTextField(
      {Key? key,
      required this.type,
      required this.controller,
      required this.onTextChanged,
      required this.formKey,
      this.keyboardType,
      required this.validator})
      : super(key: key);

  @override
  _RecordTextFieldState createState() => _RecordTextFieldState();
}

class _RecordTextFieldState extends State<RecordTextField> {
  late Function(String text) onTextChanged;

  @override
  void initState() {
    onTextChanged = widget.onTextChanged;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: TextFormField(
        keyboardType: widget.keyboardType ?? TextInputType.text,
        validator: widget.validator,
        onChanged: (text) {
          onTextChanged(text);
        },
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
  final Record record;
  final GlobalKey<FormState> formKey;
  const AddButton({Key? key, required this.record, required this.formKey})
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
                  if (formKey.currentState?.validate() == true) {
                    FirebaseFirestore.instance.collection('records').add({
                      'type': record.type.intValue,
                      'amount': record.amount,
                      'desc': record.desc,
                      'createdAt': record.createdAt,
                      'oldTotalMoneyOnHand': remainingTotalMoneyOnHand,
                      'newTotalMoneyOnHand': (remainingTotalMoneyOnHand + (record.type == RecordType.expense ? (record.amount * -1) : record.amount)) 
                    }).then((value) => {Navigator.pop(context)});
                  }
                },
                child: Text(
                  'Confirm',
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

class DateWidget extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime date) onSelect;
  const DateWidget(
      {Key? key, required this.selectedDate, required this.onSelect})
      : super(key: key);

  @override
  _DateWidgetState createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  late DateTime selectedDate;
  late Function(DateTime date) onSelect;

  @override
  void initState() {
    selectedDate = widget.selectedDate;
    onSelect = widget.onSelect;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: OutlinedButton(
        style: ButtonStyle(
            fixedSize:
                MaterialStateProperty.all<Size>(Size(size.width * 0.9, 50))),
        onPressed: () {
          showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2017, 1, 1),
                  lastDate: DateTime.now())
              .then((value) => {
                    onSelect(value!),
                    setState(() {
                      selectedDate = value;
                    })
                  });
        },
        child: Text(formatDate(selectedDate),
            textAlign: TextAlign.left, style: TextStyle(color: Colors.black)),
      ),
    ));
  }
  // void updateSelectedDate(DateTime date) {
  //   widget.selectedDate = date
  // }
}
