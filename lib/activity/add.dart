import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddForm extends StatefulWidget {
  AddForm({this.email});
  final String email;
  @override
  _AddFormState createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  DateTime _dateTime = new DateTime.now();
  String _dateText = '';
  String newTask = '';
  String note = '';
  String category = '';
  Future<Null> selectDateTime(BuildContext context) async{
    final picked = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2012),
        lastDate: DateTime(2080)
    );
    if(picked != null){
      setState(() {
        _dateTime = picked;
        _dateText = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }
  void _addData(){
    Firestore.instance.runTransaction((Transaction transsaction)async{
      CollectionReference reference = Firestore.instance.collection('Note');
      await reference.add({
        "email" : widget.email,
        "title" : newTask,
        "datetime" : _dateTime,
        "note" : note,
        "category" : category,
      });
    });
    Navigator.pop(context);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateText = "${_dateTime.day}/${_dateTime.month}/${_dateTime.year}";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        color: Colors.blue,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Container(
                height: 50,
                width: double.infinity,
                child: Align(
                  alignment: Alignment.bottomCenter,
                    child: Text("My Notes",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "OpenSans",
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                    )
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Container(
                height: 500,
                margin: EdgeInsets.all(15.0),
                color: Colors.white30,
              ),
            )
          ],
        ),
      ),
    );
  }
}
