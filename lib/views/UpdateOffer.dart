import 'dart:convert';

import 'package:borrowinomobileapp/models/OfferDetails.dart';
import 'package:borrowinomobileapp/models/PlaceOffer.dart';
import 'package:borrowinomobileapp/views/MyPosts.dart';
import 'package:borrowinomobileapp/views/UpdateOffer.dart';
import 'package:borrowinomobileapp/views/offer_place.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:borrowinomobileapp/models/UserOfferDetails.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getflutter/getflutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class UpdateOffer extends StatelessWidget {

  final UserOfferDetails useroffersDetail;

  UpdateOffer(this.useroffersDetail);


  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    titleController.text = useroffersDetail.title;
    descriptionController.text = useroffersDetail.description;
    locationController.text = useroffersDetail.location;
    priceController.text = useroffersDetail.price;

    return new Scaffold(
      appBar: AppBar(
        title: Text('Update offer: ' + useroffersDetail.title),
        backgroundColor: Color.fromRGBO(64, 75, 96, .9),
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              //key: _formKey,
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.local_offer),
                      hintText: 'Enter your product title',
                      labelText: 'Title',
                    ),
                  ),
                  new TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.description),
                      hintText: 'Enter product description',
                      labelText: 'Description',
                    ),
                    keyboardType: TextInputType.text,
                  ),

                  new TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.location_city),
                      hintText: 'Enter location',
                      labelText: 'Location',
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  new TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.attach_money),
                      hintText: 'Enter price',
                      labelText: 'Price',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                  ),

                  new Container(
                      padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                      child: new GFButton(
                        onPressed: (){ updateOffer(context);},
                        text: "Update Offer",
                        icon: Icon(Icons.update),
                        size:40,
                        textStyle: TextStyle (fontSize: 17, color: Colors.white),
                      )),
                ],
              ))),
    );
  }

  //update function
  Future<Offer> updateOffer(BuildContext context) async {

    String offerId = useroffersDetail.id;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    final http.Response response = await http.put('http://api.borrowino.ga/offers/$offerId',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer '+ token.toString(),
        'Accept' : 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'title': titleController.text.toString(),
        'description': descriptionController.text.toString(),
        'location': locationController.text.toString(),
        'price': priceController.text.toString(),
        'images[0]': "https://testersdock.com/wp-content/uploads/2017/09/file-upload.png",
        'images[1]': "https://testersdock.com/wp-content/uploads/2017/09/file-upload.png",
        'active': 1,
      }),
      //encoding: Encoding.getByName('charset=UTF-8')

    );

    if (response.statusCode == 200) {
      print('Offer details updated');
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => MyOfferPage()));

    } else {
      print("____________________________________");
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print("____________________________________");
      throw Exception('Failed to update user.');
    }
  }
}
