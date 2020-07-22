import 'dart:convert';

import 'package:borrowinomobileapp/views/ChatPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'AdminPanel.dart';
import 'OfferListByUser.dart';
import 'UsersList.dart';
import 'admin_models/UserDetails.dart';

class UserrInfo extends StatelessWidget {
  final UserDetails userDetails;

  UserrInfo(this.userDetails);

  bool admin = false;


  @override
  String profileStatus(){
    String temp;
    if(userDetails.is_admin==1){
      admin=true;
      temp="Admin";
    }
    temp="Normal user";
    print(admin.toString());
    return temp;
  }

  //delete function
  Future<UserDetails> deleteUser(BuildContext context) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String usrId = userDetails.id.toString();
    var token = localStorage.getString('token');
    final http.Response response = await http.delete(
      'http://api.borrowino.ga/admin/users/$usrId',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token.toString(),
      },
    );

    if (response.statusCode == 204) {
      Fluttertoast.showToast(
          msg: "!! User: " + userDetails.name + " has been deleted !!");
      // If the server did return a 200 OK response,
      // Navigator.push returns a Future that completes after calling
      // Navigator.pop on the Selection Screen.

      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => UsersPageAdmin()));
      // then parse the JSON. After deleting,
      // you'll get an empty JSON `{}` response.
      // Don't return `null`, otherwise `snapshot.hasData`
      // will always return false on `FutureBuilder`.
      return UserDetails.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a "200 OK response",
      // then throw an exception.
      throw Exception('Failed to delete album.');
    }
  }

  String getCurrentUserId(BuildContext context) {
    String temp = userDetails.id.toString();
    return temp;
  }

  @override
  Widget build(BuildContext context) {

    final coursePrice = Container(
      padding: const EdgeInsets.all(7.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0)),

      child: new Text(
        "id:\n" + userDetails.id.toString(),
        style: TextStyle(color: Colors.white),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 80.0),
        Icon(
          Icons.person,
          color: Colors.white,
          size: 40.0,
        ),
        Container(
          width: 40.0,
          child: new Divider(color: Colors.white),
        ),
        SizedBox(height: 10.0),
        Text(
          "User: " + userDetails.name ,
          style: TextStyle(
              color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 6,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      userDetails.email,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ))),
            Expanded(flex: 1, child: coursePrice)
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[

        Container(
            child: new Image.network(
                "https://map.gympluscoffee.com/wp-content/uploads/2018/12/Kerry-sky-observe.jpg",
                fit: BoxFit.cover)),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.transparent),
          child: Center(
            child: topContentText,

          ),
        ),
        Positioned(
          left: 16.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        Positioned(
          right: 16.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => AdminPanelPage()));
            },
            child: Icon(Icons.home, color: Colors.white),
          ),
        ),
      ],

    );

    final bottomContentText = Text(
      userDetails.name,
      style: TextStyle(fontSize: 18.0),
    ),
    userStatus =Text(
        userDetails.is_admin==1? "Status: Admin":"Status: Normal user",
        style: TextStyle(fontSize: 18.0, color:userDetails.is_admin==1?Colors.green:Colors.blueAccent)
    );
    final readButton = Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        onPressed: () => {
          print(userDetails.id.toString()),
          userDetails.is_admin==1? makeUserNormalUser(userDetails.id): makeUserAdmin(userDetails.id),
        },
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: Text( userDetails.is_admin==1? "Remove admin access for this usr":"Make this user as admin", style:userDetails.is_admin==1? TextStyle(color: Colors.pink):TextStyle(color: Colors.white)),
      ),
    );
    final userOfferBtn = Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        onPressed: () => {_navigationToOfferDetail(context, userDetails)},
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: Text("offers by: " + userDetails.name,
            style: TextStyle(color: Colors.white)),
      ),
    );
    final userDelete = Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        onPressed: () => {_showDialog(context, userDetails.name)},
        color: Colors.redAccent,
        child: Text("Delete: " + userDetails.name,
            style: TextStyle(color: Colors.white)),
      ),
    );

    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[
            bottomContentText,
            userStatus,
            readButton,
            userOfferBtn,
            userDelete
          ],
        ),
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[topContent, bottomContent],
      ),
    );
  }

  void _showDialog(context, String name) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete account",
              style: TextStyle(color: Colors.redAccent)),
          content: new Text("Are you sure delete $name"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Delete",
              ),
              onPressed: () {userDetails.is_admin==1?Fluttertoast.showToast(
                  msg: "Cant delete an admin account",
                  textColor: Colors.red,
                  backgroundColor: Colors.grey,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,

              ):
                deleteUser(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _navigationToOfferDetail(BuildContext context, UserDetails userDetail) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OfferList(userDetail);
    }));
  }

  Future<void> makeUserAdmin(UserID) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    print("this is token "+ token.toString());
     final response=await http.put('http://api.borrowino.ga/admin/users/$UserID',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer '+ token.toString(),
      },
      body: jsonEncode(<String, dynamic>{
        'is_admin':1,
      }),
      //encoding: Encoding.getByName('charset=UTF-8')

    );if (response.statusCode == 200) {
      print(response.body);
      Fluttertoast.showToast(
          msg: "!! User: " + userDetails.name + " has been Updated !!");
      return UserDetails.fromJson(jsonDecode(response.body));
    } else {
      print(response.body);
      throw Exception('update user.');
    }
  }

  Future<void> makeUserNormalUser(UserID) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    print("this is token "+ token.toString());
    final response=await http.put('http://api.borrowino.ga/admin/users/$UserID',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer '+ token.toString(),
      },
      body: jsonEncode(<String, dynamic>{
        'is_admin':0,
      }),
      //encoding: Encoding.getByName('charset=UTF-8')

    );if (response.statusCode == 200) {
      print(response.body);
      Fluttertoast.showToast(
          msg: "!! User: " + userDetails.name + " has been Updated !!");
      return UserDetails.fromJson(jsonDecode(response.body));
    } else {
      print(response.body);
      throw Exception('update user.');
    }
  }

}
