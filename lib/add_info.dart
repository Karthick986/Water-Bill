import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'home.dart';

class AddInfo extends StatefulWidget {
  @override
  _AddInfoState createState() => _AddInfoState();
}

class _AddInfoState extends State<AddInfo> {
  File _imageFile;

  bool isLoading = false;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future<String> billPic;

  Future uploadImageToFirebase(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    String uid = FirebaseAuth.instance.currentUser.uid;

    String fileName = basename(_imageFile.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('BillPics/$uid/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);

    await uploadTask.then((res) async {
      var billPic = await res.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser.uid)
          .add({
        'cus_reading': reading,
        'cus_name': _currentItemSelected,
        'cus_billpic': billPic,
        'curr_reading': int.parse(reading) +10
      });

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));

      // await showDialog(
      //   context: context,
      //   builder: (ctx) => AlertDialog(
      //     title: Text(
      //       "More Information",
      //     ),
      //     content: Column(children: [
      //       Container(child: Text('Account No. \n '), padding: EdgeInsets.all(10.0),),
      //       Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      //         Container(child: Text('Last reading: '), padding: EdgeInsets.all(10.0),),
      //         Container(child: Text(reading), padding: EdgeInsets.all(10.0),),
      //       ]),
      //     ]),
      //     actions: <Widget>[
      //       FlatButton(
      //         onPressed: () {
      //           Navigator.pushReplacement(
      //               context, MaterialPageRoute(builder: (context) => Home()));
      //         },
      //         child: Text("Okay"),
      //       ),
      //     ],
      //   ),
      // );
    });
  }

  var _currentItemSelected = 'Select User';

  final formKey = new GlobalKey<FormState>();
  String reading;

  @override
  Widget build(BuildContext context) {
    void _submit() {
      formKey.currentState.save();
      final isValid = formKey.currentState.validate();
      if (!isValid) {
        return;
      }

      uploadImageToFirebase(context);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Add Information'),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Form(
                key: formKey,
                child: Column(children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                    margin: EdgeInsets.only(top: 25.0),
                    child: DropdownButton<String>(
                      items: <String>[
                        'Select User',
                        'Hemant Barapatre',
                        'Aman Thare',
                        'Kartik Kumar',
                        'Fakim Ansari',
                        'Rutuja Goud',
                        'Arun Gaddam',
                        'Priyal Wadhe',
                        'Fatema Masquerade',
                        'Tarun Tara',
                        'Ishika Jaiswal',
                        'Uma Gaikwad',
                        'Rahul Rathod',
                      ].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String newValueSelected) {
                        setState(() {
                          this._currentItemSelected = newValueSelected;
                          // if (_currentItemSelected == 'Select') {
                          //   _value=1.0;
                          //   errorMsg = "Choose to signup as a?";
                          // }
                        });
                      },
                      value: _currentItemSelected,
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Text(
                            'Choose Bill pic: ',
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 100.0,
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 20.0, bottom: 20.0),
                          child: ClipRRect(
                            child: (_imageFile != null)
                                ? Image.file(_imageFile)
                                : FlatButton(
                                    child: Icon(
                                      Icons.add_a_photo,
                                      size: 50,
                                    ),
                                    onPressed: pickImage,
                                  ),
                          ),
                        ),
                      ]),
                  Container(
                    width: 200.0,
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 15.0),
                      onChanged: (value) {},
                      onSaved: (value) => reading = value,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter current reading!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: " Current reading",
                        hintStyle: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ),
                  Center(
                      child: (isLoading)
                          ? Container(
                              child: CircularProgressIndicator(),
                              margin: EdgeInsets.all(30.0),
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  _submit();
                                });
                              },
                              child: Container(
                                width: 150,
                                height: 40,
                                margin:
                                    EdgeInsets.only(top: 30.0, bottom: 10.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(3, 3),
                                      blurRadius: 10,
                                    )
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ))
                ]))));
  }
}
