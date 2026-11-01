
import 'package:ahlachat/models/RoomModel.dart';

class LeaderboardRoommodel {
  String? coins;
  int? roomId;
  RoomModel? room;

  LeaderboardRoommodel({
    this.coins,
    this.roomId,
    this.room,
  });

  LeaderboardRoommodel.fromJson(Map<String, dynamic> json) {
    // coins ممكن يرجع int أو String
    coins = json['coins']?.toString();

    // room_id ممكن يرجع int أو String
    roomId = int.tryParse(json['room_id']?.toString() ?? '');

    // room ممكن تكون null
    if (json['room'] != null) {
      room = RoomModel.fromJson(
        Map<String, dynamic>.from(json['room']),
      );
    } else {
      room = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['coins'] = coins;
    data['room_id'] = roomId;

    if (room != null) {
      data['room'] = room!.toJson();
    }

    return data;
  }
}

class ListoflEaderboardcategoryRoom {
  List<LeaderboardRoommodel>? weeklysupporter;
  List<LeaderboardRoommodel>? monthlysupporter;
  List<LeaderboardRoommodel>? dailysupporter;

  ListoflEaderboardcategoryRoom({
    this.weeklysupporter,
    this.monthlysupporter,
    this.dailysupporter,
  });

  ListoflEaderboardcategoryRoom.fromJson(
      Map<String, dynamic> json) {

    if (json['weeklysupporter'] is List) {
      weeklysupporter = (json['weeklysupporter'] as List)
          .map((v) => LeaderboardRoommodel.fromJson(
        Map<String, dynamic>.from(v),
      ))
          .toList();
    }

    if (json['Monthlysupporter'] is List) {
      monthlysupporter = (json['Monthlysupporter'] as List)
          .map((v) => LeaderboardRoommodel.fromJson(
        Map<String, dynamic>.from(v),
      ))
          .toList();
    }

    if (json['dailysupporter'] is List) {
      dailysupporter = (json['dailysupporter'] as List)
          .map((v) => LeaderboardRoommodel.fromJson(
        Map<String, dynamic>.from(v),
      ))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (weeklysupporter != null) {
      data['weeklysupporter'] =
          weeklysupporter!.map((v) => v.toJson()).toList();
    }

    if (monthlysupporter != null) {
      data['Monthlysupporter'] =
          monthlysupporter!.map((v) => v.toJson()).toList();
    }

    if (dailysupporter != null) {
      data['dailysupporter'] =
          dailysupporter!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
