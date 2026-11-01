import 'dart:async';
import 'dart:io';

import 'package:ahlachat/Repositores/Shop_repositores/ShopRepository.dart';
import 'package:dio/dio.dart';

import '../../models/MyItemModel.dart';
import '../../models/ShopModel.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';

class shopapi extends ShopRepository {
  Shop shop = Shop();

  List<Shop> AllShop = [];
  List<Salesmodel> AllMyItems = [];

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.BASE_URL,
      headers: {
        'Accept': 'application/json',
        'Authorization': Token,
        'awqeASERQW': '8/325*mAIOEN',
        'userid': UserId.toString(),
        'UserIP': UserIP,
      },
    ),
  );

  // توحيد طباعة بيانات كل Request و Response.
  void _logRequest(String function, String method, String path,
      {Map<String, dynamic>? data}) {
    print('\n========== $function REQUEST ==========');
    print('METHOD: $method');
    print('URL: ${dio.options.baseUrl}$path');
    if (data != null) print('REQUEST DATA: $data');
    print('USER ID: $UserId');
    print('========================================');
  }

  void _logResponse(String function, Response response) {
    print('\n========== $function RESPONSE ==========');
    print('STATUS CODE: ${response.statusCode}');
    print('STATUS MESSAGE: ${response.statusMessage}');
    print('RESPONSE DATA: ${response.data}');
    print('RESPONSE HEADERS: ${response.headers}');
    print('========================================');
  }

  void _logDioError(String function, DioException e) {
    print('\n========== $function DIO ERROR ==========');
    print('REQUEST URL: ${e.requestOptions.uri}');
    print('REQUEST METHOD: ${e.requestOptions.method}');
    print('REQUEST DATA: ${e.requestOptions.data}');
    print('STATUS CODE: ${e.response?.statusCode}');
    print('STATUS MESSAGE: ${e.response?.statusMessage}');
    print('ERROR RESPONSE: ${e.response?.data}');
    print('ERROR MESSAGE: ${e.message}');
    print('ERROR TYPE: ${e.type}');
    print('=========================================');
  }

  void _logUnknownError(String function, Object e, StackTrace stackTrace) {
    print('\n========== $function UNKNOWN ERROR ==========');
    print('ERROR: $e');
    print('STACK TRACE: $stackTrace');
    print('=============================================');
  }

  void _showApiError(dynamic context, DioException e,
      {String fallback = 'حدث خطأ أثناء الاتصال بالسيرفر'}) {
    if (context == null) return;

    final data = e.response?.data;
    dynamic message;

    if (data is Map) {
      message = data['errNum'] ?? data['msg'] ?? data['message'];
    }

    message ??= e.message ?? fallback;

    Dialogs().ShowErrorRegesterToast(message.toString(), context);
  }

  Future<List<Shop>> getShop({context}) async {
    AllShop.clear();

    try {
      _logRequest('GetShopCategory', 'GET', '/api/GetShopCategory');

      final response = await dio.get('/api/GetShopCategory');
      _logResponse('GetShopCategory', response);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map && data['ShopCategory'] is List) {
          final List list = data['ShopCategory'];

          for (final element in list) {
            try {
              AllShop.add(
                Shop.fromJson(Map<String, dynamic>.from(element)),
              );
            } catch (e, stackTrace) {
              print('SHOP PARSING ERROR: $e');
              print('SHOP DATA: $element');
              print('STACK TRACE: $stackTrace');
            }
          }

          for (final category in AllShop) {
            print(
              'CATEGORY: id=${category.id} name=${category.name} items=${category.items?.length}',
            );
          }
        } else {
          print('INVALID RESPONSE FORMAT: $data');
          print('EXPECTED: response["ShopCategory"] must be a List');
        }
      }
    } on DioException catch (e) {
      _logDioError('GetShopCategory', e);
      _showApiError(
        context,
        e,
        fallback: 'حدث خطأ أثناء تحميل المتجر',
      );
    } catch (e, stackTrace) {
      _logUnknownError('GetShopCategory', e, stackTrace);
    }

    return AllShop;
  }

  Future<bool> ByeItem(
      {itemId, day, price, context, categoryid}) async {
    bool check = false;
    const function = 'ByeItem';
    const path = 'api/byeitem';

    final requestData = {
      'item_id': itemId.toString(),
      'user_id': UserId.toString(),
      'day': day.toString(),
      'price': price.toString(),
      'category_id': categoryid.toString(),
    };

    try {
      _logRequest(function, 'POST', path, data: requestData);
      final formData = FormData.fromMap(requestData);
      final response = await dio.post(path, data: formData);
      _logResponse(function, response);
      check = response.statusCode == 200;
    } on DioException catch (e) {
      check = false;
      _logDioError(function, e);
      _showApiError(context, e);
    } catch (e, stackTrace) {
      check = false;
      _logUnknownError(function, e, stackTrace);
    }

    print('$function RESULT: $check');
    return check;
  }

  Future<bool> SendByeShop(
      {itemId, day, price, userid, context, categoryid}) async {
    bool check = false;
    const function = 'SendByeShop';
    const path = 'api/SendItem';

    final requestData = {
      'item_id': itemId.toString(),
      'user_id': UserId.toString(),
      'reciver': userid.toString(),
      'day': day.toString(),
      'price': price.toString(),
      'category_id': categoryid.toString(),
    };

    try {
      _logRequest(function, 'POST', path, data: requestData);
      final formData = FormData.fromMap(requestData);
      final response = await dio.post(path, data: formData);
      _logResponse(function, response);
      check = response.statusCode == 200;
    } on DioException catch (e) {
      check = false;
      _logDioError(function, e);
      _showApiError(context, e);
    } catch (e, stackTrace) {
      check = false;
      _logUnknownError(function, e, stackTrace);
    }

    print('$function RESULT: $check');
    return check;
  }

  Future<bool> UpdateFrame({Frame, context}) async {
    return _postBoolean(
      function: 'UpdateFrame',
      path: 'api/Setframe',
      requestData: {'user_id': UserId.toString(), 'frame': Frame.toString()},
      context: context,
    );
  }

  Future<bool> UpdateEnterbubles({Frame, context}) async {
    return _postBoolean(
      function: 'UpdateEnterbubles',
      path: 'api/SetEnterbubles',
      requestData: {'user_id': UserId.toString(), 'frame': Frame.toString()},
      context: context,
    );
  }

  Future<bool> Updateprofilebubles({Frame, context}) async {
    return _postBoolean(
      function: 'Updateprofilebubles',
      path: 'api/Setprofilebubles',
      requestData: {'user_id': UserId.toString(), 'frame': Frame.toString()},
      context: context,
    );
  }

  Future<bool> RemoveFrame({context}) async {
    return _postBoolean(
      function: 'RemoveFrame',
      path: 'api/removeframe',
      requestData: {'user_id': UserId.toString()},
      context: context,
    );
  }

  Future<bool> UpdateEntry({Entry, context}) async {
    return _postBoolean(
      function: 'UpdateEntry',
      path: 'api/SetEntry',
      requestData: {'user_id': UserId.toString(), 'entry': Entry.toString()},
      context: context,
    );
  }

  Future<bool> RemoveEntry({context}) async {
    return _postBoolean(
      function: 'RemoveEntry',
      path: 'api/removeEntry',
      requestData: {'user_id': UserId.toString()},
      context: context,
    );
  }

  Future<bool> RemoveEnterbubles({context}) async {
    return _postBoolean(
      function: 'RemoveEnterbubles',
      path: 'api/removeEnterbubles',
      requestData: {'user_id': UserId.toString()},
      context: context,
    );
  }

  Future<bool> RemoveProfilebubles({context}) async {
    return _postBoolean(
      function: 'RemoveProfilebubles',
      path: 'api/RemoveProfilebubles',
      requestData: {'user_id': UserId.toString()},
      context: context,
    );
  }

  // تستخدمها كل دوال POST السابقة حتى تكون طباعة Status/Response/Error موحدة.
  Future<bool> _postBoolean({
    required String function,
    required String path,
    required Map<String, dynamic> requestData,
    dynamic context,
  }) async {
    bool check = false;

    try {
      _logRequest(function, 'POST', path, data: requestData);
      final formData = FormData.fromMap(requestData);
      final response = await dio.post(path, data: formData);
      _logResponse(function, response);
      check = response.statusCode == 200;
    } on DioException catch (e) {
      check = false;
      _logDioError(function, e);
      _showApiError(context, e);
    } catch (e, stackTrace) {
      check = false;
      _logUnknownError(function, e, stackTrace);
    }

    print('$function RESULT: $check');
    return check;
  }

  Future<List<Salesmodel>> GetMyBag() async {
    AllMyItems.clear();

    const function = 'GetMyBag';
    final path = '/api/GetuserShopCategory/${UserId.toString()}';

    try {
      _logRequest(function, 'GET', path);
      final response = await dio.get(path);
      _logResponse(function, response);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map && data['MyitemsCategory'] is List) {
          final List list = data['MyitemsCategory'];

          for (final element in list) {
            try {
              AllMyItems.add(
                Salesmodel.fromJson(Map<String, dynamic>.from(element)),
              );
            } catch (e, stackTrace) {
              print('GetMyBag ITEM PARSING ERROR: $e');
              print('ITEM DATA: $element');
              print('STACK TRACE: $stackTrace');
            }
          }
        } else {
          print('GetMyBag INVALID RESPONSE FORMAT: $data');
          print('EXPECTED: response["MyitemsCategory"] must be a List');
        }
      }
    } on DioException catch (e) {
      _logDioError(function, e);
    } catch (e, stackTrace) {
      _logUnknownError(function, e, stackTrace);
    }

    print('GetMyBag ITEMS COUNT: ${AllMyItems.length}');
    return AllMyItems;
  }
}
