import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/Home.dart';
import 'package:testapp/register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var _email;
  var _password;
  var _name;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();

  bool isObsecure = true;
  bool isloading = false;
  bool userIsValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  loginScreen(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  loginScreen() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 70.0, top: 23.0, left: 20),
            alignment: Alignment.bottomLeft,
            child: Text(
              'Login! ',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 40.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 23.0),
            child: TextFormField(
              onSaved: (_input) {
                setState(() {
                  _email = _input;
                });
              },
              controller: emailCont,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13.0),
                  ),
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Email',
                  labelText: 'Email'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 23.0),
            child: TextFormField(
              onSaved: (_input) {
                setState(() {
                  _password = _input;
                });
              },
              obscureText: isObsecure,
              controller: passCont,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13.0),
                  ),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: GestureDetector(
                    child: Icon(
                        isObsecure ? Icons.visibility : Icons.visibility_off),
                    onTap: () {
                      setState(() {
                        isObsecure = !isObsecure;
                      });
                    },
                  ),
                  hintText: 'Password',
                  labelText: 'Password'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: MaterialButton(
              onPressed: () async {
                var collectionRef =
                    FirebaseFirestore.instance.collection('users');
                var docu = await collectionRef.doc(emailCont.text).get();
                var users = await collectionRef.doc(emailCont.text).snapshots();
                bool check = docu.exists;
                var dc = docu.data();
                if (check) {
                  if (dc['pass'] == passCont.text) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('email', emailCont.text);
                    prefs.setString('pass', passCont.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ),
                    );
                  } else {
                    print('wrong data');
                  }
                }
              },
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: isloading
                  ? CupertinoActivityIndicator()
                  : Text('Login', style: TextStyle(color: Colors.white)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 13.0),
            child: FlatButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Registration(),
                ),
              ),
              child: Text('New User? Register'),
            ),
          ),
        ],
      ),
    );
  }
}
