class OfferDetails {
  final int id;
  final String title;
  final String description;
  final int active;
  final String location;
  final String owner;
  final String price;
  final String image;
  final String url =
      "https://i1.wp.com/ilikeweb.co.za/wp-content/uploads/2019/07/placeholder.png?ssl=1";

  OfferDetails(
      {this.id,
        this.title,
        this.description,
        this.location,
        this.owner,
        this.price,
        this.image,
      this.active});

}