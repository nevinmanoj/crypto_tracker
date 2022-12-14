import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_tracker/screens/home/Settings.dart';
import 'package:crypto_tracker/screens/home/market.dart';
import 'package:crypto_tracker/screens/home/wallet/components/totalWallet.dart';
import 'package:crypto_tracker/screens/home/wallet/wallet.dart';
import 'package:crypto_tracker/services/ApiCalls.dart';
import 'package:crypto_tracker/services/database.dart';
import 'package:crypto_tracker/shared/DataModels.dart';
import 'package:crypto_tracker/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

List navOptions = ["Home", "Market", "Wallet", "Settings"];
final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text('home'),
    MarketScreen(),
    WalletScreen(),
    SettingsScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton:
          _selectedIndex == 2 ? CustomFABwindow() : Container(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(navOptions[_selectedIndex]),
        backgroundColor: Colors.black,
      ),
      body: Center(
        // child: ElevatedButton(
        //   child: Icon(Icons.add_circle_rounded),
        //   onPressed: () async {
        //     print('home add test');
        //     // DatabaseService(uid: user!.uid).addCoin(
        //     //     id: 'adainr',
        //     //     Coin: WalletCoinInfo(
        //     //         buyPrice: '100',
        //     //         buyQty: '20',
        //     //         name: 'ADA/INR',
        //     //         market: 'inr'));
        //   },
        // ),

        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: primaryAppColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: 'Market',
            backgroundColor: primaryAppColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Wallet',
            backgroundColor: primaryAppColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: primaryAppColor,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: secondaryAppColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
