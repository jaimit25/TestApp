import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/login.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  TextEditingController nameCont = TextEditingController();
  TextEditingController postCont = TextEditingController();

  bool isObsecure = true;
  // File _image;
  bool isloading = false;
  bool userValid = false;

  var _email;
  var _password;
  var _name;

  // _showsnack(String val) {
  //   final snackbar = SnackBar(
  //     content: Text(
  //       val,
  //       textAlign: TextAlign.center,
  //       style: TextStyle(fontWeight: FontWeight.bold),
  //     ),
  //   );
  //   _scaffoldKey.currentState.showSnackBar(snackbar);
  // }

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
                  regScreen(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  regScreen() {
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
              'Register your account! ',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 40.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 23.0),
            child: TextFormField(
              onSaved: (_input) {
                setState(() {
                  _name = _input;
                });
              },
              controller: nameCont,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13.0),
                  ),
                  prefixIcon: Icon(Icons.near_me),
                  hintText: 'Name',
                  labelText: 'Name'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 23.0),
            child: TextFormField(
              onSaved: (input) {
                setState(() {
                  _email = input;
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
                  _name = _input;
                });
              },
              validator: (_input) {
                // return _input.length != 0 ? null : 'Please Enter a Post';
              },
              controller: postCont,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13.0),
                  ),
                  prefixIcon: Icon(Icons.book_sharp),
                  hintText: 'Post',
                  labelText: 'Post'),
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
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              onPressed: () async {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(emailCont.text)
                    .set({
                  'email': emailCont.text,
                  'name': nameCont.text,
                  'pass': passCont.text,
                  'post': postCont.text
                }).then((value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('email', emailCont.text);
                  prefs.setString('pass', passCont.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                });
              },
              child: isloading
                  ? CupertinoActivityIndicator()
                  : Text('Register', style: TextStyle(color: Colors.white)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 13.0),
            child: FlatButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ),
              ),
              child: Text('Already a User? Login'),
            ),
          ),
        ],
      ),
    );
  }
}
