import 'dart:convert';

import 'package:borrowinomobileapp/admin/admin_models/ReportDetails.dart';
import 'package:borrowinomobileapp/models/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'AdminPanel.dart';
import 'ReportedOffers.dart';
import 'admin_models/UserDetails.dart';

class ReportInfo extends StatelessWidget {
  final ReportDetails reportDetails;

  ReportInfo(this.reportDetails);

  List<UserDetails> userinfo;

  _getUers() async {
    String id = reportDetails.reporter_id.toString();
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    final String url2 = "http://api.borrowino.ga/admin/users/$id";
    var token = localStorage.getString('token');
    final http.Response response =
        await http.get(url2, headers: <String, String>{
      'Authorization': 'Bearer ' + token.toString(),
    });
    final Map<String, dynamic> responseData = json.decode(response.body);
    responseData['data'].forEach((usersDetail) {
      final UserDetails user = UserDetails();
      userinfo.add(user);
      print(userinfo.toString());
    });
  }

  _getUserData() async {
    String id = reportDetails.reporter_id.toString();
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    final String url = "http://api.borrowino.ga/admin/users/$id";
    var token = localStorage.getString('token');
    final http.Response response =
        await http.get(url, headers: <String, String>{
      'Authorization': 'Bearer ' + token.toString(),
    });
    final Map<String, dynamic> responseData = json.decode(response.body);
    final User user = User(
      name: responseData['name'],
      email: responseData['email'],
    );
    print(user.name);
  }

  //delete function
  Future<UserDetails> deleteReport(BuildContext context) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String repID = reportDetails.id.toString();
    var token = localStorage.getString('token');
    final http.Response response = await http.delete(
      'http://api.borrowino.ga/admin/offer-reports/$repID',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token.toString(),
      },
    );

    if (response.statusCode == 204) {
      Fluttertoast.showToast(msg: "!! Report: has been deleted !!");
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => ReportedOffers()));
    } else {
      throw Exception('Failed to delete album.');
    }
  }

  String getCurrentUserId(BuildContext context) {
    String temp = reportDetails.id.toString();
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
        "id:\n" + reportDetails.id.toString(),
        style: TextStyle(color: Colors.white),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20.0),
        Icon(
          Icons.report_problem,
          color: Colors.redAccent,
          size: 50.0,
        ),
        Container(
          width: 40.0,
          child: new Divider(color: Colors.white),
        ),
        SizedBox(height: 10.0),
        Text(
          "Report id:\n " + reportDetails.id.toString(),
          style: TextStyle(
              color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        Text(
          "offer id:\n " + reportDetails.offer_id.toString(),
          style: TextStyle(
              color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        Text(
          "Reporter id:\n " + reportDetails.reporter_id.toString(),
          style: TextStyle(
              color: Colors.greenAccent, fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            child: new Image.network(
                "https://3pageplus.com/wp-content/uploads/2019/03/change-background-color-on-wix-1024x678.jpg",
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
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => AdminPanelPage()));
            },
            child: Icon(Icons.home, color: Colors.white),
          ),
        ),
      ],
    );

    final bottomContentText = Text(
      "Description: \n" + reportDetails.description,
      style: TextStyle(fontSize: 18.0),
    );
    final readButton = Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        onPressed: () => {_showDialog(context, "")},
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: Text("Delete this report",
            style: TextStyle(color: Colors.redAccent)),
      ),
    );

    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[
            bottomContentText,
            readButton,
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
          title: new Text("Delete report",
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
                onPressed: () {
                  deleteReport(context);
                }),
          ],
        );
      },
    );
  }
}
