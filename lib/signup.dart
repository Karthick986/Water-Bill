import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'home.dart';
import 'main.dart';

class Signup extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Bill',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: _LoginPage(),
    );
  }
}

class _LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginPage> {
  @override
  bool _isHidden = true;

  final formKey = new GlobalKey<FormState>();
  bool isLoading = false;

  String email, password;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _submit() {
    formKey.currentState.save();
    final isValid = formKey.currentState.validate();
    if (!isValid) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    signUp(email: email, password: password)
        .then((result) {
      if (result == null) {
        Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(result),
            )
        );
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signUp({String email, String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {

    return Scaffold(
        key: _scaffoldKey,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      child: Text("Signup",
                          style: TextStyle(
                              fontSize: 20.0, fontFamily: 'Ubuntu-Bold', fontWeight: FontWeight.bold))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      child: Text("or create your account",
                          style: TextStyle(
                              fontSize: 15.0, fontFamily: 'Ubuntu-Regular'))),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(margin: EdgeInsets.only(left: 10.0, right: 10.0), child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.left,
                    onSaved: (value) => email = value,
                    validator: (input) => input.length == 0
                        ? "Enter email!"
                        : null,
                    style:
                    TextStyle(fontSize: 15.0),
                    onChanged: (value) {},
                    decoration: InputDecoration(
                        hintText: " Email",
                        hintStyle: TextStyle( fontSize: 15.0),
                        ),
                  ),),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(margin: EdgeInsets.only(left: 10.0, right: 10.0), child: TextFormField(
                    obscureText: _isHidden,
                    textAlign: TextAlign.left,
                    onSaved: (value) => password = value,
                    validator: (input) => input.length == 0
                        ? "Enter password!"
                        : null,
                    style:
                    TextStyle(fontSize: 15.0),
                    decoration: InputDecoration(
                        hintText: " Password",
                        suffix: InkWell(
                          onTap: () {
                            setState(() {
                              _isHidden = !_isHidden;
                            });
                          },
                          child: Icon(
                            _isHidden ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                        hintStyle: TextStyle(fontSize: 15.0),
                        ),
                  ),),
                  SizedBox(
                    height: 20.0,
                  ),
                  (isLoading) ? Container(child: CircularProgressIndicator(),) : Material(
                          elevation: 4,
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(5.0),
                          child: MaterialButton(
                            padding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            onPressed: () {
                              _submit();
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                  GestureDetector(child: Container(
                      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      margin: EdgeInsets.only(top: 15.0),
                      child: Text("Already Registered! Login here",
                          style: TextStyle(
                              fontSize: 14.0))),
                    onTap: () =>
                        Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => Login())),
                  ),
          ])
        ),
      ),
    ));
  }
}