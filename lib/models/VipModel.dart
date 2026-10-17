

import 'package:ahlachat/util/app_constants.dart';

class VipModel {
  int? id;
  String? gif;
  String? name;
  int? status;
  String? vipicon;
  var backgroundimage ;
  String? urlentry;
  String? urlframe;
  String?  entry;
  String?  frame;
  String? bubbles;
  int? level;
  int? specialID;
  var profileEntry;
  var urlprofileEntry;
  var coloredMessage;
  var hidden;
  String? createdAt;
  String? updatedAt;
  int? cost;
  int? day;
  VipModel(
      {this.id,
        this.gif,
        this.name,
        this.status,
        this.vipicon,
        this.backgroundimage,
        this.urlentry,
        this.urlframe,
        this.level,
        this.specialID,
        this.profileEntry,
        this.coloredMessage,
        this.hidden,
        this.cost,
        this.day,
        this.createdAt,
        this.updatedAt,
        this.urlprofileEntry
      });


  VipModel.fromJson(Map<String, dynamic> json) {
    String? nullableString(dynamic value) {
      if (value == null) return null;
      return value.toString();
    }

    int? nullableInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString());
    }

    String? imageUrl(dynamic value) {
      if (value == null || value.toString().isEmpty) {
        return null;
      }

      return '${AppConstants.Image_URL}${value.toString()}';
    }

    id = nullableInt(json['id']);

    gif = imageUrl(json['Gif'] ?? json['gif']);
    name = nullableString(json['name']);
    status = nullableInt(json['status']);
    vipicon = imageUrl(json['vipicon']);

    backgroundimage = imageUrl(json['background_image']);

    urlentry = imageUrl(json['Entry']);
    urlframe = imageUrl(json['Frame']);

    entry = nullableString(json['Entry']);
    frame = nullableString(json['Frame']);

    level = nullableInt(json['Level']);
    cost = nullableInt(json['cost']);
    specialID = nullableInt(json['SpecialID']);

    profileEntry = imageUrl(json['ProfileEntry']);
    urlprofileEntry = imageUrl(json['ProfileEntry']);
    bubbles = nullableString(json['ProfileEntry']);

    coloredMessage = json['ColoredMessage'];
    hidden = json['Hidden'];

    day = nullableInt(json['days']);

    createdAt = nullableString(json['created_at']);
    updatedAt = nullableString(json['updated_at']);
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Gif'] = this.gif;
    data['name'] = this.name;
    data['status'] = this.status;
    data['vipicon'] = this.vipicon;
    data['Entry'] = this.urlentry;
    data['Frame'] = this.urlframe;
    data['Level'] = this.level;
    data['background_image'] =this.backgroundimage;
    data['SpecialID'] = this.specialID;
    data['ProfileEntry'] = this.profileEntry;
    data['ColoredMessage'] = this.coloredMessage;
    data['Hidden'] = this.hidden;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}