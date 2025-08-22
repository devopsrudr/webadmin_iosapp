class Category {
  final String id;
  final String name;
  final String image;
  final String banner;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.banner,
  });

  Category.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        image = json['image'],
        banner = json['banner'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
        'banner': banner,
      };
}
