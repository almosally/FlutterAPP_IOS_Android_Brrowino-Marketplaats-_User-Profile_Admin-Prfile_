import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'MyPosts.dart';
import 'package:borrowinomobileapp/models/ImageUploadModel.dart';
import 'package:borrowinomobileapp/models/PlaceOffer.dart';
import 'package:http_parser/http_parser.dart';


class PlaceOffer extends StatefulWidget {


  @override
  _PlaceOfferState createState() => new _PlaceOfferState();
}


class _PlaceOfferState extends State<PlaceOffer> {

  bool _isUploading = false;

  var imgURL = [];
  File _image;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool isAuth = false;
  //profile details ,,,,,,
  String name;
  String email;
  String userImage;
  String title;
  String desc;
  String location;
  var price;
  var user;

  @override
  void initState() {
    setState(() {

    });
    _loadUserData();
    _checkIfLoggedIn();
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));
    if (user != null) {
      setState(() {
        name =  user['name'];
        email = user['email'];
        userImage = user['userImage'];
      });
    } else {
      setState(() {
        name = 'name';
        email = 'email';
        userImage = 'userImage';
      });
    }
  }

  void _checkIfLoggedIn() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if(token != null){
      setState(() {
        isAuth = true;
      });
    }
  }


  void getImage(BuildContext context, ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    setState(() {
      _image = image;
    });
    // Closes the bottom sheet
  }


  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 400.0,
        height: 300.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image:  _image == null
                ? NetworkImage("https://testersdock.com/wp-content/uploads/2017/09/file-upload.png")
                : FileImage(_image),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: Colors.white,
            width: 10.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Place offer by: ' + name),
        backgroundColor: Color.fromRGBO(64, 75, 96, .9),
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new Row (
                    children: [
                      Expanded(
                        child: _buildProfileImage(),
                      ),
                    ],
                  ),
                  new IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      size: 30.0,
                    ),
                    onPressed: () async {
                      await this.getImage(context, ImageSource.gallery);
                    },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.local_offer),
                      hintText: 'Enter your product title',
                      labelText: 'Title',
                    ),
                    validator: (Value) {
                      if (Value.isEmpty) {
                        return 'Please enter some text';
                      }
                      title = Value;
                      return null;
                    },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.description),
                      hintText: 'Enter product description',
                      labelText: 'Description',
                    ),
                    validator: (Value) {
                      if (Value.isEmpty) {
                        return 'Please enter description ';
                      }
                      desc = Value;
                      return null;
                    },
                    keyboardType: TextInputType.text,
                  ),

                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.location_city),
                      hintText: 'Enter location',
                      labelText: 'Location',

                    ),
                    validator: (Value) {
                      if (Value.isEmpty) {
                        return 'Please enter location';
                      }
                      location = Value;
                      return null;
                    },
                    keyboardType: TextInputType.text,
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.attach_money),
                      hintText: 'Enter price',
                      labelText: 'Price',
                    ),
                    validator: (Value) {
                      if (Value.isEmpty) {
                        return 'Please enter price';
                      }
                      price = Value;
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                  ),

                  new Container(
                      padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                      child: new RaisedButton(
                          child: const Text('Place Offer'),
                          color: Colors.green,
                          onPressed: () async {
                            //  _placeOffer(context);
                            await this._placeOffer(title,desc,location,price);
                          }
                      )),
                ],
              ))),
    );

  }

  void _resetState() {
    setState(() {
      _isUploading = false;
      _image = null;
    });
  }


  Future<Map<String, dynamic>> _uploadImage(File image) async {
    setState(() {
      _isUploading = true;
    });
    // Find the mime type of the selected file by looking at the header bytes of the file
    final mimeTypeData =
    lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
    // Intilize the multipart request
    final imageUploadRequest =
    http.MultipartRequest('POST', Uri.parse('https://api.borrowino.ga/offers'));
    // Attach the file in the request
    final file = await http.MultipartFile.fromPath('image', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    // Explicitly pass the extension of the image with request body
    // Since image_picker has some bugs due which it mixes up
    // image extension with file name like this filenamejpge
    // Which creates some problem at the server side to manage
    // or verify the file extension
    imageUploadRequest.fields['ext'] = mimeTypeData[1];
    imageUploadRequest.files.add(file);
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      _resetState();
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }



  Future<Offer> _placeOffer(String title, String desc, String location, var price) async {

    setState(() {
      if (isAuth == true) {
        print("Authorized: Yes");
      }else { print("Authorized: NOT");}
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    final http.Response response = await http.post('https://api.borrowino.ga/offers',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer '+ token.toString(),
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        "description": desc,
        "location":location,
        "price": price,
        "images[0]": await _image.path,
        "images[1]": await _image.path,

        // in the images should be =>  "images[0]": await jsonDecode(jsonEncode(_uploadImage(_image)));
      }),

    );
    if (response.statusCode == 201) {
      print('response posted');
      print(response.body);
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => MyOfferPage()));
      // return Offer.fromJson(json.decode(response.body));

    } else {
      print("____________________________________");
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print("____________________________________");
      throw Exception('Failed to create offer.');
    }
  }
}
