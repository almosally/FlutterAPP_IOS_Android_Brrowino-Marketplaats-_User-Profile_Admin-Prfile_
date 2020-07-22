import 'dart:convert';
import 'package:borrowinomobileapp/admin/UsersProfile.dart';
import 'package:borrowinomobileapp/models/UserOfferDetails.dart';
import 'package:borrowinomobileapp/views/AnsweredRequests.dart';
import 'package:borrowinomobileapp/views/ChatPage.dart';
import 'package:borrowinomobileapp/views/MyPosts.dart';
import 'package:borrowinomobileapp/views/Profile.dart';
import 'package:borrowinomobileapp/views/RequestedOffers.dart';
import 'package:borrowinomobileapp/views/offer_place.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:borrowinomobileapp/admin/UsersList.dart';
import 'Login.dart';
import 'admin/AdminPanel.dart';
import 'package:http/http.dart' as http;

import 'models/User.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => new _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  String currentProfilePic = " ";

  void switchAccounts() {
    String picBackup = currentProfilePic;
  }

  bool _isAdmin = false;
  int id;

  //profile details ,,,,,,
  String Name;
  String Email;
  String userImage;
  int adminUser;
  final List<User> userInfo = [];
  String UserID;

  @override
  void initState() {
    _loadUserData();
    _getUserData();
    super.initState();
  }

  _getUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    final String url = "https://api.borrowino.ga/users/$UserID";
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

    setState(() {
      userInfo.add(user);
      Name = user.name;
      Email = user.email;
      print(UserID);
      print(Name);
      print(Email);
    });
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));
    if (user != null) {
      setState(() {
        id = user['id'];
        adminUser = user['is_admin'];
        if (adminUser == 1) {
          _isAdmin = true;
        }
        UserID = id.toString();
      });
    } else {
      setState(() {
        id = 0;
      });
    }
  }

  //Page Design.........
  @override
  Widget build(BuildContext context) {
    UserOfferDetails useroffersDetail;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new NetworkImage("https://picsum.photos/200?random"),
                    fit: BoxFit.fill)),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage("https://avatars3.githubusercontent.com/u/31922369?s=460&v=4"),
                    radius: 50.0,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '' + Name.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight + Alignment(0, .3),
                  child: Text(
                    Email.toString(),
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight + Alignment(0, .8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        _isAdmin==true?"Admin":
                        'User',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text( _isAdmin == true? 'Admin panel':'Profile'),
            onTap: () => {
              Navigator.push(context,
                  _isAdmin == true?
                  new MaterialPageRoute(builder: (context) => AdminPanelPage()):new MaterialPageRoute(builder: (context) => MyProfilePage())),
            },
          ),
          ListTile(
            leading: Icon(Icons.add_box),
            title: Text('Place Offer'),
            onTap: () => {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => PlaceOffer()))
            },
          ),
          ListTile(
            leading: Icon(Icons.add_to_home_screen),
            title: Text('Received Requests'),
            onTap: () => {
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => RequestedOffers()))
            },
          ),
          ListTile(
            leading: Icon(Icons.add_shopping_cart),
            title: Text('Send Requests'),
            onTap: () => {
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => AnsweredRequests()))
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('My Posts'),
            onTap: () => {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => MyOfferPage()))
            },
          ),
          _isAdmin == true
              ? ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Users'),
                  onTap: () => {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => UsersPageAdmin()))
                  },
                )
              : Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {logout(context)},
          ),
        ],
      ),
    );
  }
}

void logout(context) async {
//logout from the server ...
//var res = await CallApi().getData('logout');
// var body = json.decode(res.body);
  //if(body['success']){
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  localStorage.remove('user');
  localStorage.remove('token');
  Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
}
