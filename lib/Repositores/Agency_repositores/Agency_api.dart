import 'package:ahlachat/models/JoinRequestModel.dart';
import 'package:ahlachat/models/Leaderboardusermodel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../models/AgencyModel.dart';
import '../../models/Joinagency.dart';
import '../../models/Usermodel.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';
import '../Moment_repositores/Moment_repository.dart';

int Indexxx = 2;
int Indexxx2 = 2;

class Agencyapi extends MomentRepository {
  List<Agencymodel> Agences = [];
  List<joinagincy> joinagincys = [];
  List<usermodel> useragincys = [];
  List<Agencymodel> Searchagency = [];

  // Prints request, response status/body, and Dio errors for every API call.
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
  )..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint('\n========== AGENCY API REQUEST ==========');
        debugPrint('METHOD: ${options.method}');
        debugPrint('URL: ${options.uri}');
        debugPrint('QUERY PARAMETERS: ${options.queryParameters}');
        debugPrint('REQUEST DATA: ${_safeToString(options.data)}');
        // Do not print Authorization or other potentially sensitive headers.
        debugPrint('========================================\n');
        handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint('\n========== AGENCY API RESPONSE ==========');
        debugPrint('METHOD: ${response.requestOptions.method}');
        debugPrint('URL: ${response.requestOptions.uri}');
        debugPrint('STATUS CODE: ${response.statusCode}');
        debugPrint('STATUS MESSAGE: ${response.statusMessage}');
        debugPrint('RESPONSE BODY: ${_safeToString(response.data)}');
        debugPrint('=========================================\n');
        handler.next(response);
      },
      onError: (DioException error, handler) {
        debugPrint('\n========== AGENCY API ERROR ==========');
        debugPrint('METHOD: ${error.requestOptions.method}');
        debugPrint('URL: ${error.requestOptions.uri}');
        debugPrint('DIO ERROR TYPE: ${error.type}');
        debugPrint('MESSAGE: ${error.message}');
        debugPrint('STATUS CODE: ${error.response?.statusCode}');
        debugPrint('STATUS MESSAGE: ${error.response?.statusMessage}');
        debugPrint('ERROR RESPONSE BODY: ${_safeToString(error.response?.data)}');
        debugPrint('======================================\n');
        handler.next(error);
      },
    ),
  );

  static String _safeToString(dynamic value) {
    try {
      return value?.toString() ?? 'null';
    } catch (_) {
      return 'Unable to print value';
    }
  }

  Future<bool> EditAgencyNames(id, name) async {
    try {
      final Response response = await dio.get('/api/EditAgencyName/$id/$name');
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint('EditAgencyNames failed: ${e.message}');
      return false;
    } catch (e, stackTrace) {
      debugPrint('EditAgencyNames unexpected error: $e');
      debugPrint('$stackTrace');
      return false;
    }
  }

  List<JoinRequestModel> JoinRequestes = [];

  Future<List<JoinRequestModel>> GetJoinRequests({id}) async {
    JoinRequestes.clear();
    try {
      final Response response = await dio.get('/api/GetJoinRequests/$id');
      if (response.statusCode == 200) {
        final List list = response.data['request'] as List;
        JoinRequestes.addAll(
          list.map((element) => JoinRequestModel.fromJson(element)),
        );
      }
    } on DioException catch (e) {
      debugPrint('GetJoinRequests failed: ${e.message}');
    } catch (e, stackTrace) {
      debugPrint('GetJoinRequests parsing/unexpected error: $e');
      debugPrint('$stackTrace');
    }
    return JoinRequestes;
  }

  Future<bool> AcceptJoinRequests({id}) async {
    try {
      final Response response = await dio.get('/api/AcceptJoinRequests/$id');
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      debugPrint('AcceptJoinRequests failed: ${e.message}');
      return false;
    } catch (e, stackTrace) {
      debugPrint('AcceptJoinRequests unexpected error: $e');
      debugPrint('$stackTrace');
      return false;
    }
  }

  Future<bool> refuseJoinRequests({id}) async {
    try {
      final Response response = await dio.get('/api/refuseJoinRequests/$id');
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      debugPrint('refuseJoinRequests failed: ${e.message}');
      return false;
    } catch (e, stackTrace) {
      debugPrint('refuseJoinRequests unexpected error: $e');
      debugPrint('$stackTrace');
      return false;
    }
  }

  Future<List<Agencymodel>> Agency(context) async {
    Indexxx = 2;
    Agences.clear();
    try {
      final Response response = await dio.get('/api/GetAgency');
      if (response.statusCode == 200) {
        final List list = response.data['Agency']['data'] as List;
        Agences.addAll(list.map((e) => Agencymodel.fromJson(e)));
      }
    } on DioException catch (e) {
      debugPrint('Agency failed: ${e.message}');
    } catch (e, stackTrace) {
      debugPrint('Agency parsing/unexpected error: $e');
      debugPrint('$stackTrace');
    }
    return Agences;
  }

  Future<List<Agencymodel>> AgencyImportant(context) async {
    Agences.clear();
    try {
      final Response response = await dio.get('/api/GetImportantAgancy');
      if (response.statusCode == 200) {
        final List list = response.data['Agency'] as List;
        Agences.addAll(list.map((e) => Agencymodel.fromJson(e)));
      }
    } on DioException catch (e) {
      debugPrint('AgencyImportant failed: ${e.message}');
    } catch (e, stackTrace) {
      debugPrint('AgencyImportant parsing/unexpected error: $e');
      debugPrint('$stackTrace');
    }
    return Agences;
  }

  Future<List<usermodel>> JoinAgency({context, id}) async {
    Indexxx2 = 2;
    useragincys.clear();
    try {
      final Response response = await dio.get('/api/GetJoinAgency/$id/$UserId');
      if (response.statusCode == 200) {
        final data = response.data['Agency'];
        final List list = data['Members']['data'] as List;
        Provider.of<LoginViewmodel>(context, listen: false)
            .updateMenuit(data['menuit']);
        useragincys.addAll(list.map((e) => usermodel.fromJson(e)));
      }
    } on DioException catch (e) {
      debugPrint('JoinAgency failed: ${e.message}');
    } catch (e, stackTrace) {
      debugPrint('JoinAgency parsing/unexpected error: $e');
      debugPrint('$stackTrace');
    }
    return useragincys;
  }

  Future<List<Agencymodel>> AddmoreAgency(context) async {
    try {
      final Response response =
      await dio.get('/api/GetAgency?page=${Indexxx.toString()}');
      if (response.statusCode == 200) {
        final List list = response.data['Agency']['data'] as List;
        if (list.isNotEmpty) {
          Indexxx++;
        }
        debugPrint('Agency pagination index: $Indexxx');
        Agences.addAll(list.map((e) => Agencymodel.fromJson(e)));
        debugPrint('Total agencies loaded: ${Agences.length}');
      }
    } on DioException catch (e) {
      debugPrint('AddmoreAgency failed: ${e.message}');
    } catch (e, stackTrace) {
      debugPrint('AddmoreAgency parsing/unexpected error: $e');
      debugPrint('$stackTrace');
    }
    return Agences;
  }

  Future<List<usermodel>> AddmoreAgencyMembers(context, id) async {
    try {
      final Response response = await dio.get(
        '/api/GetJoinAgency/${id.toString()}?page=${Indexxx2.toString()}',
      );
      if (response.statusCode == 200) {
        final List list = response.data['Agency']['data'] as List;
        debugPrint('Agency members page data: $list');
        if (list.isNotEmpty) {
          Indexxx2++;
        }
        debugPrint('Agency members pagination index: $Indexxx2');
        useragincys.addAll(list.map((e) => usermodel.fromJson(e)));
        debugPrint('Total agency members loaded: ${useragincys.length}');
      }
    } on DioException catch (e) {
      debugPrint('AddmoreAgencyMembers failed: ${e.message}');
    } catch (e, stackTrace) {
      debugPrint('AddmoreAgencyMembers parsing/unexpected error: $e');
      debugPrint('$stackTrace');
    }
    return useragincys;
  }

  Future<List<Agencymodel>> SearchAgency({tittle}) async {
    Searchagency.clear();
    try {
      final Response response = await dio.get('/api/SearchAgency/$tittle');
      if (response.statusCode == 200) {
        final List list = response.data['Agency'] as List;
        Searchagency.addAll(list.map((e) => Agencymodel.fromJson(e)));
      }
    } on DioException catch (e) {
      debugPrint('SearchAgency failed: ${e.message}');
    } catch (e, stackTrace) {
      debugPrint('SearchAgency parsing/unexpected error: $e');
      debugPrint('$stackTrace');
    }
    return Searchagency;
  }

  AgencyLeaderBoard Leader = AgencyLeaderBoard();

  Future<AgencyLeaderBoard> GetAgencyLeaderBoard(context, tittle) async {
    try {
      final Response response = await dio.get('/api/AgencysLeaderBoard');
      if (response.statusCode == 200) {
        Leader = AgencyLeaderBoard.fromJson(response.data['Leaderboard']);
      }
    } on DioException catch (e) {
      debugPrint('GetAgencyLeaderBoard failed: ${e.message}');
    } catch (e, stackTrace) {
      debugPrint('GetAgencyLeaderBoard parsing/unexpected error: $e');
      debugPrint('$stackTrace');
    }
    return Leader;
  }

  Future<bool> LeaveAgency({context, Agancyid}) async {
    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'agancy_id': Agancyid.toString(),
      });

      final Response response = await dio.post(
        'api/LeaveAgency',
        data: formData,
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint('LeaveAgency failed: ${e.message}');
      return false;
    } catch (e, stackTrace) {
      debugPrint('LeaveAgency unexpected error: $e');
      debugPrint('$stackTrace');
      return false;
    }
  }

  Future<bool> RequsetJoinAgency({context, Agancyid}) async {
    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'agancy_id': Agancyid.toString(),
      });

      final Response response = await dio.post(
        'api/RequestJoinAgency',
        data: formData,
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint('RequsetJoinAgency failed: ${e.message}');
      return false;
    } catch (e, stackTrace) {
      debugPrint('RequsetJoinAgency unexpected error: $e');
      debugPrint('$stackTrace');
      return false;
    }
  }
  Future<bool> sellTarget({context, Agancyid, amount}) async {
    try {
      final FormData formData = FormData.fromMap({
        'AgencyId': Agancyid.toString(),
        'amount': amount.toString(),
      });

      final Response response = await dio.post(
        'api/sell-target',
        data: formData,
      );

      debugPrint('===== SELL TARGET SUCCESS =====');
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('RESPONSE: ${_safeToString(response.data)}');
      debugPrint('===============================');

      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      debugPrint('===== SELL TARGET FAILED =====');
      debugPrint('STATUS: ${e.response?.statusCode}');
      debugPrint('ERROR: ${e.message}');
      debugPrint('RESPONSE: ${_safeToString(e.response?.data)}');
      debugPrint('==============================');
      return false;
    } catch (e, stackTrace) {
      debugPrint('===== SELL TARGET UNEXPECTED ERROR =====');
      debugPrint('ERROR: $e');
      debugPrint('$stackTrace');
      debugPrint('========================================');
      return false;
    }
  }
}
