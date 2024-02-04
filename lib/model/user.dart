class User {
  final String userId;

  const User({
    required this.userId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'userId': String userId,
      } =>
        User(
          userId: userId,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
