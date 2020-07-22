class Request {
  final int id;
  final int borrower;
  final int offerid;
  final String from;
  final String until;
  final String description;
  final String status;
  final String created_at;
  final String updated_at;
  final int laravel_through_key;

  Request({this.offerid, this.from, this.until, this.description, this.id, this.borrower, this.created_at, this.laravel_through_key, this.status, this.updated_at});

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json["id"],
      borrower: json["borrower"],
      offerid: json["offer"],
      from: json["from"],
      until: json["until"],
      description: json["description"],
      status: json["status"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      laravel_through_key: json["laravel_through_key"],
    );
  }
}