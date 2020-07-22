import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:borrowinomobileapp/Home.dart';
import 'package:borrowinomobileapp/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin/AdminPanel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      debugShowCheckedModeBanner: false,
      home: CheckAuth(),
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  bool isAdmin = false;
  String name;
  String email;
  int adminValue;
  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var user = jsonDecode(localStorage.getString('user'));
    if(token != null &&user!=null){
      setState(() {
        name = user['name'];
        email = user['email'];
        adminValue = user['is_admin'];
        isAuth = true;
        if (adminValue==1){
          isAdmin=true;
        }

      });
    }
  }
  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth && !isAdmin) {
      child = MyHomePage();
    }else if (isAuth && isAdmin){
      child = AdminPanelPage();
    }
    else {
      child = Login();
    }
    return Scaffold(
      body: child,
    );
  }
}
