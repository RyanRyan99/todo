import 'package:flutter/material.dart';
import 'package:todo/home.dart';
import 'signin.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: new Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 30),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      "Hallo,",
                      style: TextStyle(
                        fontFamily: "OpenSans",
                        color: Colors.blue,
                        fontSize: 34,
                      ),
                    ),
                    new Text("Ayo Selesaikan Tugas Anda,",
                    style: TextStyle(
                      fontFamily: "OpenSans",
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 500),
               child: Align(
                alignment: Alignment.center,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: 250,
                        child: new RaisedButton(
                          splashColor: Colors.white70,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          color: Colors.blue,
                          child: Text("Masuk", style: TextStyle(color: Colors.white),
                          ),
                          onPressed: (){
                            signInWithGoogle().whenComplete((){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                return HomePage();
                              }));
                            });
                          },
                        ),
                      ),
                      new Text("Masuk Dengan Akun Google Anda",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
