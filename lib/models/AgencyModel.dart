import 'package:ahlachat/models/Usermodel.dart';
import '../util/app_constants.dart';
import '../util/fixed_image_url.dart';

class Agencymodel {
  int? id;
  String? name;
  int? userId;
  var description;
  String? password;
  int? coins;
  int? agencyKind;
  var model;
  var image;
  String? appid = '';
  var userNumber;
  int? ban;
  String? createdAt;
  String? updatedAt;
  usermodel? user;

// Safely convert API values to int.
  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  Agencymodel({
    this.id,
    this.name,
    this.userId,
    this.description,
    this.password,
    this.coins,
    this.agencyKind,
    this.model,
    this.image,
    this.userNumber,
    this.ban,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.appid,
  });

  Agencymodel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = json['name']?.toString();
    userId = _toInt(json['user_id']);
    appid = json['appid']?.toString();

    description = json['description'];
    password = json['password']?.toString();
    coins = _toInt(json['coins']);
    agencyKind = _toInt(json['sellingTarget']);

    model = fixImageUrl(json['model']) ?? '';

    image = fixImageUrl(json['image']) ?? '';

    userNumber = _toInt(json['user_number']);
    ban = _toInt(json['ban']);

    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();

    user = json['user'] is Map<String, dynamic>
        ? usermodel.fromJson(
            Map<String, dynamic>.from(json['user']),
          )
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['name'] = name;
    data['user_id'] = userId;
    data['appid'] = appid;
    data['description'] = description;
    data['password'] = password;
    data['coins'] = coins;
    data['sellingTarget'] = agencyKind;
    data['model'] = model;
    data['image'] = image;
    data['user_number'] = userNumber;
    data['ban'] = ban;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;

    if (user != null) {
      data['user'] = user!.toJson();
    }

    return data;
  }
}
