class OfferDetailsAdmin {
  final int id;
  final String created_at;
  final String updated_at;
  final String title;
  final String description;
  final String location;
  final String owner;
  final String price;
  final String image;
  final int active;
  final int offerCount;

  OfferDetailsAdmin(
      {this.id,
      this.created_at,
      this.updated_at,
      this.title,
      this.description,
      this.location,
      this.owner,
      this.price,
      this.image,
      this.active,
      this.offerCount});

  factory OfferDetailsAdmin.fromJson(Map<String, dynamic> json) {
    return OfferDetailsAdmin(
      title: json['title'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      description: json['description'],
      location: json['location'],
      owner: json['owner'],
      price: json['price'],
      active: json['active'],
    );
  }
}
