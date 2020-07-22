class ReportDetails {
  final int id;
  final int offer_id;
  final String description;
  final int reporter_id;
  final String created_at;
  final String updated_at;

  ReportDetails({
    this.id,
    this.offer_id,
    this.description,
    this.created_at,
    this.updated_at,
    this.reporter_id
  });

  factory ReportDetails.fromJson(Map<String, dynamic> json) {
    return ReportDetails(
      id: json['id'],
      offer_id: json['offer_id'],
      description: json['description'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
        reporter_id:json['reporter_id']

    );
  }
}