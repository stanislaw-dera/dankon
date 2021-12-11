class TheUser {
  final String uid;
  final String name;
  final String urlAvatar;
  final String bio;

  TheUser({
    required this.uid,
    required this.name,
    required this.urlAvatar,
    required this.bio,
  });

  Map<String, dynamic> toJson() =>
      {'uid': uid, 'name': name, 'urlAvatar': urlAvatar, 'bio': bio};
}
