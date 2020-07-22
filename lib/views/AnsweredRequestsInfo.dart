import 'dart:convert';

import 'package:borrowinomobileapp/models/OfferDetails.dart';
import 'package:borrowinomobileapp/models/PlaceOffer.dart';
import 'package:borrowinomobileapp/models/Request.dart';
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



class AnsweredRequestsInfo extends StatelessWidget {

  final UserOfferDetails useroffersDetail;
  final Request request;

  AnsweredRequestsInfo(this.useroffersDetail, this.request);

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
        SizedBox(height: 80.0),
        Text(
          request.status == null
              ? "Status"
              : "Offer request " + request.status,
          style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 0.0),
            width: MediaQuery.of(context).size.height * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
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
      request.description ,
      style: TextStyle(fontSize: 18.0),
    );
    final fromContentText = Text("From : " +
        request.from ,
      style: TextStyle(fontSize: 18.0),
    );
    final tillContentText = Text("Till : " +
        request.until,
      style: TextStyle(fontSize: 18.0),
    );
    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[bottomContentText, fromContentText, tillContentText],
        ),
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[topContent, bottomContent],
      ),
    );
  }


  void update(BuildContext context, UserOfferDetails userofferDetail) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return UpdateOffer(userofferDetail);
    }));
  }
  
}
