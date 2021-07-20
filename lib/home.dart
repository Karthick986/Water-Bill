import 'package:flutter/scheduler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'add_info.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser.uid).snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddInfo()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: Text('Water Bill'),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return (!snapshot.hasData)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: snapshot.data.docs.map((document) {
                    return InkWell(
                        child: Card(
                          elevation: 4.0,
                          margin: EdgeInsets.all(10.0),
                          shadowColor: Colors.black26,
                          child: Column(
                            children: [
                              Container(
                                child: Text(
                                  document['cus_name'],
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                margin: EdgeInsets.all(7.0),
                                alignment: Alignment.centerLeft,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      child: Text('Reading: ' +
                                          document['cus_reading']),
                                      margin: EdgeInsets.all(7.0)),
                                  Container(
                                      child:
                                          Text('Usage: 10 units'),
                                      margin: EdgeInsets.all(7.0)),
                                ],
                              )
                            ],
                          ),
                        ),
                        onTap: () {

                      showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(
                          "More Information",
                        ),
                        content: Column(mainAxisSize: MainAxisSize.min, children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                            Container(child: Text('Account No. '), padding: EdgeInsets.all(10.0),),
                            Container(child: Text('12345'), padding: EdgeInsets.all(10.0),),
                          ]),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Container(child: Text('Last reading: '), padding: EdgeInsets.all(10.0),),
                            Container(child: Text(document.get('cus_reading')), padding: EdgeInsets.all(10.0),),
                          ]),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Container(child: Text('Last reading: '), padding: EdgeInsets.all(10.0),),
                            Container(child: Text(document.get('curr_reading').toString()), padding: EdgeInsets.all(10.0),),
                          ]),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Container(child: Text('Usable unit: '), padding: EdgeInsets.all(10.0),),
                            Container(child: Text('10'), padding: EdgeInsets.all(10.0),),
                          ]),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Container(child: Text('Rate/unit: '), padding: EdgeInsets.all(10.0),),
                            Container(child: Text('5.5'), padding: EdgeInsets.all(10.0),),
                          ]),
                          Container(height: 1, color: Colors.black12, margin: EdgeInsets.only(top: 20.0),),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Container(child: Text('Total Bill: ', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),), padding: EdgeInsets.all(10.0),),
                            Container(child: Text('Rs. 55',style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)), padding: EdgeInsets.all(10.0),),
                          ]),
                        ]),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              SchedulerBinding.instance.addPostFrameCallback((_) {
                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (context) => Home()));
                              });
                            },
                            child: Text("Okay"),
                          ),
                        ],
                      ),
                    );});
                  }).toList(),
                );
        },
      ),
    );
  }
}
