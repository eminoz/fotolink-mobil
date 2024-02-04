class UserImages {
  String? user_id;
  List<String> images;
  String? imageUrl;
  String? linker_name;

  UserImages(
      {this.user_id, required this.images, this.imageUrl, this.linker_name});

  factory UserImages.fromJson(Map<String, dynamic> json) {
    return UserImages(
      user_id: json['user_id'],
      images: List<String>.from(json['images']?.cast<String>() ?? []),
      imageUrl: json['image_url'] ?? '',
      linker_name: json['linker_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'images': images,
      'linker_name': linker_name,
      'image_url':
          imageUrl, // JSON'daki alan adını doğru şekilde belirtmelisiniz
    };
  }
}
