import 'dart:io';

import 'package:ahlachat/Repositores/Moment_repositores/Moment_repository.dart';
import 'package:ahlachat/models/FamilyModel.dart';
import 'package:ahlachat/models/FamilyRequest.dart';
import 'package:ahlachat/models/FamilyRequestModel.dart';
import 'package:ahlachat/models/Leaderboardusermodel.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Family_ViewModel/Family_ViewModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Familyapi extends MomentRepository {

  @override
  var dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.BASE_URL,
      headers: {
        'Accept': 'application/json',
        'Connection': 'Keep-Alive',
        'Authorization':Token,
        'awqeASERQW':'8/325*mAIOEN',
        'userid':UserId.toString(),
        'UserIP':UserIP,
      },
    ),
  );
  List<FamilyModel> AllFamily=[];
  FamilyModel  FamilyProfile=FamilyModel();

  List<FamilyRequest>RequestesFamily=[];
  List<usermodel> FamilyMembers=[];
  final ImagePicker _picker= ImagePicker();

  // ───────────────────────── Logging helpers ─────────────────────────

  /// طباعة الـ Request + Status + Response
  void _logResponse(String tag, Response res) {
    final reqData = res.requestOptions.data;
    debugPrint('┌────────── [$tag] RESPONSE ──────────');
    debugPrint('│ URL    : ${res.requestOptions.uri}');
    debugPrint('│ Method : ${res.requestOptions.method}');
    if (reqData is FormData) {
      debugPrint('│ Request fields: ${reqData.fields}');
      debugPrint('│ Request files : ${reqData.files.map((f) => f.key).toList()}');
    } else if (reqData != null) {
      debugPrint('│ Request data  : $reqData');
    }
    debugPrint('│ Status : ${res.statusCode} ${res.statusMessage ?? ''}');
    debugPrint('│ Data   : ${res.data}');
    debugPrint('└──────────────────────────────────────');
  }

  /// طباعة الخطأ + Status + Response القادم من السيرفر (إن وجد)
  void _logError(String tag, Object e, [StackTrace? stackTrace]) {
    debugPrint('┌────────── [$tag] ERROR ──────────');
    if (e is DioException) {
      debugPrint('│ Type    : ${e.type}');
      debugPrint('│ URL     : ${e.requestOptions.uri}');
      debugPrint('│ Method  : ${e.requestOptions.method}');
      final reqData = e.requestOptions.data;
      if (reqData is FormData) {
        debugPrint('│ Request fields: ${reqData.fields}');
      } else if (reqData != null) {
        debugPrint('│ Request data  : $reqData');
      }
      debugPrint('│ Status  : ${e.response?.statusCode} ${e.response?.statusMessage ?? ''}');
      debugPrint('│ Response: ${e.response?.data}');
      debugPrint('│ Message : ${e.message}');
    } else {
      debugPrint('│ Error   : $e');
    }
    if (stackTrace != null) {
      debugPrint('│ StackTrace: $stackTrace');
    }
    debugPrint('└──────────────────────────────────────');
  }

  // ───────────────────────── API functions ─────────────────────────

  Future<List<FamilyModel>>  SearchFamily( tittle)async {

    try {
      Response response2 = await dio.get(
        '/api/SearchFAmily/$tittle',
      );
      _logResponse('SearchFamily', response2);

      if (response2.statusCode == 200) {
        List list =response2.data['Family'];
        list.forEach((element) {
          AllFamily.add(FamilyModel.fromJson(element));
        });

      }
    } catch (e, s) {
      _logError('SearchFamily', e, s);
    }

    return AllFamily;

  }

  Future<bool> EditFamilyImag({ context,id,image}) async {

    bool read=false;
    try {
      FormData formData = new FormData.fromMap({
        "id": id.toString(),
        "image":await MultipartFile.fromFile(image?.path, filename: image?.path?.split('/')?.last),


      });
      Response response2 = await dio.post(
        'api/EditFamilyImage',
        data: formData,
      );
      _logResponse('EditFamilyImag', response2);

      if (response2.statusCode == 200) {
        Provider.of<FamilyViewModel>(context,listen: false). UpdateFamilyimage(image:response2.data['Families'] );

        read=true;
      }else{
        read=false;
      }
    } catch (e, s) {
      read=false;
      _logError('EditFamilyImag', e, s);
    }

    return read;
  }
  Future getImageGalary() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile!= null) {
      var  Signupimage = File(pickedFile.path);
      print(Signupimage);
      return Signupimage;
    } else {
      print('No image selected.');
    }
  }
  Future<ListoflEaderboardcategory?>GetMembersLeaderboard( id)async {
    ListoflEaderboardcategory ? Leaderboardsupported;
    try {
      Response response2 = await dio.get(
        '/api/GetFamilyStar/$id',
      );
      _logResponse('GetMembersLeaderboard', response2);

      if (response2.statusCode == 200) {

        Leaderboardsupported=ListoflEaderboardcategory.fromJson(response2.data['Leaderboard']['supporter']);

      }
    } catch (e, s) {
      _logError('GetMembersLeaderboard', e, s);
    }

    return Leaderboardsupported ;

  }
  Future<FamilyModel>  GetFamilyProfile({id})async {


    try {
      Response response2 = await dio.get(
        '/api/GetFamilyProfile/$id',
      );
      _logResponse('GetFamilyProfile', response2);

      if (response2.statusCode == 200) {

        FamilyProfile=FamilyModel.fromJson(response2.data['Family'] );

      }
    } catch (e, s) {
      _logError('GetFamilyProfile', e, s);
    }

    return FamilyProfile;

  }




  Future<List<FamilyRequest>>  GetFamilyRequest( id)async {


    try {
      Response response2 = await dio.get(
        '/api/GetRequestFamily/$id',
      );
      _logResponse('GetFamilyRequest', response2);

      if (response2.statusCode == 200) {
        List list =response2.data['Families'] ;

        list.forEach((element) {
          RequestesFamily.add(FamilyRequest.fromJson(element));
        });

      }
    } catch (e, s) {
      _logError('GetFamilyRequest', e, s);

    }

    return RequestesFamily;

  }
  Future<List<usermodel>>  GetFamilyMembers( id)async {


    try {
      Response response2 = await dio.get(
        '/api/GetFamilyMembers/$id',
      );
      _logResponse('GetFamilyMembers', response2);

      if (response2.statusCode == 200) {
        List list =response2.data['users'] ;

        list.forEach((element) {
          FamilyMembers.add(usermodel.fromJson(element));
        });

      }
    } catch (e, s) {
      _logError('GetFamilyMembers', e, s);

    }

    return FamilyMembers;

  }


  Future<bool>  EditFamilyNames( id,name)async {


    var send=false;
    try {
      Response response2 = await dio.get(
        '/api/EditFamilyyName/$id/$name',
      );
      _logResponse('EditFamilyNames', response2);

      if (response2.statusCode == 200) {
        send=true;
      }
    } catch (e, s) {
      _logError('EditFamilyNames', e, s);
      send=false;
    }

    return send;

  }
  Future<bool>  ExchangeFamily( id)async {


    var send=false;
    try {
      Response response2 = await dio.get(
        '/api/ExchangeFamilyCoins/$id',
      );
      _logResponse('ExchangeFamily', response2);

      if (response2.statusCode == 200) {
        send=true;
      }
    } catch (e, s) {
      _logError('ExchangeFamily', e, s);
      send=false;
    }

    return send;

  }
  Future<bool> SentjoinRequesr({ context,  familyid}) async {

    var send=true;
    try {
      FormData formData =   FormData.fromMap({
        "user_id":UserId,
        "Family_id": familyid.toString(),

      });

      Response response2 = await dio.post(
        'api/joinFamily',
        data: formData,
      );
      _logResponse('SentjoinRequesr', response2);

      if (response2.statusCode == 200) {
        LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);

        FamilyRequestModel Requtest  = FamilyRequestModel.fromJson(response2.data['Families'])  ;
        user.AddFamilyRequest(Requtest.familyId??0);
        print(Requtest.id);
        send=true;
      }else{

        send=false;
      }
    } catch (e, s) {
      _logError('SentjoinRequesr', e, s);

    }

    return send;
  }
  Future<FamilyModel> CreateFamily({ context,name,describtion,image}) async {

    FamilyModel Requtest=FamilyModel();
    try {
      FormData formData =   FormData.fromMap({
        "user_id":UserId,
        "image":await MultipartFile.fromFile(image?.path, filename: image?.path?.split('/')?.last),

        "describtion": describtion.toString(),
        "name": name.toString(),
      });

      Response response2 = await dio.post(
        'api/CreateFamily',
        data: formData,
      );
      _logResponse('CreateFamily', response2);

      if (response2.statusCode == 200) {

        Requtest  = FamilyModel.fromJson(response2.data['Families'])  ;

      }
    } catch (e, s) {
      _logError('CreateFamily', e, s);

    }

    return Requtest;
  }


  Future<bool> LeaveMyFamily({ context,  familyid}) async {

    var send=true;
    try {
      FormData formData =   FormData.fromMap({
        "user_id":UserId,
        "Family_id": familyid.toString(),

      });

      Response response2 = await dio.post(
        'api/LeaveFamily',
        data: formData,
      );
      _logResponse('LeaveMyFamily', response2);

      if (response2.statusCode == 200) {
        LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);

        user.LeaveFamily(familyid);

        send=true;

      }else{

        send=false;
      }
    } catch (e, s) {
      _logError('LeaveMyFamily', e, s);

    }

    return send;
  }
  Future<bool> RemoveFamilyMember({ userid,  familyid}) async {

    var send=true;
    try {
      FormData formData =   FormData.fromMap({
        "user_id":userid,
        "Family_id": familyid.toString(),

      });

      Response response2 = await dio.post(
        'api/LeaveFamily',
        data: formData,
      );
      _logResponse('RemoveFamilyMember', response2);

      if (response2.statusCode == 200) {

        send=true;
      }else{

        send=false;
      }
    } catch (e, s) {
      _logError('RemoveFamilyMember', e, s);

    }

    return send;
  }
  Future<bool> AcceptFamilyRequest({   joinid}) async {

    var send=true;
    try {
      FormData formData =   FormData.fromMap({

        "join_id": joinid.toString(),

      });

      Response response2 = await dio.post(
        'api/Acceptjoin',
        data: formData,
      );
      _logResponse('AcceptFamilyRequest', response2);

      if (response2.statusCode == 200) {

        send=true;

      }else{

        send=false;
      }
    } catch (e, s) {
      _logError('AcceptFamilyRequest', e, s);

    }

    return send;
  }



  Future<bool> RemoveAdmin({ context,  familyid,id}) async {

    var send=true;
    try {
      FormData formData =   FormData.fromMap({
        "user_id":id.toString(),
        "Family_id": familyid.toString(),

      });

      Response response2 = await dio.post(
        'api/RemoveAdmin',
        data: formData,
      );
      _logResponse('RemoveAdmin', response2);

      if (response2.statusCode == 200) {

        send=true;

      }else{

        send=false;
      }
    } catch (e, s) {
      _logError('RemoveAdmin', e, s);

    }

    return send;
  }

  Future<bool> AddAdmin({ context,  familyid,id}) async {

    var send=true;
    try {
      FormData formData =   FormData.fromMap({
        "user_id":id.toString(),
        "Family_id": familyid.toString(),

      });

      Response response2 = await dio.post(
        'api/AddAdmins',
        data: formData,
      );
      _logResponse('AddAdmin', response2);

      if (response2.statusCode == 200) {
        LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);

        send=true;

      }else{

        send=false;
      }
    } catch (e, s) {
      _logError('AddAdmin', e, s);

    }

    return send;
  }
  Future<bool> CanclejoinRequesr({    Familyid}) async {

    var send=true;
    try {
      FormData formData =   FormData.fromMap({
        "user_id":UserId,
        "family_id":Familyid,

      });

      Response response2 = await dio.post(
        'api/Canclejoin',
        data: formData,
      );
      _logResponse('CanclejoinRequesr', response2);

      if (response2.statusCode == 200) {

        send=true;
      }else{

        send=false;
      }
    } catch (e, s) {
      _logError('CanclejoinRequesr', e, s);

    }

    return send;
  }
  Future<bool> CancleMemberjoinRequesr({    Familyid,userid}) async {

    var send=true;
    try {
      FormData formData =   FormData.fromMap({
        "user_id":userid,
        "family_id":Familyid,

      });

      Response response2 = await dio.post(
        'api/Canclejoin',
        data: formData,
      );
      _logResponse('CancleMemberjoinRequesr', response2);

      if (response2.statusCode == 200) {

        send=true;
      }else{

        send=false;
      }
    } catch (e, s) {
      _logError('CancleMemberjoinRequesr', e, s);

    }

    return send;
  }

}