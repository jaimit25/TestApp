import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/Home.dart';
import 'package:testapp/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var colr;
  bool usercheck = false;
  @override
  void initState() {
    // usercheck = getData();
    Timer(Duration(seconds: 3), () {
      // usercheck = getData();
      directLogin();
    });
  }

  directLogin() async {
    print("Xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    // getData();
    var collectionRef = FirebaseFirestore.instance.collection('users');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('email');
    prefs.getString('pass');
    var doc = await collectionRef.doc(id).get();
    setState(() {
      usercheck = doc.exists;
    });

    if (usercheck) {
      if (usercheck) {
        print('fuid');
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    } else {
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://lh3.googleusercontent.com/proxy/uKUJAFFLNw_xOC1r_M1VBPQi7XV50yfnjbELGGjNte9TJJeZSIDNSZ5aulTweHhOXS-Tkj8oQQHGFCqQv-iWTSttUNBIx_k3G7JqUcPLLBwJsYwo3g'),
                  ),
                ), // child: Text(provider.uid),
              ),
            ],
          ),
        ],
      ),
    );
  }

  getData() async {
    var collectionRef = FirebaseFirestore.instance.collection('users');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('email');
    prefs.getString('pass');
    var doc = await collectionRef.doc().get();
    setState(() {
      usercheck = doc.exists;
    });
  }
}
