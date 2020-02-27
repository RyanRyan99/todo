import 'package:flutter/material.dart';
import 'package:todo/activity/add.dart';
import 'package:todo/login/login_page.dart';
import 'package:todo/login/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'activity/detail.dart';
import 'activity/edit.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //
  void _signOut(){
    AlertDialog alertDialog = new AlertDialog(
      content: Container(
        height: 250.0,
        child: new Column(
          children: <Widget>[
            ClipOval(
              child: new Image.network(imageUrl),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Apakah Anda Yakin ?",style: new TextStyle(fontSize: 16.0),),
            ),
            new Divider(),
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    height: 30,
                    child: RaisedButton(
                      color: Colors.blue,
                      splashColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text("Yes", style: TextStyle(color: Colors.white, fontFamily: "OpenSans"),),
                      onPressed: (){
                        signOutGoogle();
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                            builder: (context) {return LoginPage();}), ModalRoute.withName('/'));
                      },
                    ),
                  ),
                  SizedBox(width: 55),
                  Container(
                    height: 30,
                    child: RaisedButton(
                      color: Colors.blue,
                      splashColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text("No", style: TextStyle(color: Colors.white, fontFamily: "OpenSans"),),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
    showDialog(context: context,child: alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = new DateTime.now();
    DateFormat formated = new DateFormat('dd-MMMM-yyyy');
    String formatin = formated.format(today);
    print(formatin);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        splashColor: Colors.blue,
        child: Icon(Icons.library_books, size: 30, color: Colors.blue,),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => new AddForm(email:email)));
        },
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Colors.blue[100], Colors.blue[400]],
          ),
        ),
        child: new Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.only(bottom: 430, right: 30),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 35,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 215, right: 10),
               child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 25,
                  child: RaisedButton(
                    splashColor: Colors.blue,
                    elevation: 0,
                    color: Colors.transparent,
                    child: Text("Logout", style: TextStyle(color: Colors.white,fontFamily: "OpenSans"),),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: Colors.white)
                    ),
                    onPressed: (){
                      _signOut();
                    },
                  ),
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.only(top: 100, left: 30),
              child: Container(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          new Text("Hallo,",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontFamily: "OpenSans",
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          new Text(name,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "OpenSans",
                                fontSize: 28,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            "Hari Ini Kelihatan Bagus",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: "OpenSans",
                            ),
                          ),
                          new Text(
                            "Cek Apa Yang Ingin Kamu Selesaikan Hari Ini",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: "OpenSans",
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            child: Row(
                              children: <Widget>[
                                new Text(
                                  "Hari Ini : ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: "OpenSans",
                                  ),
                                ),
                                new Text(
                                  formatin,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "OpenSans",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 250),
              child: Container(
                child: Column(
                  children: <Widget>[
                     StreamBuilder(
                       stream: Firestore.instance
                           .collection("Todo")
                           .where("email", isEqualTo: email).snapshots(),
                       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                         if(!snapshot.hasData)
                           return new Container(
                             child: Center(
                               child: CircularProgressIndicator(),
                             ),
                           );
                         return new CardList(document: snapshot.data.documents,);
                       },
                     )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _Card(){
    return Container(
      child: Column(
        children: <Widget>[
          Card(
            child: new Stack(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            new Text("2020",style: TextStyle(color: Colors.white,fontSize: 14, fontWeight: FontWeight.bold),),
                            new Text("15",style: TextStyle(color: Colors.white,fontSize: 24, fontWeight: FontWeight.bold),),
                            new Text("FEB",style: TextStyle(color: Colors.white,fontSize: 14, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4))
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text("Besok Kamis", style: TextStyle(color: Colors.blue, fontFamily: "OpenSans", fontSize: 18, fontWeight: FontWeight.bold),),
                            new Text("Harus Bawa ", style: TextStyle(fontFamily: "OpenSans")),
                            new Text("Bawa", style: TextStyle(fontFamily: "OpenSans")),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, right: 8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 30,
                      width: 70,
                      child: RaisedButton(
                        splashColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        color: Colors.blue,
                        child: Text("Edit",style: TextStyle(color: Colors.white, fontSize: 11, fontFamily: "OpenSans"),),
                        onPressed: (){},
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Card(
            child: new Stack(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            new Text("2020",style: TextStyle(color: Colors.white,fontSize: 14, fontWeight: FontWeight.bold),),
                            new Text("15",style: TextStyle(color: Colors.white,fontSize: 24, fontWeight: FontWeight.bold),),
                            new Text("FEB",style: TextStyle(color: Colors.white,fontSize: 14, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4))
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text("Some Text", style: TextStyle(color: Colors.blue, fontFamily: "OpenSans", fontSize: 18, fontWeight: FontWeight.bold),),
                            new Text("Just Text"),
                            new Text("Only Text"),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, right: 8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 30,
                      width: 70,
                      child: RaisedButton(
                        splashColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        color: Colors.blue,
                        child: Text("Edit",style: TextStyle(color: Colors.white, fontSize: 11),),
                        onPressed: (){},
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Card(
            child: new Stack(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            new Text("2020",style: TextStyle(color: Colors.white,fontSize: 14, fontWeight: FontWeight.bold),),
                            new Text("15",style: TextStyle(color: Colors.white,fontSize: 24, fontWeight: FontWeight.bold),),
                            new Text("FEB",style: TextStyle(color: Colors.white,fontSize: 14, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4))
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text("Some Text", style: TextStyle(color: Colors.blue, fontFamily: "OpenSans", fontSize: 18, fontWeight: FontWeight.bold),),
                            new Text("Just Text"),
                            new Text("Only Text"),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, right: 8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 30,
                      width: 70,
                      child: RaisedButton(
                        splashColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        color: Colors.blue,
                        child: Text("Edit",style: TextStyle(color: Colors.white, fontSize: 11),),
                        onPressed: (){},
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Card(
            child: new Stack(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            new Text("2020",style: TextStyle(color: Colors.white,fontSize: 14, fontWeight: FontWeight.bold),),
                            new Text("15",style: TextStyle(color: Colors.white,fontSize: 24, fontWeight: FontWeight.bold),),
                            new Text("FEB",style: TextStyle(color: Colors.white,fontSize: 14, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4))
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text("Some Text", style: TextStyle(color: Colors.blue, fontFamily: "OpenSans", fontSize: 18, fontWeight: FontWeight.bold),),
                            new Text("Just Text"),
                            new Text("Only Text"),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, right: 8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 30,
                      width: 70,
                      child: RaisedButton(
                        splashColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        color: Colors.blue,
                        child: Text("Edit",style: TextStyle(color: Colors.white, fontSize: 11),),
                        onPressed: (){},
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Card(
            child: new Stack(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            new Text("2020",style: TextStyle(color: Colors.white,fontSize: 14, fontWeight: FontWeight.bold),),
                            new Text("15",style: TextStyle(color: Colors.white,fontSize: 24, fontWeight: FontWeight.bold),),
                            new Text("FEB",style: TextStyle(color: Colors.white,fontSize: 14, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4))
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text("Some Text", style: TextStyle(color: Colors.blue, fontFamily: "OpenSans", fontSize: 18, fontWeight: FontWeight.bold),),
                            new Text("Just Text"),
                            new Text("Only Text"),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, right: 8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 30,
                      width: 70,
                      child: RaisedButton(
                        splashColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        color: Colors.blue,
                        child: Text("Edit",style: TextStyle(color: Colors.white, fontSize: 11),),
                        onPressed: (){},
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardList extends StatelessWidget {
  CardList({this.document});
  final List<DocumentSnapshot> document;
  @override
  Widget build(BuildContext context){
    return Container(
      height: 350,
      child: new ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: document.length,
        itemBuilder: (BuildContext context, int i){
          String title = document[i].data['title'].toString();
          String note = document[i].data['note'].toString();
          DateTime time = document[i].data['datetime'].toDate();
          DateFormat forma = new DateFormat('MMM');
          String formattrd = forma.format(time);
          print(formattrd);
          return Dismissible(
            key: new Key(document[i].documentID),
            onDismissed: (direction){
              Firestore.instance.runTransaction((transaction)async{
                DocumentSnapshot snapshot = await transaction.get(document[i].reference);
                await transaction.delete(snapshot.reference);
              });
              Scaffold.of(context).showSnackBar(
                  new  SnackBar(content: new Text("Data Berhasil Dihapus"))
              );
            },
            child: InkWell(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=> new Detail())
                );
              },
              child: Card(
                child: new Stack(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                new Text(time.year.toString(),style: TextStyle(color: Colors.white,fontSize: 14, fontWeight: FontWeight.bold),),
                                new Text(time.day.toString(),style: TextStyle(color: Colors.white,fontSize: 24, fontWeight: FontWeight.bold),),
                                new Text(formattrd.toString().toString(),style: TextStyle(color: Colors.white,fontSize: 14, fontWeight: FontWeight.bold),),
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4))
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(title, style: TextStyle(color: Colors.blue, fontFamily: "OpenSans", fontSize: 18, fontWeight: FontWeight.bold),),
                                new Text(note.toString(), style: TextStyle(fontFamily: "OpenSans")),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25, right: 8),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: 30,
                          width: 70,
                          child: RaisedButton(
                            splashColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            color: Colors.blue,
                            child: Text("Edit",style: TextStyle(color: Colors.white, fontSize: 11, fontFamily: "OpenSans"),),
                            onPressed: (){
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (BuildContext context) => new EditForm(
                                    title: title,
                                    note: note,
                                    datetime: document[i].data['datetime'].toDate(),
                                    index: document[i].reference,
                                  ))
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}














