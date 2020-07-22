import 'dart:convert';
import 'dart:math';

import 'package:borrowinomobileapp/Home.dart';
import 'package:borrowinomobileapp/admin/ReportedOffers.dart';
import 'package:borrowinomobileapp/admin/admin_models/OfferDetails_admin.dart';
import 'package:borrowinomobileapp/admin/admin_models/UserDetails.dart';
import 'package:borrowinomobileapp/views/ChatPage.dart';
import 'package:borrowinomobileapp/views/editProfile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'EditUserProfileAdmin.dart';
import 'UsersList.dart';
import 'admin_models/ReportDetails.dart';

void main() => runApp(AdminPanelPage());

class AdminPanelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin panel',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyAdminPage(title: 'Admin panel'),
    );
  }
}

class MyAdminPage extends StatefulWidget {
  MyAdminPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AdminPage createState() => _AdminPage();
}

class _AdminPage extends State<MyAdminPage> {
  bool _isAdmin = false;
  String adminName;
  String adminEmail;
  int adminUser;
  var userImage;
  int id;
  final List<UserDetails> itemsUsers = [];
  final List<OfferDetailsAdmin> itemsoffers = [];
  final List<ReportDetails> itemsReported = [];
  int _userNumberCount;

  //profile details ,,,,,,

  @override
  void initState() {
    _getUers();
    _getoffers();
    _getReportedOffers();
    _loadUserData();
    super.initState();
  }

  void _getReportedOffers() async {
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
        //userCount: userNumberCount++
      );

      setState(() {
        itemsReported.add(reports);


      });

    });
  }

  void _getoffers() async {
    final http.Response response =
        await http.get("http://api.borrowino.ga/offers");
    final Map<String, dynamic> responseData = json.decode(response.body);
    responseData['data'].forEach((offersDetail) {
      final OfferDetailsAdmin offerx = OfferDetailsAdmin();
      setState(() {
        itemsoffers.add(offerx);
      });
    });
  }

  _getUers() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    final String url2 = "http://api.borrowino.ga/admin/users";
    var token = localStorage.getString('token');
    final http.Response response =
        await http.get(url2, headers: <String, String>{
      'Authorization': 'Bearer ' + token.toString(),
    });
    final Map<String, dynamic> responseData = json.decode(response.body);
    responseData['data'].forEach((usersDetail) {
      final UserDetails users = UserDetails();
      setState(() {
       itemsUsers.add(users);
       _userNumberCount=itemsUsers.length;
      });
    });
  }

  _loadUserData() async {
    _getUers();
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if (user != null) {
      setState(() {
        id = user['id'];
        adminName = "Admin: " + user['name'];
        adminEmail = user['email'];
        userImage = user['userImage'];
        adminUser = user['is_admin'];
        if (adminUser == 1) {
          _isAdmin = true;
        }
      });
    } else {
      setState(() {
        adminName = 'name';
        adminEmail = 'email';
        userImage = 'userImage';
      });
    }
  }

  final String url = 'https://avatars3.githubusercontent.com/u/31922369?s=460&v=4';
  final Color green = Color.fromRGBO(58, 66, 86, 1.0);
  List colorsx = [Color.fromRGBO(58, 66, 86, 1.0),Colors.teal, Colors.cyan, Colors.amber,Colors.blue,Colors.blueGrey];
  Random random = new Random();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        elevation: 0,
        backgroundColor: green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => MyHomePage()))
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 16),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            decoration: BoxDecoration(
              color: colorsx[random.nextInt(5)],
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(42),
                  bottomLeft: Radius.circular(42)),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        children: <Widget>[],
                      ),
                    ),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill, image: NetworkImage(url))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        children: <Widget>[],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "ID: $id",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 32),
                  child: Text(
                    adminName.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.shop_two,
                              size: 20.0,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => MyHomePage()));
                            },
                          ),
                          new Text(
                            'Offers',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.group,
                              size: 20.0,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => UsersPageAdmin()));
                            },
                          ),
                          new Text(
                            'Users',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.mail,
                              size: 20.0,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => Chat()));
                            },
                          ),
                          new Text(
                            'Mailbox',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.report,
                              size: 20.0,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => ReportedOffers()));
                            },
                          ),
                          new Text(
                            'Reported offers',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 3,
            padding: EdgeInsets.all(42),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Icon(
                          Icons.group,
                          color: Colors.grey,
                        ),
                        Text(
                          'Total users',
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        Text("( " + itemsUsers.length.toString() + " )"),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Icon(
                          Icons.local_offer,
                          color: Colors.grey,
                        ),
                        Text(
                          'Total offer',
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        Text("( " + itemsoffers.length.toString() + " )"),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Icon(
                          Icons.report_problem,
                          color: Colors.grey,
                        ),
                        Text(
                          'Total reports',
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        Text("( " + itemsReported.length.toString() + " )"),
                      ],
                    ),
                  ],
                ),
                Spacer(),
              ],

            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {Navigator.push(context, new MaterialPageRoute(
            builder: (context) => EditProfileAdmin()));},
        child: Icon(Icons.edit),
        backgroundColor:  Color(0xFF404A5C),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

void _navigationToOfferDetail(BuildContext context, UserDetails UserDetails) {
  // Navigator.push(context, MaterialPageRoute(builder: (context) {
  // return OfferInfo(offerDetail);
  //}));
}
