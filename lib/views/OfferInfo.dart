import 'dart:convert';

import 'package:borrowinomobileapp/Home.dart';
import 'package:borrowinomobileapp/views/RequestOffer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:borrowinomobileapp/models/OfferDetails.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getflutter/getflutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tip_dialog/tip_dialog.dart';


class OfferInfo extends StatelessWidget {

  String offerStatus;

  final OfferDetails offersDetail;

  OfferInfo(this.offersDetail);
  TextEditingController _reporttextFieldController = TextEditingController();

  bool isActive() {
    if (offersDetail.active == 1) {
      offerStatus = "Available";
    }
    else if (offersDetail.active == 0){
      offerStatus = "Reserved";
    }
  }

  @override
  Widget build(BuildContext context) {

    isActive();
    final coursePrice = Container(
      padding: const EdgeInsets.all(7.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0)),
      child: new Text(
        "\$" + offersDetail.price.toString(),
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
          offersDetail.title,
          style: TextStyle(color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 6,
                child: Padding(
                    padding: EdgeInsets.only(left: 0.0),
                    child: Text(
                      offersDetail.location,
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ))),
            Expanded(flex: 1, child: coursePrice)
          ],
        ),
        SizedBox(height: 1.0),
        Text(
          "Offer is " + offerStatus,
          style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
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



    _displayDialog(BuildContext context) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Why you report this offer?'),
              content: TextField(
                controller: _reporttextFieldController,
                decoration: InputDecoration(hintText: "Description"),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('REPORT'),
                  onPressed: () {
                    reportOffer(context);
                    //TipDialogHelper.success("Successfully Reported");
                  },
                ),
                new FlatButton(
                  child: new Text('CANCEL'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }

    final bottomContentText = Text(
      offersDetail.description,
      style: TextStyle(fontSize: 18.0),
    );
    final readButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width/1.5,
        child: GFButton(
          onPressed: () => { requestOffer(context, offersDetail)},
          color: Color.fromRGBO(58, 66, 86, 1.0),
          icon: Icon(Icons.add,color: Colors.white,),
          size: 40,
          child:
          Text('Request Offer', style: TextStyle(color: Colors.white)),
        ));
    final reportButton = Container(
        padding: EdgeInsets.symmetric(vertical: 0.0),
        width: MediaQuery.of(context).size.width/1.5,
        child: GFButton(
          onPressed: () => { _displayDialog(context)},
          color: Colors.red[900],
          size: 40,
          icon: Icon(Icons.add_alert,color: Colors.white,),
          child:
          Text('Report Offer', style: TextStyle(color: Colors.white)),
        ));
    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(50.0),
      child: Center(
        child: Column(
          children: <Widget>[bottomContentText,readButton, reportButton],
        ),
      ),
    );

    return Scaffold(
      body: new Column(
        children: <Widget>[topContent, bottomContent],
      ),
    );

  }

  void requestOffer(BuildContext context, OfferDetails offerDetails) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RequestOffer(offerDetails);
    }));
  }

  Future<OfferDetails> reportOffer(BuildContext context) async {

    String offerId = offersDetail.id.toString();
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    final http.Response response = await http.post('https://api.borrowino.ga/offers/$offerId/report',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer '+ token.toString(),
        'Accept' : 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'description': _reporttextFieldController.text.toString(),
      }),
      //encoding: Encoding.getByName('charset=UTF-8')
    );

    if (response.statusCode == 201) {
      print('Report send');
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "!! Offer " + offersDetail.title + " has been reported !!");
      Navigator.push(context,new MaterialPageRoute(builder: (context) => MyHomePage()));



    } else {
      print("____________________________________");
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print("____________________________________");
      throw Exception('Failed to update user.');
    }
  }

}
