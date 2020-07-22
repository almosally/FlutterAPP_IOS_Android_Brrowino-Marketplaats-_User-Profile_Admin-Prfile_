import 'dart:convert';

import 'package:borrowinomobileapp/admin/admin_models/OfferDetails_admin.dart';
import 'package:borrowinomobileapp/models/OfferDetails.dart';
import 'package:borrowinomobileapp/views/ChatPage.dart';
import 'package:borrowinomobileapp/views/RequestOffer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'OfferListByUser.dart';
import 'UsersList.dart';
import 'admin_models/ImageDetails.dart';
import 'admin_models/UserDetails.dart';

class OfferInfoList extends StatelessWidget {
  final OfferDetailsAdmin offerDetailsAdmin;
  final UserDetails userDetails;
  final String imgUri;

  OfferInfoList(this.offerDetailsAdmin,this.userDetails,this.imgUri);



  //delete function
  Future<UserDetails> deleteOffer(BuildContext context) async {

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String usrId=offerDetailsAdmin.id.toString();
    var token = localStorage.getString('token');
    final  http.Response response = await http.delete(
      'http://api.borrowino.ga/admin/offers/$usrId',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token.toString(),
      },
    );

    if (response.statusCode == 204) {
      Fluttertoast.showToast(
          msg: "!! User" + userDetails.name + "has been deleted !!");
      // If the server did return a 200 OK response,
      // Navigator.push returns a Future that completes after calling
      // Navigator.pop on the Selection Screen.

      Navigator.push(context,new MaterialPageRoute(builder: (context) => UsersPageAdmin()));
      // then parse the JSON. After deleting,
      // you'll get an empty JSON `{}` response.
      // Don't return `null`, otherwise `snapshot.hasData`
      // will always return false on `FutureBuilder`.
      return UserDetails.fromJson(jsonDecode(response.body));

    } else {
      // If the server did not return a "200 OK response",
      // then throw an exception.
      throw Exception('Failed to delete album.');
    }

  }
  String getCurrentUserId(BuildContext context){
    String temp =offerDetailsAdmin.id.toString();
    return temp;
  }

  @override

  Widget build(BuildContext context) {
    final coursePrice = Container(

      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0)),
      child: new Text(
        "Price:\n" + offerDetailsAdmin.price.toString(),
        style: TextStyle(color: Colors.white),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 80.0),
      //  Icon(
       //   Icons.photo_library,
       //   color: Colors.white,
       //   size: 40.0,
     //   ),
        Container(
          width: 90.0,
       //   child: new Divider(color: Colors.white),
        ),
        SizedBox(height: 10.0),
        Text(
          "Offer: " + offerDetailsAdmin.title,
          style: TextStyle(
              color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold),
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
                      offerDetailsAdmin.active.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ))),
            Expanded(flex: 1, child: coursePrice)
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            child: new Image.network(imgUri ,
             // fit: BoxFit.cover,
              fit: BoxFit.fitWidth,
              height: 350, //"https://map.gympluscoffee.com/wp-content/uploads/2018/12/Kerry-sky-observe.jpg",
             )
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(50.0),
          width: MediaQuery.of(context).size.width,
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
            child: Icon(Icons.arrow_back, color: Colors.blueGrey),
          ),
        )
      ],
    );

    final bottomContentText = Text(
      offerDetailsAdmin.title,
      style: TextStyle(fontSize: 18.0),
    ),bottomContentText2 =Text(
        offerDetailsAdmin.active==1? "Status: Available":"Status: Not available",
      style: TextStyle(fontSize: 18.0, color:offerDetailsAdmin.active==1?Colors.green:Colors.red)
    );
    final readButton = Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        onPressed: () => {
          Navigator.push(
              context, new MaterialPageRoute(builder: (context) => Chat()))
        },
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: Text("Contact Owner", style: TextStyle(color: Colors.white)),
      ),
    );
    final userOfferBtn = Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        onPressed: () => {print(offerDetailsAdmin.image) ,
        showDialog(
        context: context,
        builder: (BuildContext context) {
        return RichAlertDialog( //uses the custom alert dialog
        alertTitle: richTitle(offerDetailsAdmin.title),
        alertSubtitle: richSubtitle("Desc:" +offerDetailsAdmin.description +"\n"+"Created at:"+ offerDetailsAdmin.created_at + "\n"+ "Price: "+offerDetailsAdmin.price,),
        alertType: RichAlertType.SUCCESS,
          actions: <Widget>[
            FlatButton(
              child: Text("Reserve",
              style: TextStyle(color: offerDetailsAdmin.active==1? Colors.green:Colors.red)),
              onPressed: () { //Navigator.pop(context,new MaterialPageRoute(
                //  builder: (context) => requestOffer(context,offerDetailsAdmin)));},
              }
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: (){Navigator.pop(context);},
            ),
          ],
        );
        }
        )
        //  _navigationToOfferDetail(context,userDetails)

        },
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: Text( offerDetailsAdmin.title+" detais ",
            style: TextStyle(color: Colors.white)),
      ),
    );
    final userDelete = Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        onPressed: () => {_showDialog(context,offerDetailsAdmin.title)
           },
        color: Colors.redAccent,
        child: Text("Delete: " + offerDetailsAdmin.title,
            style: TextStyle(color: Colors.white)),
      ),
    );

    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[
            bottomContentText,
            bottomContentText2,
            readButton,
            userOfferBtn,
            userDelete
          ],
        ),
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[topContent, bottomContent],
      ),
    );
  }

  void _showDialog(context,String name) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete Offer",style: TextStyle(color: Colors.redAccent)),
          content: new Text("Are you sure delete $name"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Delete",
              ),
              onPressed: ()  {
                deleteOffer(context);
              },
            ),
          ],
        );
      },
    );
  }
/*
  void _navigationToOfferDetail(BuildContext context, UserDetails userDetail) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OfferList(userDetail);
    }));
  }

*/



}

void requestOffer(BuildContext context, OfferDetailsAdmin offerDetails) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    //return RequestOffer(offerDetails);
  }));
}

