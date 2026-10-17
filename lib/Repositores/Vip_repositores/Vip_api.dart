
import 'package:ahlachat/models/MyVip.dart';
import 'package:dio/dio.dart';

import '../../models/VipModel.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';
import '../Moment_repositores/Moment_repository.dart';

class Vipapi extends MomentRepository {
  @override
  var dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.BASE_URL,
      headers: {
        'Accept': 'application/json',
        'Connection': 'Keep-Alive',
        'Authorization': Token,
        'awqeASERQW': '8/325*mAIOEN',
        'userid': UserId.toString(),
        'UserIP': UserIP,
      },
    ),
  );

  List<VipModel> Vips = [];
  List<MyVipmodel> MyVips = [];

  // Print successful responses and errors
  void printDioError(String apiName, DioException e) {
    print('========== $apiName ERROR ==========');
    print('URL: ${e.requestOptions.uri}');
    print('METHOD: ${e.requestOptions.method}');
    print('STATUS CODE: ${e.response?.statusCode}');
    print('RESPONSE DATA: ${e.response?.data}');
    print('ERROR MESSAGE: ${e.message}');
    print('ERROR TYPE: ${e.type}');
    print('=====================================');
  }

  Future<List<VipModel>> GetVips() async {
    // Prevent duplicate data after calling the API again
    Vips.clear();

    try {
      Response response2 = await dio.get('/api/GetVip');

      print('========== GetVips RESPONSE ==========');
      print('STATUS CODE: ${response2.statusCode}');
      print('RESPONSE DATA: ${response2.data}');
      print('======================================');

      if (response2.statusCode == 200) {
        final data = response2.data;

        if (data is Map && data['Vip'] is List) {
          Vips = (data['Vip'] as List)
              .map((element) => VipModel.fromJson(element))
              .toList();
        } else {
          print('GetVips: Invalid response format');
        }
      }
    } on DioException catch (e) {
      printDioError('GetVips', e);
    } catch (e, stackTrace) {
      print('GetVips UNKNOWN ERROR: $e');
      print('STACK TRACE: $stackTrace');
    }

    return Vips;
  }

  Future<List<MyVipmodel>> GetMyVips() async {
    // Prevent duplicate data after calling the API again
    MyVips.clear();

    try {
      Response response2 = await dio.get('/api/GetMyVips/$UserId');

      print('========== GetMyVips RESPONSE ==========');
      print('STATUS CODE: ${response2.statusCode}');
      print('RESPONSE DATA: ${response2.data}');
      print('========================================');

      if (response2.statusCode == 200) {
        final data = response2.data;

        if (data is Map && data['MyVip'] is List) {
          MyVips = (data['MyVip'] as List)
              .map((element) => MyVipmodel.fromJson(element))
              .toList();
        } else {
          print('GetMyVips: Invalid response format');
        }
      }
    } on DioException catch (e) {
      printDioError('GetMyVips', e);
    } catch (e, stackTrace) {
      print('GetMyVips UNKNOWN ERROR: $e');
      print('STACK TRACE: $stackTrace');
    }

    return MyVips;
  }
}
