/* 
 @authors:
 Abdul Wahhab Alfaghiri Al Anzi   01524445
 Nouzad Mohammad                  00820679
*/
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timestamp/homescreen.dart';
import 'package:timestamp/registrationscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timestamp/stamps.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'UserModel.dart';
CollectionReference firestore = FirebaseFirestore.instance.collection('users');
String userId = (FirebaseAuth.instance.currentUser)!.uid;
String getDayOfWeek(int weekday) {
  switch (weekday) {
    case 1:
      return 'Sonntag';
    case 2:
      return 'Montag';
    case 3:
      return 'Dienstag';
    case 4:
      return 'Mittwoch';
    case 5:
      return 'Donnerstag';
    case 6:
      return 'Freitag';
    case 7:
      return 'Samsatg';
    default:
      return 'Unknown';
  }
}

String getMonth(int weekday) {
  switch (weekday) {
    case 1:
      return 'Jan.';
    case 2:
      return 'Feb.';
    case 3:
      return 'März';
    case 4:
      return 'Apr.';
    case 5:
      return 'Mai';
    case 6:
      return 'Jun.';
    case 7:
      return 'Jul.';
    case 8:
      return 'Aug.';
    case 9:
      return 'Sept.';
    case 10:
      return 'Okt.';
    case 11:
      return 'Nov.';
    case 12:
      return 'Dez.';
    default:
      return 'Unknown';
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  DateTime _currentTime = DateTime.now();
  late Timer _timer;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  String sec = DateTime.now().second.toString();
  @override
  void initState() {
    super.initState();
    startTimer();
    setState(() {
      sec;
    });
  }

  Future<void> launchLink(String url, {bool isNewTab = true}) async {
    await launchUrl(
      Uri.parse(url),
      webOnlyWindowName: isNewTab ? '_blank' : '_self',
    );
  }

  _launchURL() async {
    const url = 'https://flutter.io';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  void startTimer() {
    // Set the timer to tick every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Update the current time and redraw the clock
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  String stampname = 'holidays';
  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  // firebase
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation

          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white24,
          prefixIcon: Icon(Icons.person),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Benutzername",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white24,
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Passwort",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color.fromARGB(255, 80, 80, 80),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signIn(emailController.text + "@c.com", passwordController.text);
          },
          child: Text(
            "Buchen",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 37, 41),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          toolbarHeight: 120, // Set this height
          flexibleSpace: Container(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.1,
                  20,
                  MediaQuery.of(context).size.width * 0.1,
                  0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(getDayOfWeek(DateTime.now().weekday),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'RobotoMono')),
                      Text(
                          DateTime.now().day.toString() +
                              ". " +
                              getMonth(DateTime.now().month) +
                              " " +
                              DateTime.now().year.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'RobotoMono')),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              // Add a linear gradient as the background color
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 0, 0, 0),
                                  Color.fromARGB(255, 130, 127, 123)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            child: Card(
                              color: Colors.transparent,
                              shadowColor: Colors.transparent,
                              child: Text(
                                '${_currentTime.hour.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: 'RobotoMono'),
                              ),
                            ),
                          ),
                          Text(
                            ":",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'RobotoMono'),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              // Add a linear gradient as the background color
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 0, 0, 0),
                                  Color.fromARGB(255, 130, 127, 123)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            child: Card(
                              color: Colors.transparent,
                              shadowColor: Colors.transparent,
                              child: Text(
                                '${_currentTime.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: 'RobotoMono'),
                              ),
                            ),
                          ),
                          Text(
                            ":",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'RobotoMono'),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              // Add a linear gradient as the background color
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 151, 151, 151),
                                  Color.fromARGB(255, 255, 255, 255)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            child: Card(
                              color: Colors.transparent,
                              shadowColor: Colors.transparent,
                              child: Text(
                                '${_currentTime.second.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontFamily: 'RobotoMono'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    iconSize: 72,
                    icon: const Icon(
                      FontAwesomeIcons.briefcase,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      launchLink('https://infopoint.hoope.me/',
                          isNewTab: false);
                    },
                  ),
                  Spacer(),
                  IconButton(
                    iconSize: 72,
                    icon: const Icon(Icons.home),
                    color: Colors.white,
                    onPressed: () {
                      launchLink('https://infopoint.hoope.me/',
                          isNewTab: false);
                    },
                  ),
                ],
              ),
            ),
          )),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.1,
                    0,
                    MediaQuery.of(context).size.width * 0.1,
                    0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Image.asset(
                            "assets/logo.png",
                            fit: BoxFit.contain,
                          )),
                      Container(
                        width: 500,
                        child: Column(
                          children: [
                            SizedBox(height: 45),
                            emailField,
                            SizedBox(height: 25),
                            passwordField,
                            SizedBox(height: 35),
                            loginButton,
                          ],
                        ),
                      ),

                      /*  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Don't have an account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegistrationScreen()));
                              },
                              child: Text(
                                "SignUp",
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            )
                          ]) */
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // login function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: Text('gebucht am ' +
                          DateTime.now().toString().substring(0, 19)),
                    ),
                  )
                  //Fluttertoast.showToast(msg: "gebu"),
                  /* Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SetProfile())), */
                });
        emailController.clear();
        passwordController.clear();
        firestore.doc(userId).update({
          stampname: FieldValue.arrayUnion(
              [DateTime.now().toString().substring(0, 19)])
        }); 
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";

            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }
}
