import 'package:crypto_tracker/screens/authenticate/authenticate.dart';
import 'package:crypto_tracker/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class wrapper extends StatefulWidget {
  const wrapper({Key? key}) : super(key: key);

  @override
  State<wrapper> createState() => _wrapperState();
}

class _wrapperState extends State<wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return HomeScreen();
    }
  }
}
