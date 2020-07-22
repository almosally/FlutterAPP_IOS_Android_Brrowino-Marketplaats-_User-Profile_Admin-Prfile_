import 'dart:async';
import 'dart:convert';

import 'package:borrowinomobileapp/Login.dart';
import 'package:borrowinomobileapp/NavDrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'AdminPanel.dart';
import 'admin_models/UserDetails.dart';
import 'UserInfo_admin.dart';

class UsersPageAdmin extends StatefulWidget {
  @override
  _UsersPageAdminState createState() => new _UsersPageAdminState();
}
String userId , userName;
int count =0;


class _UsersPageAdminState extends State<UsersPageAdmin> {
  int _userNumberCount = 0;

  final List<UserDetails> items = [];

  final String url = "http://api.borrowino.ga/admin/users";
  var userDetails;

  @override
  void initState() {
    super.initState();
    getUsersAdmin();
  }

  void getUsersAdmin() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
   // final String url = "http://10.0.2.2:8000/admin/users";
    var token = localStorage.getString('token');
    final http.Response response =
        await http.get(url, headers: <String, String>{
      'Authorization': 'Bearer ' + token.toString(),
    });
    final Map<String, dynamic> responseData = json.decode(response.body);
    responseData['data'].forEach((usersDetail) {
      final UserDetails users = UserDetails(

        id: usersDetail['id'],
        name: usersDetail['name'],
        email: usersDetail['email'],
        is_admin: usersDetail['is_admin'],
        userCount: _userNumberCount++

      );

      setState(() {
        items.add(users);

      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text( "Users list " + "(" +items.length.toString() + ")"),
          backgroundColor: Color.fromRGBO(64, 75, 96, .9),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () => {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => AdminPanelPage()))
              },
            )
          ],
        ),

        body: ListView.builder(
            itemCount: this.items.length, itemBuilder: _listViewItemBuilder));
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    var userDetail = this.items[index];
    return Container(
      width: 200,
      height: 120,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Color.fromRGBO(58, 66, 86, 1.0),
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              title: _itemTitle(userDetail),
              subtitle: _itemDescription(userDetail),
              onTap: () {
                _navigationToUserDetail(context, userDetail);
                //print(userId);

              },//onLongPress:(),
              trailing: PopUpMenu(),

            ),

          ],
        ),
      ),
    );
  }

  void _navigationToUserDetail(BuildContext context, UserDetails userDetail) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
     return UserrInfo(userDetail);
    }));
  }

  Widget _itemTitle(UserDetails userDetail) {
    return Text(
      "User's name: " + userDetail.name,
      style: TextStyle(
          color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.bold),
    );
  }

  Widget _itemDescription(UserDetails userDetail) {
    return Text(
      "User's id: " + userDetail.id.toString(),
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.normal),
    );
  }

  void logout() async {
    // logout from the server ...
    // var res = await CallApi().getData('logout');
    // var body = json.decode(res.body);
    //  if(body['success']){
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('user');
    localStorage.remove('token');
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => Login()));
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height / 4.75);
    p.lineTo(0.0, size.height / 4.20);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}




class PopUpMenu extends StatelessWidget {
  void showMenuSelection(String value) {
    //print("pressed");
    switch (value) {
      case 'Delete':
       // deleteUser();
        print("");
        print("Deleteeeeeeee");
        break;
      case 'Create another':
        print("Create anotherrrrr");
        break;
      // Other cases for other menu options
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert),
      onSelected: showMenuSelection,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Create another',
          child:
              ListTile(leading: Icon(Icons.add), title: Text('View profile ')),
        ),
        const PopupMenuItem<String>(
            value: 'Delete',
            child: ListTile(
                leading: Icon(Icons.delete), title: Text('Delete this user'))),
      ],
    );
  }

  Future<UserDetails> deleteUser(String id) async {

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    final http.Response response = await http.delete(
      'http://10.0.2.2:8000/admin/users/$id',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token.toString(),
      },
    );

    if (response.statusCode == 204) {
      Fluttertoast.showToast(
          msg: "!! User" + userName + "has been deleted !!");
      // If the server did return a 200 OK response,
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
}


