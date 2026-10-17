
import '../util/app_constants.dart';

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

String? _toStringOrNull(dynamic value) {
  return value?.toString();
}

String? _imageUrl(dynamic value) {
  if (value == null || value.toString().isEmpty) {
    return null;
  }

  return '${AppConstants.Image_URL}${value.toString()}';
}

class Shop {
  int? id;
  String? name;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<Items>? items;

  Shop({
    this.id,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.items,
  });

  Shop.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = _toStringOrNull(json['name']);
    status = _toInt(json['status']);
    createdAt = _toStringOrNull(json['created_at']);
    updatedAt = _toStringOrNull(json['updated_at']);

    final rawItems = json['items'];

    if (rawItems is List) {
      items = rawItems
          .whereType<Map>()
          .map(
            (item) => Items.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList();
    } else {
      items = [];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'items': items?.map((item) => item.toJson()).toList(),
    };
  }
}

class Items {
  int? id;
  String? name;
  String? svggift;
  String? imagegift;
  String? svga;
  String? image;
  int? shopcategoryId;
  int? price;
  String? state;
  int? kind;
  String? createdAt;
  String? updatedAt;
  int? important;
  int? month;
  int? day;
  int? sorting;

  Items({
    this.id,
    this.name,
    this.svggift,
    this.imagegift,
    this.shopcategoryId,
    this.price,
    this.state,
    this.createdAt,
    this.updatedAt,
    this.kind,
    this.svga,
    this.important,
    this.month,
    this.day,
    this.sorting,
    this.image,
  });

  Items.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = _toStringOrNull(json['name']);

    svggift = _imageUrl(json['svggift']);
    svga = _toStringOrNull(json['svggift']);

    imagegift = _imageUrl(json['imagegift']);
    image = _toStringOrNull(json['imagegift']);

    shopcategoryId = _toInt(json['shopcategory_id']);
    price = _toInt(json['price']);

    state = _toStringOrNull(json['state']);
    kind = _toInt(json['kind']);
    important = _toInt(json['important']);

    month = _toInt(json['month']);
    day = _toInt(json['day']);
    sorting = _toInt(json['sorting']);

    createdAt = _toStringOrNull(json['created_at']);
    updatedAt = _toStringOrNull(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'svggift': svga,
      'imagegift': image,
      'shopcategory_id': shopcategoryId,
      'price': price,
      'state': state,
      'kind': kind,
      'important': important,
      'month': month,
      'day': day,
      'sorting': sorting,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
