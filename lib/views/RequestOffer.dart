import 'dart:convert';
import 'package:borrowinomobileapp/admin/UsersProfile.dart';
import 'package:borrowinomobileapp/models/OfferDetails.dart';
import 'package:borrowinomobileapp/models/PlaceOffer.dart';
import 'package:borrowinomobileapp/views/MyPosts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:borrowinomobileapp/models/UserOfferDetails.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class RequestOffer extends StatefulWidget {

  OfferDetails offerDetails;
  RequestOffer(this.offerDetails);

  @override
  _RequestOfferState createState() => _RequestOfferState(offerDetails);
}

class _RequestOfferState extends State<RequestOffer> {

  OfferDetails offerDetails;
  _RequestOfferState(this.offerDetails);

  String _date = "From Date";
  String _time = "From Time";
  String _tilldate = "Till Date";
  String _tilltime = "Till Time";
  int id;
  String OfferID;
  String title;

  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    print("this is offer id " + offerDetails.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(64, 75, 96, .9),
        title: Text('Request offer: ' + offerDetails.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      minTime: DateTime(2000, 1, 1),
                      maxTime: DateTime(2022, 12, 31),
                      onConfirm: (date) {
                        print('confirm $date');
                        _date = '${date.year}-${date.month}-${date.day}';
                        setState(() {});
                      },
                      currentTime: DateTime.now(),
                      locale: LocaleType.en);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 18.0,
                                  color: Colors.grey,
                                ),
                                Text(
                                  " $_date",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "  Change",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showTimePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      onConfirm: (time) {
                        print('confirm $time');
                        _time =
                        '${time.hour}:${time.minute}:${time.second}';
                        setState(() {});
                      },
                      currentTime: DateTime.now(),
                      locale: LocaleType.en);
                  //setState(() {});
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  size: 18.0,
                                  color: Colors.grey,
                                ),
                                Text(
                                  " $_time",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "  Change",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      minTime: DateTime(2000, 1, 1),
                      maxTime: DateTime(2022, 12, 31),
                      onConfirm: (date) {
                        print('confirm $_tilldate');
                        _tilldate = '${date.year}-${date.month}-${date.day}';
                        setState(() {});
                      },
                      currentTime: DateTime.now(),
                      locale: LocaleType.en);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 18.0,
                                  color: Colors.grey,
                                ),
                                Text(
                                  " $_tilldate",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "  Change",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showTimePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      onConfirm: (time) {
                        print('confirm $time');
                        _tilltime =
                        '${time.hour}:${time.minute}:${time.second}';
                        setState(() {});
                      },
                      currentTime: DateTime.now(),
                      locale: LocaleType.en);
                  //setState(() {});
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  size: 18.0,
                                  color: Colors.grey,
                                ),
                                Text(
                                  " $_tilltime",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "  Change",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              SizedBox(
                height: 60.0,
              ),
              Container(
                alignment: Alignment.center,
                height: 50.0,
                child: TextField(
                  controller: descriptionController,
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.local_offer),
                    hintText: 'Enter your request description',
                    labelText: '',
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              new GFButton(
                onPressed: (){  requestOffer(context); },
                text: "Request Offer",
                icon: Icon(Icons.add),
                size:40,
                textStyle: TextStyle (fontSize: 17, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  //update function
  Future<Offer> requestOffer(BuildContext context) async {


    String fromdate = _date + " " + _time;
    String tilldate = _tilldate + " " + _tilltime;

    print(fromdate);
    String offerId = offerDetails.id.toString();
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    final http.Response response = await http.post('https://api.borrowino.ga/offers/$offerId/requests',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer '+ token.toString(),
        'Accept' : 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'from': fromdate,
        'until': tilldate,
        'description': descriptionController.text.toString(),
      }),
      //encoding: Encoding.getByName('charset=UTF-8')
    );

    if (response.statusCode == 201) {
      print('Request send');
      Fluttertoast.showToast(
          msg: "!! Offer " + offerDetails.title + " has been requested !!");
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
