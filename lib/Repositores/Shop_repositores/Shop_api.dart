import 'dart:async';
import 'dart:io';

import 'package:ahlachat/Repositores/Shop_repositores/ShopRepository.dart';
import 'package:dio/dio.dart';

import '../../models/MyItemModel.dart';
import '../../models/ShopModel.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';



class shopapi extends ShopRepository {


  Shop shop=Shop() ;
List<Shop> AllShop=[];
  List<Salesmodel> AllMyItems=[];
  var dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.BASE_URL,
      headers: {
        'Accept': 'application/json',
        'Authorization':Token,
        'awqeASERQW':'8/325*mAIOEN',
        'userid':UserId.toString(),
        'UserIP':UserIP,
      },
    ),
  );



  Future<List<Shop>> getShop({context}) async {
    AllShop.clear();

    try {
      Response response2 = await dio.get(
        '/api/GetShopCategory',
      );

      print('========== GetShopCategory RESPONSE ==========');
      print('STATUS CODE: ${response2.statusCode}');
      print('RESPONSE DATA: ${response2.data}');
      print('RESPONSE HEADERS: ${response2.headers}');
      print('===============================================');

      if (response2.statusCode == 200) {
        final data = response2.data;

        if (data is Map && data['ShopCategory'] is List) {
          final List list = data['ShopCategory'];

          for (final element in list) {
            try {
              AllShop.add(
                Shop.fromJson(
                  Map<String, dynamic>.from(element),
                ),
              );
            } catch (e, stackTrace) {
              print('========== SHOP PARSING ERROR ==========');
              print('ERROR: $e');
              print('SHOP DATA: $element');
              print('STACK TRACE: $stackTrace');
              print('========================================');
            }
          }
        } else {
          print('INVALID RESPONSE FORMAT');
          print('EXPECTED KEY: ShopCategory (List)');
          print('ACTUAL RESPONSE: $data');
        }
      }
    } on DioException catch (e) {
      print('========== GetShopCategory DIO ERROR ==========');
      print('REQUEST URL: ${e.requestOptions.uri}');
      print('REQUEST METHOD: ${e.requestOptions.method}');
      print('STATUS CODE: ${e.response?.statusCode}');
      print('RESPONSE DATA: ${e.response?.data}');
      print('ERROR MESSAGE: ${e.message}');
      print('ERROR TYPE: ${e.type}');
      print('===============================================');

      final responseData = e.response?.data;

      if (context != null && responseData is Map) {
        final errorMessage =
            responseData['msg'] ??
                responseData['message'] ??
                responseData['errNum'] ??
                'حدث خطأ أثناء تحميل المتجر';

        Dialogs().ShowErrorToast(
          errorMessage.toString(),
          context,
        );
      } else if (context != null) {
        Dialogs().ShowErrorToast(
          'حدث خطأ أثناء الاتصال بالسيرفر',
          context,
        );
      }
    } catch (e, stackTrace) {
      print('========== GetShopCategory UNKNOWN ERROR ==========');
      print('ERROR: $e');
      print('STACK TRACE: $stackTrace');
      print('====================================================');
    }

    return AllShop;
  }


  Future<bool> ByeItem({itemId,day,price, context,categoryid}) async {
    bool check=false;

    try {
      FormData formData = new FormData.fromMap({
        "item_id": itemId.toString(),
        "user_id": UserId.toString(),
        "day": day.toString(),
        "price": price.toString(),
        "category_id":categoryid.toString(),
      });

      Response response2 = await dio.post(
        'api/byeitem',
        data: formData,
      );
       
      if (response2.statusCode == 200) {
         check=true;
         
      }else{
         
        check=false;
      }
    } catch (e) {
      check=false;

      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {

      }
    }

    return check;
  }

  Future<bool> SendByeShop({itemId,day,price,userid, context,categoryid}) async {
    bool check=false;

    try {
      FormData formData = new FormData.fromMap({
        "item_id": itemId.toString(),
        "user_id": UserId.toString(),
        "reciver":userid.toString(),
        "day": day.toString(),
        "price": price.toString(),
        "category_id":categoryid.toString(),
      });

      Response response2 = await dio.post(
        'api/SendItem',
        data: formData,
      );

      if (response2.statusCode == 200) {
         check=true;

      }else{

        check=false;
      }
    } catch (e) {
      check=false;

    }

    return check;
  }
  Future<bool> UpdateFrame({Frame,context}) async {
    bool check=false;


    try {
      FormData formData = new FormData.fromMap({

        "user_id": UserId.toString(),
        "frame": Frame.toString(),

      });

      Response response2 = await dio.post(
        'api/Setframe',
        data: formData,
      );
       
      if (response2.statusCode == 200) {
         
        check=true;
         
      }else{
         
        check=false;
      }
    } catch (e) {
      check=false;

      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return check;
  }

  Future<bool> UpdateEnterbubles({Frame,context}) async {
    bool check=false;


    try {
      FormData formData = new FormData.fromMap({

        "user_id": UserId.toString(),
        "frame": Frame.toString(),

      });

      Response response2 = await dio.post(
        'api/SetEnterbubles',
        data: formData,
      );

      if (response2.statusCode == 200) {

        check=true;

      }else{

        check=false;
      }
    } catch (e) {
      check=false;

      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return check;
  }
  Future<bool> Updateprofilebubles({Frame,context}) async {
    bool check=false;


    try {
      FormData formData = new FormData.fromMap({

        "user_id": UserId.toString(),
        "frame": Frame.toString(),

      });

      Response response2 = await dio.post(
        'api/Setprofilebubles',
        data: formData,
      );

      if (response2.statusCode == 200) {

        check=true;

      }else{

        check=false;
      }
    } catch (e) {
      check=false;

      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return check;
  }
  Future<bool> RemoveFrame({context}) async {
    bool check=false;


    try {
      FormData formData = new FormData.fromMap({

        "user_id": UserId.toString(),


      });

      Response response2 = await dio.post(
        'api/removeframe',
        data: formData,
      );
       
      if (response2.statusCode == 200) {
         
        check=true;
         
      }else{
         
        check=false;
      }
    } catch (e) {
      check=false;
      print(e);
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return check;
  }

  Future<bool> UpdateEntry({Entry,context}) async {
    bool check=false;


    try {
      FormData formData = new FormData.fromMap({

        "user_id": UserId.toString(),
        "entry": Entry.toString(),

      });

      Response response2 = await dio.post(
        'api/SetEntry',
        data: formData,
      );
       
      if (response2.statusCode == 200) {
         
        check=true;
         
      }else{
         
        check=false;
      }
    } catch (e) {
      check=false;
      print(e);
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return check;
  }

  Future<bool> RemoveEntry({context}) async {
    bool check=false;


    try {
      FormData formData = new FormData.fromMap({

        "user_id": UserId.toString(),


      });

      Response response2 = await dio.post(
        'api/removeEntry',
        data: formData,
      );
       
      if (response2.statusCode == 200) {
         
        check=true;
         
      }else{
         
        check=false;
      }
    } catch (e) {
      check=false;
      print(e);
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return check;
  }

  Future<bool> RemoveEnterbubles({context}) async {
    bool check=false;


    try {
      FormData formData = new FormData.fromMap({

        "user_id": UserId.toString(),


      });

      Response response2 = await dio.post(
        'api/removeEnterbubles',
        data: formData,
      );

      if (response2.statusCode == 200) {

        check=true;

      }else{

        check=false;
      }
    } catch (e) {
      check=false;
      print(e);
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return check;
  }
  Future<bool> RemoveProfilebubles({context}) async {
    bool check=false;


    try {
      FormData formData = new FormData.fromMap({

        "user_id": UserId.toString(),


      });

      Response response2 = await dio.post(
        'api/RemoveProfilebubles',
        data: formData,
      );

      if (response2.statusCode == 200) {

        check=true;

      }else{

        check=false;
      }
    } catch (e) {
      check=false;
      print(e);
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return check;
  }
  Future<List<Salesmodel>> GetMyBag( ) async {
    try {

      Response response2 = await dio.get(
        '/api/GetuserShopCategory/${UserId.toString()}',
      );
      if (response2.statusCode == 200) {
          List list =response2.data['MyitemsCategory'] ;
         list.forEach((element) {
          AllMyItems.add(Salesmodel.fromJson(element));
         });
 
      }
    } catch (e) {

    }

    return AllMyItems;
  }

}
