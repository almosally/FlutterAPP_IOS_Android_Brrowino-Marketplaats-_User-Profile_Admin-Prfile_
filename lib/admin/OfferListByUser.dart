import 'dart:convert';

import 'package:borrowinomobileapp/admin/admin_models/OfferDetails_admin.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'AdminPanel.dart';
import 'OfferInfo_admin.dart';
import 'admin_models/ImageDetails.dart';
import 'admin_models/UserDetails.dart';

class OfferList extends StatefulWidget {
  final UserDetails userDetails;

  OfferList(this.userDetails);

  @override
  _OfferListState createState() => new _OfferListState(userDetails);
}

class _OfferListState extends State<OfferList> {
  UserDetails userDetails;
  ImageDetails imageDetails;

  _OfferListState(this.userDetails);

  final List<OfferDetailsAdmin> items = [];

  final List<ImageDetails> imgs = [];

  //final String url = "http://10.0.2.2:8000/offers";



  String UserID = "";
  String offerImg = "";
  String temp;
  String imgUri;
  int offerNuCount;

  // final String ImgUrl="";

  @override
  void initState() {
    super.initState();

    print(userDetails.id);
    UserID = userDetails.id.toString();
    getNews(UserID);

  }

  //final String url = ;
  void getNews(String id) async {
    final http.Response response =
        await http.get("http://api.borrowino.ga/users/$id/offers");
    final Map<String, dynamic> responseData = json.decode(response.body);
    responseData['data'].forEach((offersDetail) async {
      final OfferDetailsAdmin offers = OfferDetailsAdmin(
        id: offersDetail['id'],
        created_at: offersDetail['created_at'],
        updated_at: offersDetail['updated_at'],
        description: offersDetail['description'],
        title: offersDetail['title'],
        location: offersDetail['location'],
        price: offersDetail['price'].toString(),
        image: offersDetail['images'].toString(),
        active: offersDetail['active'],
     //  offerCount: offerNuCount++

      );


       String x = offers.id.toString();
      if (  offersDetail['images']  == 1) {
        http.Response imgRequest =
            await http.get("http://api.borrowino.ga/offers/$x/images");
        final Map<String, dynamic> responseDataImage =
            json.decode(imgRequest.body);
        responseDataImage['images'].forEach((imageDetails) {
          final ImageDetails image1 = ImageDetails(images: "http://api.borrowino.ga/" + (imageDetails));
          imgs.add(image1);
        });
      } else {
          final ImageDetails image1 = ImageDetails(images: "https://map.gympluscoffee.com/wp-content/uploads/2018/12/Kerry-sky-observe.jpg");
          imgs.add(image1);
            }
      setState(() {
        print("xxxxxxxxxxxxxxxxxxxxxxxxxx");
        items.add(offers);
        print("offer id: "+offers.id.toString()+ " Link: " +offerImg);
        print("ssssssss"+ items.toString());
        print(imgs.toString());
      });
      if(items.length==null){ Fluttertoast.showToast(
          msg: "userName" + " has no offers");}
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(64, 75, 96, .9),
          elevation: 0.0,
          title: new Text(
            "Offers by:" + userDetails.name ,
            style: TextStyle(color: Colors.white),

          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () => {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => AdminPanelPage()))
              },
            )
          ],
        ),
        body: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: this.items.length,
            itemBuilder: _listViewItemBuilder));
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    var offerDetail = this.items[index];
    var imageDetail=this.imgs[index];
    return Container(
      width: 200,
      height: 120,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Color.fromRGBO(58, 66, 86, 1.0),
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              leading: Container(
                //  padding: EdgeInsets.only(right: 12.0),
                // decoration: new BoxDecoration(
                //     border: new Border(
                //        right:
                //          new BorderSide(width: 1.0, color: Colors.white24))),
                child: _itemThumbnail(offerDetail,imageDetail),

              ),
              // subtitle: _itemDescription(offerDetail),
              onTap: () {
                print(imageDetail.images);

                // print(getImageUrl(offerDetail.id));
                _navigationToOffDetail(context, offerDetail,userDetails,imageDetail.images);
              },trailing:  _itemPrice(offerDetail),
              // trailing: //PopUpMenuOffer(),
              //Icon(Icons.restore_from_trash,
              // color: Colors.redAccent, size: 18.0),
            ),
            new ListTile(
              // contentPadding:
              // EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              title: _itemTitle(offerDetail),
              subtitle: _itemDescription(offerDetail),

              trailing: Icon(Icons.restore_from_trash,
                  color: Colors.redAccent, size: 18.0),
              onTap: () {
                _showDialog(context, offerDetail.id.toString(),
                    offerDetail.title, userDetails);
              },
              // _showDialog(context,offerDetail.id.toString());},
            ),

          ],
        ),
      ),
    );
  }


  void _navigationToOffDetail(BuildContext context, OfferDetailsAdmin offerDetail,UserDetails userDetails,String imguri) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OfferInfoList(offerDetail,userDetails,imguri);
    }));
  }


  Widget _itemThumbnail(OfferDetailsAdmin offerDetail, ImageDetails image1) {
    //  String x=offerDetail.id.toString();
    return Container(
      width: 100,
      height: 100,
      child: ClipRRect(
        borderRadius: new BorderRadius.circular(7.0),
        child: Image(
          fit: BoxFit.contain,
          alignment: Alignment.topCenter,
          image: NetworkImage(image1.images),
    //"http://api.borrowino.ga/" + (Uri.encodeComponent(imageDetail.images))),
               //"https://map.gympluscoffee.com/wp-content/uploads/2018/12/Kerry-sky-observe.jpg"),
        ),
      ),
    );
  }

  Widget _itemTitle(OfferDetailsAdmin offerDetail) {
    return Text(
      offerDetail.title,
      style: TextStyle(
          color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.bold),
    );
  }

  Widget _itemDescription(OfferDetailsAdmin offerDetail) {
    return Text(
      offerDetail.description,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: Colors.white, fontSize: 9.0, fontWeight: FontWeight.normal),
    );
  }

  Widget _itemPrice(OfferDetailsAdmin offerDetail) {
    return Text(
     " Euro "+ offerDetail.price,
      overflow: TextOverflow.clip,
      style: TextStyle(
          color: Colors.white, fontSize: 9.0, fontWeight: FontWeight.normal),
    );
  }
}

void _showDialog(context, String id, String title, UserDetails userDetails) {
  Future<UserDetails> deleteOffer(String id) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    final http.Response response = await http.delete(
      'http://api.borrowino.ga/admin/offers/$id',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token.toString(),
      },
    );

    if (response.statusCode == 204) {
      Fluttertoast.showToast(msg: "!! Offer has been deleted !!");
      // If the server did return a 200 OK response,
      // then parse the JSON. After deleting,
      // you'll get an empty JSON `{}` response.
      // Don't return `null`, otherwise `snapshot.hasData`
      // will always return false on `FutureBuilder`.
      // return UserDetails.fromJson(jsonDecode(response.body));
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => OfferList(userDetails)));
    } else {
      // If the server did not return a "200 OK response",
      // then throw an exception.
      Fluttertoast.showToast(msg: "!! Can not delet offer !!");
      throw Exception('Failed to delete album.');
    }
  }

  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title:
            new Text("Delete Offer", style: TextStyle(color: Colors.redAccent)),
        content: new Text("Are you sure delete $title"),
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
            onPressed: () {
              deleteOffer(id);
            },
          ),
        ],
      );
    },
  );
}
