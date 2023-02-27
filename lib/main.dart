import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timestamp/homescreen.dart';
import 'package:timestamp/loginscreen.dart';
import 'package:timestamp/stamps.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDpUGwyhLNxkCMYdppYgxdyPYaf8801FJM",
          appId: "1:701373106747:web:8612386ef5e96b83d3aa1e",
          messagingSenderId: "701373106747",
          projectId: "trecord-483e0"));
  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.blue,
          scaffoldBackgroundColor: Colors.black.withOpacity(0.8),
          canvasColor: Colors.transparent,
        ),
        home: LoginScreen(),
      );
}
