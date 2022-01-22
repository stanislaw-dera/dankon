import 'package:dankon/utils/timestamp_to_datetime.dart';
import 'package:dankon/models/response.dart';
import 'package:dankon/models/the_user.dart';
import 'package:dankon/services/database.dart';

List<TheUser> jsonToListOfUsers(List json) {
  List<TheUser> list = [];

  for (var i = 0; i < json.length; i++) {
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
  final DateTime lastDankstreakTime;
  final DateTime dankstreakFrom;

  final DateTime lastMessageTime;
  final String lastMessageAuthor;
  final String lastMessageContent;

  bool canIDank(String myUid) {
    if (lastDankAuthor != myUid) {
      return true;
    } else {
      return false;
    }
  }

  String getChatName(String myUid) {
    if (allParticipants.length > 2) {
      return chatroomName;
    }

    for (var i = 0; i < participantsData.length; i++) {
      if (participantsData[i].uid != myUid) {
        return participantsData[i].name;
      }
    }

    return "Unnamed chat";
  }

  String getChatImageUrl(String myUid) {
    for (var i = 0; i < participantsData.length; i++) {
      if (participantsData[i].uid != myUid) {
        return participantsData[i].urlAvatar;
      }
    }

    return "";
  }

  bool startNewDankstreak() {
    DateTime from = DateTime.utc(lastDankstreakTime.year,
        lastDankstreakTime.month, lastDankstreakTime.day);
    int difference = DateTime.now().difference(from).inDays;

    if (difference > 1) {
      return true;
    } else {
      return false;
    }
  }

  int countDays() {
    DateTime from = DateTime.utc(
        dankstreakFrom.year, dankstreakFrom.month, dankstreakFrom.day);
    return lastDankstreakTime.difference(from).inDays;
  }

  Future<Response> incrementDanks(String uid) {
    return DatabaseService(uid: uid).incrementDanks(this, uid);
  }

  Chat(
      this.chatroomName,
      this.allParticipants,
      this.participantsData,
      this.danks,
      this.lastDankAuthor,
      this.dankstreakFrom,
      this.lastDankTime,
      this.id,
      this.lastDankstreakTime,
      this.lastMessageTime,
      this.lastMessageAuthor,
      this.lastMessageContent);

  Map<String, dynamic> toJson() => {
        'chatroomName': chatroomName,
        'allParticipants': allParticipants,
        'participantsData': participantsData,
        'danks': danks,
        'lastDankAuthor': lastDankAuthor,
        'lastDankTime': lastDankTime,
        'lastDankstreakTime': lastDankstreakTime,
        'dankstreakFrom': dankstreakFrom,
      };

  Chat.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        chatroomName = json["name"],
        allParticipants = json["allParticipants"],
        participantsData = jsonToListOfUsers(json["participantsData"]),
        danks = json["danks"],
        lastDankAuthor = json["lastDankAuthor"] ?? "",
        lastDankTime = timestampToDateTime(json["lastDankTime"]),
        lastDankstreakTime = timestampToDateTime(json["lastDankstreakTime"]),
        dankstreakFrom = timestampToDateTime(json["dankstreakFrom"]),
        lastMessageTime = timestampToDateTime(json["lastMessageTime"]),
        lastMessageAuthor = json["lastMessageAuthor"] ?? "",
        lastMessageContent = json["lastMessageContent"] ?? "";
}
