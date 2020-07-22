import 'dart:convert';

import 'package:borrowinomobileapp/Login.dart';
import 'package:borrowinomobileapp/NavDrawer.dart';
import 'package:borrowinomobileapp/admin/UsersList.dart';
import 'package:borrowinomobileapp/models/Request.dart';
import 'package:borrowinomobileapp/models/User.dart';
import 'package:borrowinomobileapp/models/UserOfferDetails.dart';
import 'package:borrowinomobileapp/views/AnsweredRequestsInfo.dart';
import 'package:borrowinomobileapp/views/RequestedOfferInfo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:borrowinomobileapp/views/UserOfferInfo.dart';
import 'package:borrowinomobileapp/models/OfferDetails.dart';

class AnsweredRequests extends StatefulWidget {
  @override
  _AnsweredRequestsPageState createState() => new _AnsweredRequestsPageState();
}

class _AnsweredRequestsPageState extends State<AnsweredRequests> {
  int id;
  final List<Request> Userrequests = [];
  final List<UserOfferDetails> items = [];

  var offerDetails;
  String UserId;
  String OfferId;
  UserOfferDetails offers = UserOfferDetails();

  void _getReportedOffers() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    final String url = "http://api.borrowino.ga/user/sent-requests";
    var token = localStorage.getString('token');
    final http.Response response =
    await http.get(url, headers: <String, String>{
      'Authorization': 'Bearer ' + token.toString(),
    });
    final Map<String, dynamic> responseData = json.decode(response.body);
    responseData['data'].forEach((OfferReq) {
      final Request requests = Request(
        id: OfferReq["id"],
        offerid: OfferReq["offer"],
        description: OfferReq["description"],
        from: OfferReq["from"],
        until: OfferReq["until"],
        status: OfferReq["status"],
      );
      setState(() {
        Userrequests.add(requests);
        getOfferDetails(requests.offerid);
        print(requests.id.toString());
      });
    });
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));
    if (user != null) {
      setState(() {
        id = user['id'];
        UserId = id.toString();
        print(UserId);
      });
    } else {
      setState(() {
        id = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _getReportedOffers();
  }


  void getOfferDetails(int id) async {
    final http.Response response =
    await http.get("https://api.borrowino.ga/offers/$id");
    final Map<String, dynamic> responseData = json.decode(response.body);
    final UserOfferDetails offers = UserOfferDetails(
      id: responseData['id'].toString(),
      description: responseData['description'],
      title: responseData['title'],
      location: responseData['location'],
      price: responseData['price'].toString(),
    );
    setState(() {
      items.add(offers);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(64, 75, 96, .9),
          elevation: 0.0,
          title: new Text(
            "Send Requests ",
            style: TextStyle(color: Colors.white),
          ),
        ),
        drawer: new Drawer(
          child:
          NavDrawer(), // here should be the profile but I get an error because I can't login/register,
        ),
        body: ListView.builder(
            itemCount: this.items.length, itemBuilder: _listViewItemBuilder));
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    var offerDetail = this.items[index];
    var request = this.Userrequests[index];
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
                _navigationToNewsDetail(context, offerDetail, request);
              },
              trailing: Icon(Icons.keyboard_arrow_right,
                  color: Colors.grey, size: 30.0),
            )
          ],
        ),
      ),
    );
  }

  void _navigationToNewsDetail(BuildContext context, UserOfferDetails userofferDetail, Request request) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AnsweredRequestsInfo(userofferDetail, request);
    }));
  }

  Widget _itemThumbnail(UserOfferDetails offerDetail) {
    return Container(
      width: 50,
      height: 250,
      child: ClipRRect(
        borderRadius: new BorderRadius.circular(7.0),
        child: Image(
          fit: BoxFit.contain,
          alignment: Alignment.topCenter,
          image: NetworkImage(
              "https://map.gympluscoffee.com/wp-content/uploads/2018/12/Kerry-sky-observe.jpg"),
        ),
      ),
    );
  }

  Widget _itemTitle(UserOfferDetails offerDetail) {
    return Text(
      offerDetail.title,
      style: TextStyle(
          color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.bold),
    );
  }

  Widget _itemDescription(UserOfferDetails offerDetail) {
    return Text(
      offerDetail.description,
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
