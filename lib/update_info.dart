import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'home.dart';

class UpdateInfo extends StatefulWidget {

  final String uid, name, reading, billPic;
  UpdateInfo(this.uid, this.name, this.reading, this.billPic);

  @override
  _UpdateInfoState createState() => _UpdateInfoState();
}

class _UpdateInfoState extends State<UpdateInfo> {
  File _imageFile;

  bool isLoading= false;
  final picker = ImagePicker();

  // Future pickImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.camera);
  //
  //   setState(() {
  //     _imageFile = File(pickedFile.path);
  //   });
  // }
  String name, reading, usage;

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(_imageFile.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    uploadTask.then((res) {
      res.ref.getDownloadURL();
    });
  }

  var _currentItemSelected = 'Select Area';
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    bool cityUpdated = false;
    _currentItemSelected = widget.name;

    void _submit() {

      formKey.currentState.save();
      final isValid = formKey.currentState.validate();
      if (!isValid) {
        return;
      }

      setState(() {
        isLoading = true;
        FirebaseFirestore.instance
            .collection(FirebaseAuth.instance.currentUser.uid).doc(widget.uid)
            .update({'cus_name': name, 'cus_reading': reading, 'cus_use': usage, 'cus_city': _currentItemSelected, 'cus_billpic': widget.billPic});

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      });
  }

    return Scaffold(
        appBar: AppBar(
          title: Text('Update Information'),
        ),
        body: SingleChildScrollView(padding: EdgeInsets.all(10.0), child: Form(key: formKey, child: Column(children: [
            Container(
              alignment: Alignment.center,
              height: 100.0,
              margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0, bottom: 20.0),
              child: ClipRRect(
                child: (widget.billPic != null) ? Image.network(widget.billPic) : Icon(
                          Icons.add_a_photo,
                          size: 50,
                        ),
                        // onPressed:
                        // pickImage,
                      // ),
              ),
            ),
      Padding(
        padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
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
              child: new Container(width: MediaQuery.of(context).size.width*0.75, child: Text(
                value,
                style: TextStyle( fontSize: 15),
              ),
            ));
          }).toList(),
          onChanged: (String newValueSelected) {
            setState(() {
              cityUpdated = true;
              this._currentItemSelected = newValueSelected;
              // if (_currentItemSelected == 'Select') {
              //   _value=1.0;
              //   errorMsg = "Choose to signup as a?";
              // }
            });
          },
          value: (cityUpdated) ? _currentItemSelected : widget.name,
        ),
      ),
          //uploadImageButton(context),
          Container(margin: EdgeInsets.only(left: 20.0, right: 20.0), child: TextFormField(
            keyboardType: TextInputType.name,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15.0),
            initialValue: widget.name,
            onChanged: (value) {},
            onSaved: (value) => name = value,
            validator: (value) {
              if (value.isEmpty) {
                return 'Enter name!';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: " Full Name",
              hintStyle: TextStyle( fontSize: 15.0),
            ),
          ),),
          Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 10.0, top: 10.0),
                        padding: EdgeInsets.only(
                            left: 5.0, right: 5.0),
                        child: TextFormField(
                          keyboardType:
                          TextInputType.number,
                          initialValue: widget.reading,
                          onSaved: (value) => reading = value,
                          // initialValue: setInfo(
                          //     bModel.firstName),
                          // textAlign: TextAlign.left,
                          // onSaved: (value) =>
                          // fName = value,
                          onFieldSubmitted:
                              (value) {},
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter reading!';
                            }
                            return null;
                          },
                          style: TextStyle(
                              fontSize: 13.0),
                          onChanged: (value) {},
                          decoration:
                          InputDecoration(
                            hintText:
                            " Last reading ",
                            hintStyle: TextStyle(
                                fontFamily:
                                'Ubuntu-Regular',
                                fontSize: 13.0),
                            // border: OutlineInputBorder(
                            //     borderRadius:
                            //         BorderRadius.all(
                            //             Radius.circular(
                            //                 5.0)))
                          ),
                        ),
                      ),
                ),
                SizedBox(
                  width: 7.0,
                ),
                Expanded(
                  child:
                      Container(
                        margin: EdgeInsets.only(
                            right: 12.0, top: 10.0),
                        padding: EdgeInsets.only(
                            left: 5.0, right: 5.0),
                        child: TextFormField(
                          keyboardType:
                          TextInputType.number,
                          initialValue: widget.reading,
                          onSaved: (value) => usage = value,
                          // initialValue: setInfo(
                          //     bModel.middleName),
                          // textAlign: TextAlign.left,
                          // onSaved: (value) =>
                          // mName = value,
                          onFieldSubmitted:
                              (value) {},
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter usage!';
                            }
                            return null;
                          },
                          style: TextStyle(
                              fontSize: 13.0),
                          onChanged: (value) {},
                          decoration:
                          InputDecoration(
                            hintText:
                            " Current Use",
                            hintStyle: TextStyle(
                                fontSize: 13.0),
                          ),
                        ),
                      ),
                ),
              ]),
          Center(
            child: (isLoading)
                ? Container(
              child: CircularProgressIndicator(),
              margin: EdgeInsets.all(20.0),
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
                margin: EdgeInsets.only(
                    top: 30.0, bottom: 10.0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius:
                  BorderRadius.circular(
                      50),
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
                    'Save',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,),
                  ),
                ),
              ),
            ))
        ]))));
  }

  // Widget uploadImageButton(BuildContext context) {
  //   return Container(
  //     child: Stack(
  //       children: <Widget>[
  //         Container(
  //           padding:
  //               const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
  //           margin: const EdgeInsets.only(
  //               top: 30, left: 20.0, right: 20.0, bottom: 20.0),
  //           child: FlatButton(
  //             onPressed: () => uploadImageToFirebase(context),
  //             child: Text(
  //               "Upload Image",
  //               style: TextStyle(fontSize: 20),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
