import 'dart:convert';

import 'dart:io';
import 'package:borrowinomobileapp/admin/AdminPanel.dart';
import 'package:http/http.dart' as http;
import 'package:borrowinomobileapp/views/Profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getflutter/getflutter.dart';
import 'package:borrowinomobileapp/admin/admin_models/UserDetails.dart';
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';

class EditProfileAdmin extends StatefulWidget {

  EditProfileAdmin({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EditProfileState createState() => new _EditProfileState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Profile",
      debugShowCheckedModeBanner: false,
      home: EditProfileAdmin(),
    );
  }
}



class _EditProfileState extends State<EditProfileAdmin> {

  File _image;
  final myNameController = TextEditingController();
  final myEmailController = TextEditingController();
  final myPasswordController = TextEditingController();
  final myConfPassController = TextEditingController();
  bool isAuth = false;
  int id;
  int adminUser;
  String UserID;
  String name,email;
  String Name;
  String base64Image;

  //profile details ,,,,,,


  void initState() {
    _loadUserData();
    super.initState();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print('Image Path ' + _image.path);

    });
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));
    if (user != null) {
      setState(() {
        id = user['id'];
        name = user['name'];
        email=user['email'];
        print(name);

      });
    } else {
      setState(() {
        id = null;
        name = null;
      });
    }
  String uName=name;
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
    return Center(
      child: Container(
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image:  _image == null
                ? NetworkImage('https://avatars3.githubusercontent.com/u/31922369?s=460&v=4')
                : FileImage(_image),
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

  Widget _buildFullName(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: new TextField(
        controller: myNameController,
        decoration: const InputDecoration(
          icon: const Icon(Icons.person),
          hintText:"",
          labelText: "Name",
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget _buildEmail(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: new TextField(
        controller: myEmailController,
        decoration: const InputDecoration(
          icon: const Icon(Icons.email),
          hintText: "Email Address",
          labelText: "Email",
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget _buildPassword(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: new TextField(
        obscureText: true,
        controller: myPasswordController,
        decoration: const InputDecoration(
          icon: const Icon(Icons.lock),
          hintText: "Edit Password",
          labelText: "Password",
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget _buildConfirmPassword(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: new TextField(
        obscureText: true,
        controller: myConfPassController,
        decoration: const InputDecoration(
          icon: const Icon(Icons.check_box),
          hintText: "Password",
          labelText: "Confirm Password",
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget _buildUploadButton() {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
      child: new GFButton(
        onPressed: (){getImage();},
        text: "Upload Image",
        shape: GFButtonShape.pills,
        type: GFButtonType.outline2x,
        color:  Color(0xFF404A5C),
      ),
    );
  }


  Widget _buildButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () async =>{ await this._editProfile()},
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Color(0xFF404A5C),
                ),
                child: Center(
                  child: Text(
                    "SAVE",
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
              onTap: () =>{Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => AdminPanelPage()))},
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
                      "Cancel",
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
                    _buildUploadButton(),
                    _buildFullName(context),
                    _buildEmail(context),
                    _buildPassword(context),
                    _buildConfirmPassword(context),
                    SizedBox(height: 15.0),
                    _buildButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<UserDetails> _editProfile() async {

    print(UserID);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    print("this is token "+ token.toString());
    final http.Response response = await http.put('http://api.borrowino.ga/users/$UserID',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer '+ token.toString(),
        'Accept' : 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'name': myNameController.text.toString(),
        'email': myEmailController.text.toString(),
        'password': myPasswordController.text.toString(),
        'password_confirmation': myConfPassController.text.toString(),
      }),
      //encoding: Encoding.getByName('charset=UTF-8')

    );

    if (response.statusCode == 200) {
      print('User details updated');
      //Navigator.push(
     //     context,
        //  new MaterialPageRoute(//
             // builder: (context) => UserrInfo()));

    } else {
      print("____________________________________");
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print("____________________________________");
      throw Exception('Failed to update user.');
    }

  }
}
