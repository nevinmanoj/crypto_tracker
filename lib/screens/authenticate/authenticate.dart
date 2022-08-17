import 'package:crypto_tracker/screens/authenticate/login.dart';
import 'package:crypto_tracker/screens/authenticate/register.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return login(toggleView: toggleView);
    } else {
      return signUp(toggleView: toggleView);
    }
  }
}
