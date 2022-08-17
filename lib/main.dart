import 'package:crypto_tracker/screens/home/home.dart';
import 'package:crypto_tracker/screens/wrapper.dart';
import 'package:crypto_tracker/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(StreamProvider<User?>.value(
    value: AuthSerivice().user,
    initialData: null,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: wrapper(),
    ),
  ));
}
