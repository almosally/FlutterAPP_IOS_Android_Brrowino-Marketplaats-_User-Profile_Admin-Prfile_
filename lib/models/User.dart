class User{
  final String id;
  final String name;
  final String email;
  final int isAdmin;
  User({this.id, this.name, this.email, this.isAdmin});



  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isAdmin: json['is_admin']
    );
  }
}