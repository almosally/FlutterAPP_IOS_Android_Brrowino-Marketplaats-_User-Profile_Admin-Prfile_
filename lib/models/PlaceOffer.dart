import 'dart:io';

class Offer {
  final int id;
  final String title;
  final String desc;
  final String location;
  final int price;
  final File image;

  Offer({this.id,this.title, this.desc, this.location, this.price,this.image});

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      title: json['title'],
      desc: json['description'],
      location: json['location'],
      price: json['price'] as int,
      image: json['images'],
    );
  }
}