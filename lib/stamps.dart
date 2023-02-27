// ignore_for_file: prefer_const_constructors, file_names, deprecated_member_use

import 'dart:html';
import 'dart:convert';
import 'package:timestamp/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

CollectionReference firestore = FirebaseFirestore.instance.collection('users');
String userId = (FirebaseAuth.instance.currentUser)!.uid;

// ignore: use_key_in_widget_constructors
class SetProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SetProfileState();
  }
}

class SetProfileState extends State<SetProfile> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  String ttt = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      ttt;
    });
  }

  final fName = TextEditingController();
  final sName = TextEditingController();
  final eMail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int i = 2;
    List<String> entries = ttt.split(',');

    String stampname = DateTime.now().day.toString();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Set Profile"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: 80, left: 40, right: 40),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ////////////////////////////// First Name////////////////////

                    SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () {
                            firestore.doc(userId).update({
                              stampname: FieldValue.arrayUnion(
                                  [DateTime.now().toString().substring(0, 19)])
                            });
                            setState(() {
                              i++;
                              stampname;
                            });
                            setState(() {});
                            print(stampname);
                            i++;
                            firestore
                                .doc(userId)
                                .get()
                                .then((DocumentSnapshot documentSnapshot) {
                              if (documentSnapshot.exists) {
                                /* print(
                                    'Document data: ${documentSnapshot.data().toString()}'); */
                                setState(() {
                                  ttt = documentSnapshot
                                      .get(stampname)
                                      .toString()
                                      .substring(
                                          1,
                                          documentSnapshot
                                                  .get(stampname)
                                                  .toString()
                                                  .length -
                                              1);
                                });
                              } else {
                                print(
                                    'Document does not exist on the database');
                              }
                            });
                            fName.clear();
                          },
                          child: Text(
                            "Buchen",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        )),

                    Wrap(
                      direction: Axis.vertical,
                      children: entries.map((i) => Text('$i')).toList(),
                    )
                    ////////////////////////// Steps //////////////////////////
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
