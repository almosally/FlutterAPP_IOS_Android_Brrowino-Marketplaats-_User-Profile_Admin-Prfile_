import 'dart:convert';

import 'package:borrowinomobileapp/models/OfferDetails.dart';
import 'package:borrowinomobileapp/models/PlaceOffer.dart';
import 'package:borrowinomobileapp/views/MyPosts.dart';
import 'package:borrowinomobileapp/views/UpdateOffer.dart';
import 'package:borrowinomobileapp/views/offer_place.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:borrowinomobileapp/models/UserOfferDetails.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getflutter/getflutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class UserOfferInfo extends StatelessWidget {

  final UserOfferDetails useroffersDetail;

  UserOfferInfo(this.useroffersDetail);

  @override
  Widget build(BuildContext context) {

    final coursePrice = Container(
      padding: const EdgeInsets.all(7.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0)),
      child: new Text(
        "\$" + useroffersDetail.price.toString(),
        style: TextStyle(color: Colors.white),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 80.0),
        Icon(
          Icons.photo_library,
          color: Colors.white,
          size: 40.0,
        ),
        Container(
          width: 90.0,
          child: new Divider(color: Colors.white),
        ),
        SizedBox(height: 10.0),
        Text(
          useroffersDetail.title,
          style: TextStyle(color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 6,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      useroffersDetail.location,
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ))),
            Expanded(flex: 1, child: coursePrice)
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 0.0),
            child: new Image.network("https://map.gympluscoffee.com/wp-content/uploads/2018/12/Kerry-sky-observe.jpg",fit: BoxFit.cover)
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width ,
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
        )
      ],
    );

    final bottomContentText = Text(
      useroffersDetail.description,
      style: TextStyle(fontSize: 18.0),
    );
    final deleteButton = Container(
        padding: EdgeInsets.symmetric(vertical: 0.0),
        width: MediaQuery.of(context).size.width,
        child: GFButton(
          onPressed: (){deleteOffer(context);},
          text: "Delete Offer",
          icon: Icon(Icons.delete),
          color: Colors.red[900],
          size: 50,
          textStyle: TextStyle (fontSize: 18, color: Colors.white),
        ),);
    final updateButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: GFButton(
          onPressed: (){update(context,useroffersDetail);},
          text: "Update Offer",
          icon: Icon(Icons.update),
          size:50,
          textStyle: TextStyle (fontSize: 18, color: Colors.white),
        ),);
    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          children: <Widget>[bottomContentText],
        ),
      ),
    );
    final bottomButtonsContent = Container(
      width: MediaQuery.of(context).size.width / 1,
      padding: EdgeInsets.all(50.0),
      child: Center(
        child: Column(
          children: <Widget>[ deleteButton, updateButton],
        ),
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[topContent, bottomContent, bottomButtonsContent],
      ),
    );
  }


  void update(BuildContext context, UserOfferDetails userofferDetail) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return UpdateOffer(userofferDetail);
    }));
  }


  //delete function
  Future<Offer> deleteOffer(BuildContext context) async {

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String offerId = useroffersDetail.id;
    print("This is the offer id" + offerId);
    var token = localStorage.getString('token');
    final  http.Response response = await http.delete(
      'http://api.borrowino.ga/offers/$offerId',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token.toString(),
      },
    );

    if (response.statusCode == 204) {
      Fluttertoast.showToast(
          msg: "!! Offer " + useroffersDetail.title + " has been deleted !!");

      Navigator.push(context,new MaterialPageRoute(builder: (context) => MyOfferPage()));

    } else {
      print("____________________________________");
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print("____________________________________");
      throw Exception('Failed to delete album.');
    }
  }
}
