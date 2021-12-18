import 'package:dankon/models/the_user.dart';

List<TheUser> jsonToListOfUsers(List json) {

  List<TheUser> list = [];

  for(var i = 0; i<json.length; i++) {
    list.add(TheUser.fromJson(json[i]));
  }

  return list;
}

class Chat {
  final String id;
  final String chatroomName;
  final List allParticipants;
  final List participantsData;

  final int danks;
  final String lastDankAuthor;
  final DateTime lastDankTime;
  final DateTime danksStreakFrom;

  bool canIDank(String myUid) {
    if(lastDankAuthor != myUid) {
      return true;
    } else {
      return false;
    }
  }

  String getChatName(String myUid) {
    if(allParticipants.length > 2) {
      return chatroomName;
    }

    for(var i = 0; i<participantsData.length; i++) {
      if(participantsData[i].uid != myUid) {
        return participantsData[i].name;
      }
    }

    return "Unnamed chat";
  }

  String getChatImageUrl(String myUid) {

    for(var i = 0; i<participantsData.length; i++) {
      if(participantsData[i].uid != myUid) {
        return participantsData[i].urlAvatar;
      }
    }

    return "";
  }

  Chat(this.chatroomName, this.allParticipants, this.participantsData,
      this.danks, this.lastDankAuthor, this.danksStreakFrom, this.lastDankTime, this.id);

  Map<String, dynamic> toJson() => {
        'chatroomName': chatroomName,
        'allParticipants': allParticipants,
        'participantsData': participantsData,
        'danks': danks,
        'lastDankAuthor': lastDankAuthor,
        'lastDankTime': lastDankTime,
        'danksStreakFrom': danksStreakFrom,
      };

  Chat.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        chatroomName = json["name"],
        allParticipants = json["allParticipants"],
        participantsData = jsonToListOfUsers(json["participantsData"]),
        danks = json["danks"],
        lastDankAuthor = json["lastDankAuthor"] ?? "",
        lastDankTime = json["lastDankTime"] ?? DateTime(2000),
        danksStreakFrom = json["danksStreakFrom"] ?? DateTime(2000);
}
