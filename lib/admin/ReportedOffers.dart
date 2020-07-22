import 'dart:async';
import 'dart:convert';

import 'package:borrowinomobileapp/Login.dart';
import 'package:borrowinomobileapp/NavDrawer.dart';
import 'package:borrowinomobileapp/admin/AdminPanel.dart';
import 'package:borrowinomobileapp/admin/admin_models/OfferDetails_admin.dart';
import 'package:borrowinomobileapp/admin/admin_models/ReportDetails.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'ReportedInfo.dart';


class ReportedOffers extends StatefulWidget {
  @override
  _ReportedOffersState createState() => new _ReportedOffersState();
}
String userId , userName;


class _ReportedOffersState extends State<ReportedOffers> {


  final List<ReportDetails> items = [];

  @override
  void initState() {
    getReportedOffers();
  }

  void getReportedOffers() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    final String url = "http://api.borrowino.ga/admin/offer-reports";
    var token = localStorage.getString('token');
    final http.Response response =
    await http.get(url, headers: <String, String>{
      'Authorization': 'Bearer ' + token.toString(),
    });
    final Map<String, dynamic> responseData = json.decode(response.body);
    responseData['data'].forEach((ReportDetail) {
      final ReportDetails reports = ReportDetails(

        id: ReportDetail['id'],
        offer_id: ReportDetail['offer_id'],
        description: ReportDetail['description'],
        reporter_id: ReportDetail['reporter_id'],
        created_at: ReportDetail['created_at'],
        updated_at: ReportDetail['updated_at'],

        //userCount: userNumberCount++

      );

      setState(() {
        items.add(reports);
      });
    });
  }

  Future<ReportDetails> deleteReport(BuildContext context,String reportId) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    final http.Response response = await http.delete(
      'http://api.borrowino.ga/admin/offer-reports/$reportId',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token.toString(),
      },
    );

    if (response.statusCode == 204) {
      Fluttertoast.showToast(
          msg: "!! Report: " + "userDetails.name "+ " has been deleted !!");
      // If the server did return a 200 OK response,
      // Navigator.push returns a Future that completes after calling
      // Navigator.pop on the Selection Screen.

      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => ReportedOffers()));
      // then parse the JSON. After deleting,
      // you'll get an empty JSON `{}` response.
      // Don't return `null`, otherwise `snapshot.hasData`
      // will always return false on `FutureBuilder`.
     // return ReportDetails.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a "200 OK response",
      // then throw an exception.
      throw Exception('Failed to delete reports.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Reported offers ' + "(" + items.length.toString() + ")"),
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
    var offerDetail = this.items[index];
    var reportDetails=this.items[index];
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
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                        new BorderSide(width: 1.0, color: Colors.white24))),
                child: _itemThumbnail(offerDetail),
              ),
              title: _itemTitle(offerDetail),
              subtitle: _itemDescription(offerDetail),
              onTap: () {
               // _showDialog(context,reportDetails.description,reportDetails.id.toString());
                _navigationToReportDetauks(context, reportDetails);
              },
              trailing: PopUpMenu()
             //con(Icons.delete,
               // color: Colors.red, size: 30.0),

            )
          ],
        ),
      ),
    );

  }


  void _navigationToReportDetauks(BuildContext context,
      ReportDetails reportDetails) {
     Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ReportInfo(reportDetails);
    }));
  }

  Widget _itemThumbnail(ReportDetails reportDetails) {
    return Container(
      width: 50,
      height: 250,
      child: ClipRRect(
        borderRadius: new BorderRadius.circular(7.0),
        child: Image(
          fit: BoxFit.contain,
          alignment: Alignment.topCenter,
          image: NetworkImage( //offerDetail.image[0]),
              "https://map.gympluscoffee.com/wp-content/uploads/2018/12/Kerry-sky-observe.jpg"),
        ),
      ),
    );
  }

  Widget _itemTitle(ReportDetails reportDetails) {
    return Text(
      reportDetails.id.toString(),
      style: TextStyle(
          color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.bold),
    );
  }

  Widget _itemDescription(ReportDetails reportDetails) {
    return Text(
      reportDetails.description,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.normal),
    );
  }

  void _showDialog(context, String name,String reportId) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete Report",
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
                deleteReport(context,reportId);
              },
            ),
          ],
        );
      },
    );
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

//  itemCount: this.items.length, itemBuilder: _listViewItemBuilder));

class PopUpMenu extends StatelessWidget {
  void showMenuSelection(String value) {
    //print("pressed");
    switch (value) {
      case 'Delete':
     // this._showDialog();
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
}
