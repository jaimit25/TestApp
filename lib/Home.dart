import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/login.dart';
import 'package:testapp/model/userprofile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var mail;
  var localuser;
  int a = 1;
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _post = TextEditingController();
  @override
  void initState() {
    // var collectionRef = FirebaseFirestore.instance.collection('users');
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        a = 2;
      });
      print('aaaaaa');
    });
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mail = prefs.getString('email');
    print(mail);
    print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    var collectionRef =
        await FirebaseFirestore.instance.collection('users').doc(mail).get();
    localuser = userprofile.fromDocument(collectionRef);
    print(localuser.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(mail)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              var doc = snapshot.data;
              return ListView(
                children: [
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      'https://img.pngio.com/creative-png-2-png-image-creative-png-200_200.png'))),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                doc['name'] == null || doc['name'] == ''
                                    ? 'Name'
                                    : doc['name'],
                                // localuser.Sname,
                                // 'hi',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 30.0),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                await pref.clear();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));

                                // SystemNavigator.pop();
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.black,
                                  width: 80,
                                  height: 30,
                                  child: Text('Logout',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ))),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          shrinkWrap: true,
                          children: snapshot.data.docs.map<Widget>((document) {
                            return Eventlist(context, document['name'],
                                document['email'], document['post']);
                          }).toList(),
                        );
                      }
                    },
                  ),
                ],
              );
              // return Center(
              //   child: CircularProgressIndicator(),
              // );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          displayBottomSheet(context, mail);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void BottomEdit(BuildContext context, String email, String name) {
    showModalBottomSheet(
        // backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        context: context,
        builder: (ctx) {
          return Container(
            height: 300,
            padding: EdgeInsets.only(left: 30, right: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text('Edit User Details',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _name,
                    decoration: InputDecoration(hintText: 'Name'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _post,
                    decoration: InputDecoration(hintText: 'Post'),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        color: Colors.black,
                        child: Center(
                          child: Text(
                            'Update User',
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                    onTap: () {
                      print("uuuuuuuuuuuuuuuuuuuuuu");
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(email == null ? mail : email)
                          .update({
                        'name': _name.text,
                        'post': _post.text
                      }).then((value) {
                        print("uuuuuuuuuuuuuuuppppppddddaaattteed");
                        //toast
                        Fluttertoast.showToast(
                          msg: 'User Updated',
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 2,
                        );
                        _name.text = '';
                      }).catchError((e) {
                        print("eeeeeeeeeeeeeeee");
                        print(e.toString());
                        // Fluttertoast.showToast(
                        //   msg: 'Error Updating',
                        //   timeInSecForIosWeb: 2,
                        //   gravity: ToastGravity.BOTTOM,
                        // );
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void displayBottomSheet(BuildContext context, String email) {
    showModalBottomSheet(
        // backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        context: context,
        builder: (ctx) {
          return Container(
            height: 300,
            padding: EdgeInsets.only(left: 30, right: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text('Add User',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      )),
                  TextFormField(
                    controller: _name,
                    decoration: InputDecoration(hintText: 'name'),
                  ),
                  TextFormField(
                    controller: _email,
                    decoration: InputDecoration(hintText: 'Email'),
                  ),
                  TextFormField(
                    controller: _pass,
                    decoration: InputDecoration(hintText: 'Password'),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    child: Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.black,
                        child: Text('Add User',
                            style: TextStyle(color: Colors.white))),
                    onTap: () {
                      print("aaaaaaaaaaaaaa");
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(_email.text)
                          .set({
                        'email': _email.text,
                        'pass': _pass.text,
                        'name': _name.text,
                        'post':
                            'https://www.cybersport.ru/assets/img/no-photo/user.png'
                      }).then((value) {
                        // //toast
                        // Fluttertoast.showToast(
                        //   msg: 'User Added',
                        //   gravity: ToastGravity.BOTTOM,
                        //   timeInSecForIosWeb: 2,
                        // );
                        _email.text = '';
                        _pass.text = '';
                        _name.text = '';
                      }).catchError((e) {
                        // Fluttertoast.showToast(
                        //   msg: 'Error',
                        //   gravity: ToastGravity.BOTTOM,
                        //   timeInSecForIosWeb: 2,
                        // );
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget Eventlist(context, name, emailid, post) {
    return GestureDetector(
      onTap: () {
        BottomEdit(context, emailid, name);
      },
      onLongPress: () {
        if (mail != emailid) {
          FirebaseFirestore.instance.collection('users').doc(emailid).delete();
        } else {
          print('connot delete');
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        decoration: shadowBox,
        height: 120,
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://www.cybersport.ru/assets/img/no-photo/user.png'))),
            ),
            Container(
              // width: 220,
              margin: EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 200,
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      emailid == mail ? Text('✔️') : Text(''),
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Container(
                    width: 220,
                    child: Text(
                      post,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),

        // child: ,
      ),
    );
  }
}

BoxDecoration shadowBox = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(13)),
    // boxShadow: [
    //   BoxShadow(
    //     color: Colors.grey,
    //     offset: Offset(0.0, 0.75),
    //     spreadRadius: 0.96,
    //   )
    // ],
    boxShadow: [
      new BoxShadow(
        color: Colors.grey,
        blurRadius: 1,
        spreadRadius: 0.1,
      ),
    ],
    color: Colors.white);
