import 'dart:convert';
import 'package:borrowinomobileapp/Login.dart';
import 'package:borrowinomobileapp/main.dart';

import 'package:flutter/material.dart';

import './Animation/FadeAnimation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:borrowinomobileapp/Api/Api.dart';


class Register extends StatefulWidget {

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  var email;
  var password;
  var verPassword;
  var name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff21254A),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 200,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        child: FadeAnimation(
                          1,
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/images/1.png"),
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeAnimation(
                      1,
                      Text(
                        "Register to Borrowino",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    FadeAnimation(
                        1,
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.transparent,
                          ),
                          child: Form (
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[100],
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    cursorColor: Color(0xFF9b9b9b),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.insert_emoticon,
                                        color: Colors.grey,
                                      ),
                                      border: InputBorder.none,
                                      hintText: "Name",
                                      hintStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    validator: (username) {
                                      if (username.isEmpty) {
                                        return 'Please enter your name';
                                      }
                                      name = username;
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[100],
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    cursorColor: Color(0xFF9b9b9b),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Colors.white,
                                      ),
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      hintStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    validator: (emailValue) {
                                      if (emailValue.isEmpty) {
                                        return 'Please enter email';
                                      }
                                      email = emailValue;
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[100],
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    cursorColor: Color(0xFF9b9b9b),
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.vpn_key,
                                        color: Colors.white,
                                      ),
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      fillColor: Colors.white,
                                      hintStyle: TextStyle(
                                          color: Colors.white
                                      ),
                                    ),
                                    validator: (passwordValue) {
                                      if (passwordValue.isEmpty) {
                                        return 'Please enter a password';
                                      }
                                      password = passwordValue;
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[100],
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    cursorColor: Color(0xFF9b9b9b),
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.vpn_key,
                                        color: Colors.white,
                                      ),
                                      border: InputBorder.none,
                                      hintText: "Verify Password",
                                      fillColor: Colors.white,
                                      hintStyle: TextStyle(
                                          color: Colors.white
                                      ),
                                    ),
                                    validator: (passwordValue) {
                                      if (passwordValue.isEmpty) {
                                        return 'Please verify your password';
                                      }
                                      verPassword = passwordValue;
                                      return null;
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: FadeAnimation(
                        1,
                        Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.pink[200],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    FadeAnimation(
                      1,
                      Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 60),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color.fromRGBO(49, 39, 79, 1),
                        ),
                        child: Center(
                          child:FlatButton(
                            child: Text(
                              _isLoading? 'Creating user...' : 'Register',
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            disabledColor: Colors.grey,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _register();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    FadeAnimation(
                      1,
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, new MaterialPageRoute(
                                builder: (context) => Login()));
                          },
                          child: Text(
                            "Already an user? Log in here!",
                            style: TextStyle(
                              color: Colors.pink[200],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _register()async{
    setState(() {
      _isLoading = true;
    });
    var data = {
      'name': name,
      'email' : email,
      'password': password,
      'password_confirmation':verPassword,
      "is_admin": 0,
    };
    var res = await CallApi().postData(data, 'register');
    var body;

    print("____________________");

    if (res.statusCode == 200) {
      body = json.decode(res.body);
      print(body);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      body = json.decode(res.body);
      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');
      localStorage.setString('token', body['access_token']);
      localStorage.setString('user', json.encode(body['user']));
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => MyApp()));
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
