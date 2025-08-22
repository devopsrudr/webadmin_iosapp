class BannerModel {
  final String id;
  final String image;

  BannerModel({
    required this.id,
    required this.image,
  });

  BannerModel.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        image = json['image'];

  Map<String, dynamic> toJson() => {
        'image': image,
      };
}
