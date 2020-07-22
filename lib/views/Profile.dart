import 'dart:convert';
import 'package:borrowinomobileapp/admin/admin_models/UserDetails.dart';
import 'package:borrowinomobileapp/models/User.dart';
import 'package:borrowinomobileapp/models/UserOfferDetails.dart';
import 'package:http/http.dart' as http;
import 'package:borrowinomobileapp/Home.dart';
import 'package:borrowinomobileapp/helper/UploadImage.dart';
import 'package:borrowinomobileapp/views/MyPosts.dart';
import 'package:borrowinomobileapp/views/editProfile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => new _MyProfilePageState();
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Profile",
      debugShowCheckedModeBanner: false,
      home: MyProfilePage(),
    );

  }



class _MyProfilePageState extends State<MyProfilePage> {


  User user;
  bool _isAdmin = false;
  int id;

  String _fullName;
  String _email;
  String _bio ;
  String _itemsNumber = "13";
  String _msgNumber = "2";
  int adminUser;
  String Bio;
  String _userImage;
  //profile details ,,,,,,

  String UserID;
  String Name;
  String Email;

  final List<User> userInfo = [];

  @override
  void initState() {
    _loadUserData();
    _getUserData();
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if (user != null) {
      setState(() {
        id = user['id'];
        UserID = id.toString();
      });
    } else {
      setState(() {
        id = 0;
      });
    }
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
      user = User(
        name: responseData['name'],
        email: responseData['email'],
      );

      setState(() {
        userInfo.add(user);
        Name = user.name;
        Email = user.email;
        Bio = "\"Hi, I'm $Name  If you wants to contact me to build your product leave a message.\"";
        print(UserID);
        print(Name);
        print(Email);
      });
  }


  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.77,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://media1.popsugar-assets.com/files/thumbor/mjbALKo9yGCbgNv4JG6KhXhub_c/fit-in/1024x1024/filters:format_auto-!!-:strip_icc-!!-/2020/04/08/974/n/1922507/154cf69601176b0a_shutterstock_109331300/i/Paris-Zoom-Background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    //print(UserID);
    //print(Email);
    //print(Name);
    return Center(
      child: Container(
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://p7.hiclipart.com/preview/355/848/997/computer-icons-user-profile-google-account-photos-icon-account.jpg"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(120.0),
          border: Border.all(
            color: Colors.white,
            width: 10.0,
          ),
        ),
      ),
    );
  }

  Widget _buildFullName() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        Name.toString(),
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 30.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildStatus(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        "Email: " + Email.toString(),
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }

  Widget _buildStatContainer() {
    return Container(
      height: 60.0,
      margin: EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem ("Number of offers", _itemsNumber),
          _buildStatItem("Messages", _msgNumber),
        ],
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w400,//try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );

    return Container(

      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(30.0),
      child: Text(
        Bio,
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  Widget _buildGetInTouch(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        "Get in Touch with ${Email.split(" ")[0]},",
        style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () =>{Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => MyHomePage()))},
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Color(0xFF404A5C),
                ),
                child: Center(
                  child: Text(
                    "HOME",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 9.0),
          Expanded(
            child: InkWell(
              onTap: () =>{Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => MyOfferPage()))},
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "My Offers",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
         ),
    );
  }


  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size ;
    return Padding (
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      child: Scaffold (
        body: Stack(
          children: <Widget>[
            _buildCoverImage(screenSize),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: screenSize.height / 6.4),
                    _buildProfileImage(),
                    _buildFullName(),
                    _buildStatus(context),
                    _buildStatContainer(),
                    _buildBio(context),
                    _buildSeparator(screenSize),
                    SizedBox(height: 10.0),
                    _buildGetInTouch(context),
                    SizedBox(height: 10.0),
                    _buildButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {Navigator.push(context, new MaterialPageRoute(
              builder: (context) => EditProfile(user)));},
          child: Icon(Icons.edit),
          backgroundColor:  Color(0xFF404A5C),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
