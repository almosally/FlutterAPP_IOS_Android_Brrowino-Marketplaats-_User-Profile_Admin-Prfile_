class UserDetails {
  final int id;
  final String name;
  final String email;
  final int images;
  final int is_admin;
  final int userCount;

  UserDetails({
    this.id,
    this.name,
    this.email,
    this.images,
    this.is_admin,
  this.userCount
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      images: json['images'],
      is_admin: json['is_admin'],

    );
  }
}