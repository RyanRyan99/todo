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
      CollectionReference reference = Firestore.instance.collection('Todo');
      await reference.add({
        "email" : widget.email,
        "title" : newTask,
        "datetime" : _dateTime,
        "note" : note,
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Colors.blue[100], Colors.blue[500]],
          ),
        ),
        child: SingleChildScrollView(
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
                  width: double.infinity,
                  height: 500,
                  margin: EdgeInsets.all(15.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                           child: TextField(
                             style: TextStyle(color: Colors.white),
                             onChanged: (String str){
                               setState(() {
                                  newTask=str;
                               });
                             },
                             cursorColor: Colors.blue,
                             decoration: InputDecoration(
                                hintText: "Judul Todo",
                                hintStyle: TextStyle(color: Colors.white, fontFamily: "OpenSans", fontWeight: FontWeight.bold),
                                prefixIcon: Icon(Icons.library_books, color: Colors.white,),
                                border:InputBorder.none
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white30,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          child: TextField(
                            showCursor: false,
                            onTap: ()=>selectDateTime(context),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.date_range, color: Colors.white,),
                              hintText: _dateText,
                              hintStyle: TextStyle(fontSize: 19, color: Colors.white),
                              border: InputBorder.none,
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white30,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                           child: TextField(
                             style: TextStyle(color: Colors.white),
                             onChanged: (String str){
                               setState(() {
                                 note=str;
                               });
                             },
                            decoration: InputDecoration(
                              hintText: "Isi Todo",
                                hintStyle: TextStyle(color: Colors.white, fontFamily: "OpenSans", fontWeight: FontWeight.bold),
                                prefixIcon: Icon(Icons.library_books, color: Colors.white,),
                                border:InputBorder.none
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white30,
                          ),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 20, right: 10, bottom: 10),
                                height: 30,
                                 child: RaisedButton(
                                   color: Colors.blue,
                                   child: Text("Save",style: TextStyle(color: Colors.white, fontFamily: "OpenSans"),),
                                   onPressed: (){
                                     _addData();
                                   },
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(20),
                                     side: BorderSide(color: Colors.white30)
                                   ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20, right: 10, bottom: 10),
                                height: 30,
                                child: RaisedButton(
                                  color: Colors.blue,
                                  child: Text("No",style: TextStyle(color: Colors.white, fontFamily: "OpenSans"),),
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(color: Colors.white30)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
