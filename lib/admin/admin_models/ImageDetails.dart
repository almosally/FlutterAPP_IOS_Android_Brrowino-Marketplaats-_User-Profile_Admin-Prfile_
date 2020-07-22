class ImageDetails {
  final String images;

  ImageDetails({
    this.images,
  });

  factory ImageDetails.fromJson(Map<String, dynamic> json) {
    return ImageDetails(
      images: json['images'],
    );
  }
}
