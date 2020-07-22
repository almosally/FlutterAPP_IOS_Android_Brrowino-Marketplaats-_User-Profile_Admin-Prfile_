class UserOfferDetails{
  final String id;
  final String title;
  final String description;
  final String location;
  final String owner;
  final String price;
  final String image; //= "https://i1.wp.com/ilikeweb.co.za/wp-content/uploads/2019/07/placeholder.png?ssl=1";
  UserOfferDetails({this.title, this.description, this.location,this.owner,this.price,this.image, this.id});


  factory UserOfferDetails.fromJson(Map<String, dynamic> json) {
    return UserOfferDetails(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      owner: json['owner'],
      price: json['price'],
      image: json['image'],
    );
  }
}
