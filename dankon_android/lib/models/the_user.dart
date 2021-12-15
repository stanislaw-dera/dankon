class TheUser {
  final String uid;
  final String name;
  final String urlAvatar;

  TheUser({
    required this.uid,
    required this.name,
    required this.urlAvatar
  });


  Map<String, dynamic> toJson() =>
      {'uid': uid, 'name': name, 'urlAvatar': urlAvatar};

  TheUser.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        name = json["name"],
        urlAvatar = json["urlAvatar"];
}
