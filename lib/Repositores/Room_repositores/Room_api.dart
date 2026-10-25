
import 'package:ahlachat/Repositores/Room_repositores/Room_repository.dart';
import 'package:ahlachat/models/FlagModel.dart';
import 'package:ahlachat/models/KarismaCollectModel.dart';
import 'package:ahlachat/models/Leaderboardroommodel.dart';
import 'package:ahlachat/models/Weeklystarmodel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:dio/dio.dart';

 import 'package:provider/provider.dart';

import '../../models/ChairModel.dart';
import '../../models/JoinRoomModel.dart';
import '../../models/Kickedusers.dart';
import '../../models/Leaderboardusermodel.dart';
import '../../models/RoomKarismaModel.dart';
import '../../models/RoomModel.dart';
import '../../models/SupervisorsModel.dart';
import '../../models/gifts.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';
import '../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../viewmodels/Room_Viewmodel/Room_Viewmodel.dart';

int Index=2;
int IndexTrade=2;
int IndexRecommended=2;
int IndexRecommended2=2;

class UploadResult {
  final bool success;
  final int? statusCode;
  final String? url;
  final String? message;
  UploadResult({required this.success, this.statusCode, this.url, this.message});
}

class Roomapi extends RoomRepository {
  @override
  var dio = Dio(BaseOptions(
      baseUrl: AppConstants.BASE_URL,
      headers: {
        'Accept': 'application/json',
        'Connection': 'Keep-Alive',
        'Authorization':Token,
        'awqeASERQW':'8/325*mAIOEN',
        'userid':UserId.toString(),
        'UserIP':UserIP,
      },
    ));
  List<RoomModel> ImportantRooms=[];
  List<FlagModel> Countries=[];
  List<RoomModel> FixedRooms=[];
  List<RoomModel> TradeRooms=[];
  List<KickedUser> KickeduserRooms=[];
  List<joinRoom> joinuserRooms=[];
  RoomModel Roominfo=RoomModel();
  Future<bool> Updatemute({
    required dynamic room_id,
    required dynamic user_id,
    required context,

    required dynamic state,
  }) async {
    bool mute = false;

    try {
      final formData = FormData.fromMap({
        "user_id": user_id.toString(),
        "state": int.parse(state.toString()),
        "room_id": room_id.toString(),
      });

      print('========== UPDATE MUTE ==========');
      print('URL: ${dio.options.baseUrl}api/updatemutechair');
      print('METHOD: POST');
      print('user_id: ${user_id.toString()}');
      print('state: ${int.parse(state.toString())}');
      print('room_id: ${room_id.toString()}');
      print('=================================');

      final Response response = await dio.post(
        'api/updatemutechair',
        data: formData,
      );

      print('========== UPDATE MUTE RESPONSE ==========');
      print('STATUS: ${response.statusCode}');
      print('DATA: ${response.data}');
      print('==========================================');

      if (response.statusCode == 200) {
        mute = true;
      } else {
        mute = false;
      }
    } on DioException catch (e) {
      print('========== UPDATE MUTE ERROR ==========');
      print('URL: ${e.requestOptions.uri}');
      print('METHOD: ${e.requestOptions.method}');
      print('REQUEST DATA: ${e.requestOptions.data}');
      print('STATUS: ${e.response?.statusCode}');
      print('RESPONSE DATA: ${e.response?.data}');
      print('MESSAGE: ${e.message}');
      print('=======================================');
    } catch (e, stackTrace) {
      print('========== UPDATE MUTE UNKNOWN ERROR ==========');
      print('ERROR: $e');
      print('STACK: $stackTrace');
      print('===============================================');
    }

    return mute;
  }
  Future<RoomModel> UpdateRoom({name,roomid, image,backimage ,Category,lock,password,RoomAds})async{
    try {
      print({
        "name":name.toString(),
        "password": password,
        "Category": Category,
        "animateimage":backimage,
        "room_id":roomid.toString(),
        "RoomAds":RoomAds.toString()
      });
      var  map;
      if(image==null){
          map={
          "name":name.toString(),
           "password": password,
          "Category": Category,
          "animateimage":backimage,
          "room_id":roomid.toString(),
            "RoomAds":RoomAds.toString()
        };
      }else{
          map={
          "name":name.toString(),
          "image":await MultipartFile.fromFile(image?.path, filename: image?.path?.split('/')?.last),
          "password": password,
          "Category": Category,
          "animateimage":backimage,
          "room_id":roomid.toString(),
            "RoomAds":RoomAds.toString()
        };
      }

      map.removeWhere((key, value) => key == null || value == null);
      FormData formData = FormData.fromMap(map);
      Response response2 = await dio.post(
        'api/UpdateRoom',
        data: formData,
      );

      if (response2.statusCode == 200) {
        Roominfo = RoomModel.fromJson(response2.data['Room']);
      }
    } catch (e) {
      print(e);

    }

    return Roominfo;
  }
  Future<bool> UnkickeuserRoom({kickid,context})async{
    bool states=false;
    try {
      var  map={
        "kick_id": kickid.toString(),
      };
      map.removeWhere((key, value) => key == null || value == null);
      FormData formData = FormData.fromMap(map);
      Response response2 = await dio.post(
        'api/unkickuser',
        data: formData,
      );

      if (response2.statusCode == 200||response2.statusCode == 201) {
        states=true;
      }else{
        states=false;
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return states;
  }

  Future<bool> UpdateThroneChair({room_id,State,context})async{
    bool states=false;
    try {
      var  map={
        "room_id": room_id.toString(),
        "status": State.toString(),
      };
      map.removeWhere((key, value) => key == null || value == null);
      FormData formData = FormData.fromMap(map);
      Response response2 = await dio.post(
        'api/SetThroneChair',
        data: formData,
      );

      if (response2.statusCode == 200||response2.statusCode == 201) {
        states=true;
      }else{
        states=false;
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return states;
  }


  Future<bool> SendInviteChairRoom({roomid,userid,context})async{
    bool states=false;
    try {
      var  map={
        "user_id": userid.toString(),
        "room_id":roomid.toString(),
        "chair_id":InviteChairId.toString(),
      };
      map.removeWhere((key, value) => key == null || value == null);
      FormData formData = FormData.fromMap(map);
      Response response2 = await dio.post(
        'api/SentInviteChair',
        data: formData,
      );

      if (response2.statusCode == 200||response2.statusCode == 201) {
        states=true;
      }else{
        states=false;
      }
    } catch (e) {

    }

    return states;
  }


  Future<bool> deleteChatRoom({RoomID,context})async{
    bool states=false;
    try {
      var  map={
        "room_id": RoomID.toString(),
      };
      map.removeWhere((key, value) => key == null || value == null);
      FormData formData = FormData.fromMap(map);
      Response response2 = await dio.post(
        'api/DeleteRoomChat',
        data: formData,
      );

      if (response2.statusCode == 200||response2.statusCode == 201) {
        states=true;
      }else{
        states=false;
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return states;
  }
  Future<bool> SetRoomPssword({roomid,password,context})async{
   bool states=false;
    try {
      var  map={
          "password": password.toString(),
          "room_id":roomid.toString()
        };
      map.removeWhere((key, value) => key == null || value == null);
      FormData formData = FormData.fromMap(map);
      Response response2 = await dio.post(
        'api/SetPasswordRoom',
        data: formData,
      );

      if (response2.statusCode == 200||response2.statusCode == 201) {
        states=true;
      }else{
        states=false;
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return states;
  }
  Future<bool> RemoveRoomPssword({roomid,context})async{
    bool states=false;

    try {


      var   map={
        "room_id":roomid.toString()
      };


      map.removeWhere((key, value) => key == null || value == null);
      FormData formData = FormData.fromMap(map);
      Response response2 = await dio.post(
        'api/RemovePasswordRoom',
        data: formData,
      );
       
      if(response2.statusCode == 200||response2.statusCode == 201) {
        states=true;
      }
      else
      {
        states=false;
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return states;
  }
  Future<List<joinRoom>>  Roomsjoinuser({context, room_id})async {
    try {
      FormData formData = FormData.fromMap({
        "room_id":room_id.toString()
      });
      Response response2 = await dio.post(
        'api/Getjoinusers',
        data: formData,
      );
      print(response2.data['join']);
      if (response2.statusCode == 200) {
        List list =response2.data['join'];
        list.forEach((element){
          joinuserRooms.add(joinRoom.fromJson(element));
        });
        print(joinuserRooms);
      }
    } catch (e) {
      if (e is DioError) {
         
        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }
    return joinuserRooms;

  }
  Future<Roomkarismamodel?>  RoomsKarisma({context, room_id})async {
    Roomkarismamodel ?RoomKarismas ;
    try {

      Response response2 = await dio.get(
        'api/GetRoomKarismas/$room_id',

      );

      if (response2.statusCode == 200) {

        RoomKarismas=Roomkarismamodel.fromJson(response2.data['RoomKarisma']);
        print(RoomKarismas.monthlysupporter?.length);
        print(RoomKarismas.dailysupporter?.length);
        print(RoomKarismas.weeklysupporter?.length);
      }
    } catch (e) {
      if (e is DioError) {

        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }
    return   RoomKarismas ;

  }
  List<KarismaCollectModel> karismas=[];
  Future<List<KarismaCollectModel>>  GetCollectKarisma({context, room_id,user_id,chairid})async {

    try {

      Response response2 = await dio.get(
        'api/GetUserKarismaDetales2/$user_id/$room_id/$chairid',

      );

      if (response2.statusCode == 200) {
        List list =response2.data;
        list.forEach((element) {
          karismas.add(KarismaCollectModel.fromJson(element));
        });

      }
    } catch (e) {

    }
    return   karismas ;

  }

  Future<bool> Evictionuser({context,Roomid,Userid})async{
    bool JoinRoom=false;
    try {
      FormData formData = FormData.fromMap({
        "room_id": Roomid.toString(),
        "user_id": Userid.toString(),
      });
      Response response2 = await dio.post(
        'api/Evictionuser',
        data: formData,
      );
       
      if (response2.statusCode == 200) {
        JoinRoom=true;
      }else{
        JoinRoom=false;
      }
    } catch (e) {

    }

    return JoinRoom;
  }
  Future<bool> DisbandRoom({context,Roomid })async{
    bool JoinRoom=false;
    try {
      FormData formData = FormData.fromMap({
        "room_id": Roomid.toString(),
      });
      Response response2 = await dio.post(
        'api/DisbandRoom',
        data: formData,
      );
       
      if (response2.statusCode == 200) {
        JoinRoom=true;
      }else{
        JoinRoom=false;
      }
    } catch (e) {
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return JoinRoom;
  }
  Future<List<RoomModel>> Rooms(context) async {
    Index = 2;

    try {
      final response = await dio.get(
        'https://egyptiantechs.com/api/GetRooms/$SelectedRoomCategory',
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map && data['Rooms'] is Map) {
          final List list = data['Rooms']['data'] ?? [];

          // مسح القائمة القديمة قبل إعادة التحميل
          ImportantRooms.clear();

          for (final element in list) {
            final room = RoomModel.fromJson(
              Map<String, dynamic>.from(element),
            );

            print(
              '🏠 ROOM ID: ${room.id} | '
                  'NAME: ${room.name} | '
                  'STATE: ${room.state} | '
                  'LOCKED: ${room.locked}',
            );

            ImportantRooms.add(room);
          }

          print(
            '✅ ImportantRooms count: ${ImportantRooms.length}',
          );
        }
      }
    } on DioException catch (e) {
      print('❌ GetRooms URL: ${e.requestOptions.uri}');
      print('❌ GetRooms STATUS: ${e.response?.statusCode}');
      print('❌ GetRooms RESPONSE: ${e.response?.data}');
    } catch (e, stackTrace) {
      print('❌ GetRooms error: $e');
      print(stackTrace);
    }

    return ImportantRooms;
  }
  Future<List<RoomModel>>  getFixedRooms(context)async {

    try {
      Response response2 = await dio.get(
        AppConstants.BASE_URL+'api/GetFixedRoom',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Rooms'];
        list.forEach((element) {
          ImportantRooms.add(RoomModel.fromJson(element));
        });

      }
    } catch (e) {
      print(e);
    }

    return ImportantRooms;

  }
  Future<List<RoomModel>>  SearchRooms(context,tittle)async {

    try {
      Response response2 = await dio.get(
        '/api/SearchRoom/$tittle',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Rooms'];
        list.forEach((element) {
          ImportantRooms.add(RoomModel.fromJson(element));
        });
        print(ImportantRooms);
      }
    } catch (e) {
      if (e is DioError) {
         
        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }

    return ImportantRooms;

  }
  Future<List<RoomModel>>  GetFollowedRooms(context )async {
    print(UserId);
List<RoomModel> FollowedRoom=[];
    try {
      Response response2 = await dio.get(
        '/api/GetFollowRoom/$UserId',
      );
print(response2.data);
      if (response2.statusCode == 200) {
        List list =response2.data['FollowRoom'];
        list.forEach((element) {
          FollowedRoom.add(RoomModel.fromJson(element['room']));
        });
        print(FollowedRoom);
      }
    } catch (e) {
      if (e is DioError) {

        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }

    return FollowedRoom;

  }
  Future<List<RoomModel>>  AddmoreRooms(context)async {

    try {
      Response response2 = await dio.get(
        '/api/GetRooms/${SelectedRoomCategory}?page=${Index.toString()}',
      );

      if (response2.statusCode == 200) {

        List list =response2.data['Rooms']['data'];
        if(list.isNotEmpty){
          Index++;
        }
        print("INDEX IS $Index");
        list.forEach((element){
          ImportantRooms.add(RoomModel.fromJson(element));
        });
        print(ImportantRooms);
      }
    } catch (e) {
      if (e is DioError) {
       
        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {
          
        }
      } else {
        print(e);
      }
    }

    return ImportantRooms;

  }


  Future<List<RoomModel>>  AddmoreRecommended(context)async {

    try {
      Response response2 = await dio.get(
        '/api/GetRecomended?page=${IndexRecommended.toString()}',
      );

      if (response2.statusCode == 200) {

        List list =response2.data['Rooms']['data'];
        if(list.isNotEmpty){
          IndexRecommended++;
        }
        print("INDEX IS $IndexRecommended");
        list.forEach((element){
          ImportantRooms.add(RoomModel.fromJson(element));
        });
        print(ImportantRooms);
      }
    } catch (e) {
      if (e is DioError) {

        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }

    return ImportantRooms;

  }

  Future<List<RoomModel>>  AddExploreRecommended(context)async {

    try {
      Response response2 = await dio.get(
        '/api/GetRecomended2?page=${IndexRecommended2.toString()}',
      );

      if (response2.statusCode == 200) {

        List list =response2.data['Rooms']['data'];
        if(list.isNotEmpty){
          IndexRecommended2++;
        }
        print("INDEX IS $IndexRecommended");
        list.forEach((element){
          ImportantRooms.add(RoomModel.fromJson(element));
        });
        print(ImportantRooms);
      }
    } catch (e) {
      if (e is DioError) {

        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }

    return ImportantRooms;

  }
  Future<List<RoomModel>>  FoolowingUserRooms(context)async {

    try {
      Response response2 = await dio.get(
        '/api/GetRoomUserFollowing/$UserId',
      );

      if (response2.statusCode == 200) {

        List list =response2.data['Rooms'];

        list.forEach((element){
          ImportantRooms.add(RoomModel.fromJson(element));
        });
        print(ImportantRooms);
      }
    } catch (e) {

    }

    return ImportantRooms;

  }
  Future<List<RoomModel>>  RecommendedRooms(context)async {
    IndexRecommended=2;
    try {
      Response response2 = await dio.get(
        '/api/GetRecomended',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Rooms']['data'];

        list.forEach((element){
          ImportantRooms.add(RoomModel.fromJson(element));
        });
        print(ImportantRooms);
      }
    } catch (e) {
      if (e is DioError) {

        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }

    return ImportantRooms;

  }
  Future<List<RoomModel>>  ExploreRooms(context)async {
    IndexRecommended2=2;
    try {
      Response response2 = await dio.get(
        '/api/GetRecomended2',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Rooms']['data'];

        list.forEach((element){
          ImportantRooms.add(RoomModel.fromJson(element));
        });
        print(ImportantRooms);
      }
    } catch (e) {
      if (e is DioError) {

        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }

    return ImportantRooms;

  }
  Future<List<RoomModel>>  CountryRooms({  Country})async {
    IndexRecommended2=2;
    try {
      Response response2 = await dio.get(
        '/api/GetCountryRooms/$Country',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Rooms']['data'];

        list.forEach((element){
          ImportantRooms.add(RoomModel.fromJson(element));
        });
        print(ImportantRooms);
      }
    } catch (e) {

    }

    return ImportantRooms;

  }
  Future<List<FlagModel>>  GetCountries(context)async {

    try {
      Response response2 = await dio.get(
        '/api/GetCountries',
      );

      if (response2.statusCode == 200) {
        List list =response2.data;

        list.forEach((element){
          Countries.add(FlagModel.fromJson(element));
        });
        print(Countries);
      }
    } catch (e) {
      if (e is DioError) {

        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }

    return Countries;

  }
  Future<bool>  CheckPassworRooms({id})async {
    bool PasswordRoom=false;
    try {
      Response response2 = await dio.get(
        '/api/CheckPasswordRoomnew/$id',
      );

      if (response2.statusCode == 200) {
        PasswordRoom=true;

      }else{
        PasswordRoom=false;
      }
    } catch (e) {

    }

    return PasswordRoom ;

  }

  Future<bool>  EnterCheckPassworRooms({id,pass})async {
    bool PasswordRoom=false;
    try {
      Response response2 = await dio.get(
        '/api/CheckPasswordright/$id/$pass',
      );

      if (response2.statusCode == 200) {
        PasswordRoom=true;

      }else{
        PasswordRoom=false;
      }
    } catch (e) {

    }

    return PasswordRoom ;

  }

  //--------------------------------
  Future<List<RoomModel>>NewRooms(context)async {
    try {
      Response response2 = await dio.get(
        '/api/GetNewRooms',
      );
      if (response2.statusCode == 200) {
        List list =response2.data['Rooms']['data'];
         list.forEach((element) {
          TradeRooms.add(RoomModel.fromJson(element));
        });

      }
    } catch (e) {
      
    }

    return TradeRooms;

  }

  Future<ListoflEaderboardcategoryRoom?>getRoomLeaderboard(context)async {
    ListoflEaderboardcategory ? Leaderboardsupporter;
    ListoflEaderboardcategory ? Leaderboardsupported;
    ListoflEaderboardcategoryRoom ?LeaderboardRoom;
    try {
      Response response2 = await dio.get(
        '/api/GetRoomLeaderboard',
      );

      if (response2.statusCode == 200) {

        // Leaderboardsupporter=ListoflEaderboardcategory.fromJson(response2.data['Leaderboard']['supporter']);
        //
        // Leaderboardsupported=ListoflEaderboardcategory.fromJson(response2.data['Leaderboard']['Recipient']);
        LeaderboardRoom=ListoflEaderboardcategoryRoom.fromJson(response2.data['Leaderboard']['Room']);


  }
    } catch (e) {

    }

    return LeaderboardRoom ;

  }
  Future<ListoflEaderboardcategory?>getGiverLeaderboard(context)async {
    ListoflEaderboardcategory ? Leaderboardsupporter;

    try {
      Response response2 = await dio.get(
        '/api/GetGiverLeaderboard',
      );

      if (response2.statusCode == 200) {

        Leaderboardsupporter=ListoflEaderboardcategory.fromJson(response2.data['Leaderboard']['supporter']);





      }
    } catch (e) {

    }

    return Leaderboardsupporter ;

  }

  Future<WeeklyStarModel?>GetWeeklystar(context)async {
    WeeklyStarModel ? Leaderboardsupporter;

    try {
      Response response2 = await dio.get(
        '/api/GetsupporterWeeklyStar',
      );
print(response2.data['supporteds']);
      if (response2.statusCode == 200) {

        Leaderboardsupporter=WeeklyStarModel.fromJson(response2.data);





      }
    } catch (e) {

    }

    return Leaderboardsupporter ;

  }

  Future<ListoflEaderboardFamilycategory?>getFamilyLeaderboard(context)async {
    ListoflEaderboardFamilycategory ? Leaderboardsupporter;

    try {
      Response response2 = await dio.get(
        '/api/GetFamilyLeaderboard',
      );
 
      if (response2.statusCode == 200) {

        Leaderboardsupporter=ListoflEaderboardFamilycategory.fromJson(response2.data['Leaderboard']['Family']);
print(Leaderboardsupporter.weeklysupporter?.length);



      }
    } catch (e) {
print(e);
    }

    return Leaderboardsupporter ;

  }

  Future<ListoflEaderboardcategory?>getReciverLeaderboard(context)async {
    ListoflEaderboardcategory ? Leaderboardsupported;
    try {
      Response response2 = await dio.get(
        '/api/GetReciverLeaderboard',
      );
      if (response2.statusCode == 200) {


        Leaderboardsupported=ListoflEaderboardcategory.fromJson(response2.data['Leaderboard']['Recipient']);



      }
    } catch (e) {

    }

    return Leaderboardsupported ;

  }

  Future<List<RoomModel>>  GetMoreTrendRoom(context)async {
    

    try {
      Response response2 = await dio.get(
        '/api/GetNewRooms?page=${IndexTrade.toString()}',
      );
print(response2.data);
      if (response2.statusCode == 200) {

        List list =response2.data['Rooms']['data'];
        if(list.isNotEmpty){
          IndexTrade++;
        }
        
        list.forEach((element){
          TradeRooms.add(RoomModel.fromJson(element));
        });
        print(TradeRooms);
      }
    } catch (e) {
      
    }

    return TradeRooms;

  }
  Future<List<KickedUser>>  KickedUserRooms({context, roomid})async {

    try {
      Response response2 = await dio.get(
        '/api/getkickeduser/$roomid',
      );

      if (response2.statusCode == 200) {
        List list =response2.data;
        list.forEach((element) {
          KickeduserRooms.add(KickedUser.fromJson(element));
        });
        print(KickeduserRooms);
      }
    } catch (e) {
      
    }

    return KickeduserRooms;

  }

  Future<RoomModel> joinRooms({context, Roomid}) async {
    RoomViewmodel Roomss = Provider.of<RoomViewmodel>(context, listen: false);
    Roominfo = RoomModel(); // تصفير عشان مايرجعش غرفة قديمة لو فشل
    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId.toString(),
        "room_id": Roomid.toString(),
      });

      print('🚪 JOIN ROOM → URL: ${dio.options.baseUrl}api/JoinRoom');
      print('🚪 FIELDS: ${formData.fields}');

      Response response2 = await dio.post(
        'api/JoinRoom',
        data: formData,
      );

      print('📥 URL: ${response2.requestOptions.uri}');
      print('📥 STATUS: ${response2.statusCode}');
      print('📥 BODY: ${response2.data}');

      if (response2.statusCode == 200) {
        Roominfo = RoomModel.fromJson(response2.data['Room']);
        Joinid = response2.data['Room']['joinid'];
        Roomss.clearcompo();
        Roomss.hidewaitingtimer2();
        print('✅ JOIN ROOM SUCCESS | room id: ${Roominfo.id} | joinid: $Joinid');
      } else {
        print('❌ JOIN ROOM FAILED | status: ${response2.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ JOIN ROOM FAILED (Dio)');
      print('❌ URL: ${e.requestOptions.uri}');
      print('❌ STATUS: ${e.response?.statusCode}');
      print('❌ RESPONSE: ${e.response?.data}');
      print('❌ TYPE: ${e.type}');
      print('❌ MESSAGE: ${e.message}');

      final data = e.response?.data;
      if (data is Map && data['errNum'] != null) {
        Dialogs().ShowErrorRegesterToast(data['errNum'], context);
      }
    } catch (e, s) {
      // غالباً خطأ parsing في RoomModel.fromJson
      print('❌ JOIN ROOM FAILED (Other/Parsing): $e');
      print(s);
    }

    return Roominfo;
  }
  Future<bool> Addsupervisors({ context,Roomid,userid}) async {
    bool state=true;
    try {
      FormData formData = FormData.fromMap({
        "user_id": userid.toString(),
        "room_id": Roomid.toString(),
      });
      Response response2 = await dio.post(
        'api/AddSupervisors',
        data: formData,
      );
       
      if (response2.statusCode == 200) {
        state=true;
        //Provider.of<LoginViewmodel>(context,listen: false).SendCodeRegester(context: context,phonenumber: "+2"+phone.toString());
      }
    } catch (e) {
      state=false;
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return state;
  }
  Future<UploadResult> AddackImage({image}) async {
    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId.toString(),
        "image": await MultipartFile.fromFile(image?.path,
            filename: image?.path?.split('/')?.last),
      });
      Response response2 = await dio.post('api/AddRoomimages', data: formData);

      print('STATUS: ${response2.statusCode}');
      print('BODY: ${response2.data}');

      if (response2.statusCode == 200 || response2.statusCode == 201) {
        final url = response2.data['Roomimages']['image'].toString();
        LoginViewmodel user =
        Provider.of<LoginViewmodel>(roomcontext, listen: false);
        user.AddFirstbackground(val: url);
        return UploadResult(
          success: true,
          statusCode: response2.statusCode,
          url: url,
          message: response2.data['message']?.toString(),
        );
      }
      return UploadResult(success: false, statusCode: response2.statusCode);
    } on DioException catch (e) {
      print('STATUS: ${e.response?.statusCode}');
      print('BODY: ${e.response?.data}');   // <-- سبب الـ 400
      print('FIELDS: ${(e.requestOptions.data as FormData).fields}');
      print('FILES: ${(e.requestOptions.data as FormData).files.map((f) => f.key)}');
      return UploadResult(
        success: false,
        statusCode: e.response?.statusCode,
        message: e.response?.data?.toString(),
      );
    } catch (e) {
      print(e);
      return UploadResult(success: false, message: e.toString());
    }
  }
  Future<bool> FollowRoom({ context,Roomid }) async {
    bool state=true;
    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId.toString(),
        "room_id": Roomid.toString(),
      });
      Response response2 = await dio.post(
        'api/FollowRoom',
        data: formData,
      );

      if (response2.statusCode == 200) {
        state=true;
        //Provider.of<LoginViewmodel>(context,listen: false).SendCodeRegester(context: context,phonenumber: "+2"+phone.toString());
      }
    } catch (e) {
      state=false;
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return state;
  }
  Future<bool> RemoveFollowRoom({ context,Roomid }) async {
    bool state=true;
    try {
      FormData formData =   FormData.fromMap({
        "user_id": UserId.toString(),
        "room_id": Roomid.toString(),
      });
      Response response2 = await dio.post(
        'api/RemoveFollowRooms',
        data: formData,
      );

      if (response2.statusCode == 200) {
        state=true;
        //Provider.of<LoginViewmodel>(context,listen: false).SendCodeRegester(context: context,phonenumber: "+2"+phone.toString());
      }
    } catch (e) {
      state=false;
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return state;
  }

  List<Gifts> RoomGifts=[];
  Future<List<Gifts>> GetRoomGifts({Roomid}) async {

    try {
      FormData formData = FormData.fromMap({
        "room_id": Roomid.toString(),
      });
      Response response2 = await dio.post(
        'api/GetRoomGift',
        data: formData,
      );

      if (response2.statusCode == 200) {
        List list =response2.data['gifts'] ;
        list.forEach((element) {
          RoomGifts.add(Gifts.fromJson(element));
        });
        //Provider.of<LoginViewmodel>(context,listen: false).SendCodeRegester(context: context,phonenumber: "+2"+phone.toString());
      }
    } catch (e) {

      if (e is DioError) {
        print(e.response?.data['errNum']);

      } else {
        print(e);
      }
    }

    return RoomGifts;
  }
  List<Supervisors> SupervisorRoom=[];
  Future<List<Supervisors>> GetRoomSupercisors({Roomid}) async {

    try {

      Response response2 = await dio.get(
        'api/GetRoomSupervisors/$Roomid',

      );
print(response2.data);
      if (response2.statusCode == 200) {
        List list =response2.data ;
        list.forEach((element) {
          SupervisorRoom.add(Supervisors.fromJson(element));
        });
        //Provider.of<LoginViewmodel>(context,listen: false).SendCodeRegester(context: context,phonenumber: "+2"+phone.toString());
      }
    } catch (e) {

      if (e is DioError) {
        print(e.response?.data['errNum']);

      } else {
        print(e);
      }
    }

    return SupervisorRoom;
  }
  Future<bool> Removesupervisors({ context,Roomid,userid}) async {
    bool state=true;
    try {
      FormData formData = FormData.fromMap({
        "user_id": userid.toString(),
        "room_id": Roomid.toString(),
      });
      Response response2 = await dio.post(
        'api/RemoveSupervisors',
        data: formData,
      );

      if (response2.statusCode == 200) {
        state=true;
       }
    } catch (e) {
      state=false;

    }

    return state;
  }
  Future<RoomModel> CreateRoom({context, Category, city, image, name, backgroundimage, RoomAds}) async {
    try {
      FormData formData = FormData.fromMap({
        "name": name.toString(),
        "image": await MultipartFile.fromFile(image?.path, filename: image?.path?.split('/')?.last),
        "admin_id": UserId.toString(),
        "Category": Category,
        "city": city,
        "animateimage": backgroundimage.toString(),
        "RoomAds": RoomAds.toString()
      });

      print('🚀 CREATE ROOM → URL: ${dio.options.baseUrl}api/CreateRoom');
      print('🚀 FIELDS: ${formData.fields}');
      print('🚀 FILES: ${formData.files.map((f) => '${f.key}: ${f.value.filename}').toList()}');

      Response response2 = await dio.post(
        'api/CreateRoom',
        data: formData,
      );

      print('📥 URL: ${response2.requestOptions.uri}');
      print('📥 STATUS: ${response2.statusCode}');
      print('📥 BODY: ${response2.data}');

      if (response2.statusCode == 200) {
        Roominfo = RoomModel.fromJson(response2.data['room']);
        print('✅ CREATE ROOM SUCCESS | room id: ${Roominfo.id}');
      } else {
        print('❌ CREATE ROOM FAILED | status: ${response2.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ CREATE ROOM FAILED (Dio)');
      print('❌ URL: ${e.requestOptions.uri}');
      print('❌ STATUS: ${e.response?.statusCode}');
      print('❌ RESPONSE: ${e.response?.data}');
      print('❌ TYPE: ${e.type}');
      print('❌ MESSAGE: ${e.message}');

      final data = e.response?.data;
      if (data is Map && data['errNum'] != null) {
        Dialogs().ShowErrorRegesterToast(data['errNum'], context);
      }
    } catch (e, s) {
      print('❌ CREATE ROOM FAILED (Other): $e');
      print(s);
    }

    return Roominfo;
  }  Future<bool>  LeaveRoom({ context,Roomid}) async {
bool leaved=false;

    try {
      var  map={
        "join_id": Joinid.toString(),
        "room_id":Roomid.toString(),
        "user_id":   UserId.toString(),
      };
      map.removeWhere((key, value) => key == null || value == null||value=='null'||key=='null');
      FormData formData = FormData.fromMap(map);
      print('Join id is 1');
      Response response2 = await dio.post(
        'api/LeaveRoom',
        data: formData,
      );
      print('Join id is 2');
       
      if (response2.statusCode == 200) {
         
        leaved=true;
       }else if(response2.statusCode == 400){
        leaved=false;
      }
      print('Join id is  3');
    } catch (e) {
      print(e);
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return leaved;
  }
  Future<bool>  LeaveChair({ context,Roomid,chairid}) async {
    bool leaved = false;
    try {
      FormData formData = FormData.fromMap({
        "chair_id": chairid.toString(),
        "room_id":Roomid.toString(),
        "user_id":   UserId.toString(),
      });

      Response response2 = await dio.post(
        'api/LeaveChair',
        data: formData,
      );
       
      if (response2.statusCode == 200) {
         
        leaved=true;
      }else if(response2.statusCode == 400){
        leaved=false;
      }
    } catch (e) {
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return leaved;
  }
  Future<bool>  LeaveuserChair({ context,user_id,Roomid,chairid}) async {
    print(chairid);   print(Roomid);print(user_id);
    try {
      FormData formData = FormData.fromMap({
        "chair_id": chairid.toString(),
        "room_id":Roomid.toString(),
        "user_id":   user_id.toString(),
      });

      Response response2 = await dio.post(
        'api/LeaveChair',
        data: formData,
      );
      print(response2.data);
      if (response2.statusCode == 200) {
         
        print('done');
      }else if(response2.statusCode == 400){
        print('not done');
      }
    } catch (e) {
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return true;
  }
  Future<bool> joinChair({context,index,room_id,chair_id}) async {
      bool joicchair=false;
      try {
        print('xxxxxxxxxxxxxxxxx');
        print(UserId.toString());
        print(room_id.toString());
        print(chair_id.toString());
        FormData formData = FormData.fromMap({
          "user_id":  UserId.toString(),
          "room_id": room_id.toString(),
          "chair_id":chair_id.toString()
        });

        Response response2 = await dio.post(
          'api/JoinChair',
          data: formData,
        );
         
        print('waeassaeaseasasasewaeassaeaseasasasewaeassaeaseasasasewaeassaeaseasasasewaeassaeaseasasase');
        if (response2.statusCode == 200||response2.statusCode == 201) {


          joicchair=true;
        }else{
           
          print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
          joicchair=false;
        }
      } catch (e) {

        if (e is DioError) {
          print(e.response?.data['errNum']);
          Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
        } else {
          print(e);
        }
      }

      return joicchair;
  }
  Future<bool> ChangeChair({context,index,room_id,NewCharid,CurrentChairid}) async {
    bool joicchair=false;
    try {

      FormData formData =   FormData.fromMap({
        "user_id":  UserId.toString(),
        "room_id": room_id.toString(),
        "Current_chair":CurrentChairid.toString(),
        "chair_id":NewCharid.toString(),
      });

      Response response2 = await dio.post(
        'api/ChangeChair',
        data: formData,
      );

      print(response2.data);
      if (response2.statusCode == 200||response2.statusCode == 201) {


        joicchair=true;
      }else{


        joicchair=false;
      }
    } catch (e) {


    }

    return joicchair;
  }
  Future<bool> AdminChangeChair({context,index,room_id,NewCharid,CurrentChairid}) async {
    bool joicchair=false;
    try {

      FormData formData =   FormData.fromMap({
        "user_id":  UserId.toString(),
        "room_id": room_id.toString(),
        "Current_chair":CurrentChairid.toString(),
        "chair_id":NewCharid.toString(),
      });

      Response response2 = await dio.post(
        'api/AdminChangeChair',
        data: formData,
      );

      print(response2.data);
      if (response2.statusCode == 200||response2.statusCode == 201) {


        joicchair=true;
      }else{


        joicchair=false;
      }
    } catch (e) {


    }

    return joicchair;
  }
  Future<bool> ReturnAdminChair({context,index,room_id,NewCharid,CurrentChairid}) async {
    bool joicchair=false;
    try {

      FormData formData =   FormData.fromMap({
        "user_id":  UserId.toString(),
        "room_id": room_id.toString(),
        "Current_chair":CurrentChairid.toString(),
        "chair_id":NewCharid.toString(),
      });

      Response response2 = await dio.post(
        'api/ReturntoAdminChair',
        data: formData,
      );

      print(response2.data);
      if (response2.statusCode == 200||response2.statusCode == 201) {


        joicchair=true;
      }else{


        joicchair=false;
      }
    } catch (e) {


    }

    return joicchair;
  }

KickJoinadminuser({context,room_id,user_id})async{
  bool update=false;

  try {
    FormData formData = FormData.fromMap({
      "user_id": user_id.toString(),
      "room_id": room_id.toString(),

    });

    Response response2 = await dio.post(
      'api/Removeadminroom',
      data: formData,
    );

    if (response2.statusCode == 200) {
      update=true;
      print('true');
    }else{
      update=false;
      print('false');
    }
  } catch (e) {
    if (e is DioError) {
       
      Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
      if (e.response!.data['errNum'] == '3500') {
        
      }
    } else {
      print(e);
    }
  }

  return update;


}
  InviteUserToSET({context,room_id,user_id})async{
    bool update=false;

    try {
      FormData formData = FormData.fromMap({
        "user_id": user_id.toString(),
        "room_id": room_id.toString(),

      });

      Response response2 = await dio.post(
        'api/Inviteuser',
        data: formData
      );

      if (response2.statusCode == 200) {
        update=true;
        print('true');
      }else{
        update=false;
        print('false');
      }
    } catch (e) {
      if (e is DioError) {
        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {
        }
      } else {
        print(e);
      }
    }
    return update;
  }
  Future<bool> sendmessage({content, Roomid}) async {
    bool sent = false;
    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId.toString(),
        "room_id": Roomid.toString(),
        "content": content.toString(),
      });

      print('💬 SEND MESSAGE → URL: ${dio.options.baseUrl}api/AddChatRoom');
      print('💬 FIELDS: ${formData.fields}');

      Response response2 = await dio.post(
        'api/AddChatRoom',
        data: formData,
      );

      print('📥 URL: ${response2.requestOptions.uri}');
      print('📥 STATUS: ${response2.statusCode}');
      print('📥 BODY: ${response2.data}');

      if (response2.statusCode == 200) {
        sent = true;
        print('✅ SEND MESSAGE SUCCESS');
      } else {
        sent = false;
        print('❌ SEND MESSAGE FAILED | status: ${response2.statusCode}');
      }
    } on DioException catch (e) {
      sent = false;
      print('❌ SEND MESSAGE FAILED (Dio)');
      print('❌ URL: ${e.requestOptions.uri}');
      print('❌ STATUS: ${e.response?.statusCode}');
      print('❌ RESPONSE: ${e.response?.data}');
      print('❌ TYPE: ${e.type}');
      print('❌ MESSAGE: ${e.message}');
    } catch (e, s) {
      sent = false;
      print('❌ SEND MESSAGE FAILED (Other): $e');
      print(s);
    }

    return sent;
  }
  Future<bool> sendMention({  content,Roomid,Reciver_id})async{

    bool sent=true;
    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId.toString(),
        "room_id": Roomid.toString(),
        "content":content.toString(),
        "reciver_id":Reciver_id.toString(),
      });

      Response response2 = await dio.post(
        'api/AddMention',
        data: formData,
      );

      if (response2.statusCode == 200) {
        sent=true;
        print('true');
      }else{
        sent=false;
        print('false');
      }
    } catch (e) {
      if (e is DioError) {


        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }

    return sent;

  }
  Future<bool> LockChair ({ Chair_id, int? Lock,RoomModel ?Roominfo})async{
   bool update=false;
    try {
      FormData formData = FormData.fromMap({
        "chair_id": Chair_id.toString(),
        "room_id": Roominfo?.id.toString(),
        "Lock":Lock.toString(),
      });

      Response response2 = await dio.post(
        'api/LockChair',
        data: formData,
      );

      if (response2.statusCode == 200) {
        update=true;
        print('true');
      }else{
        update=false;
        print('false');
      }
    } catch (e) {
      
    }
    return update;
  }
  // ============ Helper: يطبع URL + FIELDS + STATUS + BODY + ERROR ============
  Future<Response> _post(String tag, String path, FormData formData) async {
    print('🎁 [$tag] URL   : ${dio.options.baseUrl}$path');
    print('🎁 [$tag] FIELDS: ${formData.fields}');
    try {
      final res = await dio.post(path, data: formData);
      print('🎁 [$tag] STATUS: ${res.statusCode}');
      print('🎁 [$tag] BODY  : ${res.data}');
      return res;
    } on DioError catch (e) {
      print('🎁 [$tag] ❌ DIO ERROR TYPE: ${e.type}');
      print('🎁 [$tag] ❌ STATUS : ${e.response?.statusCode}');
      print('🎁 [$tag] ❌ BODY   : ${e.response?.data}');
      print('🎁 [$tag] ❌ MESSAGE: ${e.message}');
      rethrow;
    }
  }

  Future<bool> SendGift({ context,Roomid,Listuser,giftid,quantity,Cost}) async {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);
    var send=true;
    try {
      FormData formData = FormData.fromMap({
        "Listuser": Listuser.toString(),
        "room_id": Roomid.toString(),
        "user_id": UserId.toString(),
        "quantity": quantity.toString(),
        "gift_id": giftid.toString(),
        "Cost":Cost.toString()

      });

      Response response2 = await _post('SendGift', 'api/sentGift', formData);

      if (response2.statusCode == 200) {
        user.Updatecoins(coins: int.parse(response2.data['user']['coins'].toString()));
        send=true;
        print('🎁 ✅ SEND GIFT SUCCESS');
      }else{
        send=false;
        print('🎁 ⚠️ SEND GIFT FAILED: ${response2.statusCode}');
      }
    } catch (e, s) {
      print('🎁 ❌ SEND GIFT ERROR: $e');
      print(s);
      if (e is DioError) {
        print(e.response?.data['msg']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['msg'],context);
      } else {
        print(e);
      }
    }

    return send;
  }

  Future<String> SentLuckyGift({ context,Roomid,Listuser,giftid,quantity,Cost}) async {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);
    String prsantage='';
    try {
      FormData formData = FormData.fromMap({
        "Listuser": Listuser.toString(),
        "room_id": Roomid.toString(),
        "user_id": UserId.toString(),
        "quantity": quantity.toString(),
        "gift_id": giftid.toString(),
        "Cost":Cost.toString()

      });

      Response response2 = await _post('LuckyGift', 'api/SentLuckyGift', formData);

      if (response2.statusCode == 200) {
        print('=====================ReturnMyCOINS========>${response2.data['gain']['coins'].toString()}==================>');
        print('=====================ReturnWin========>${response2.data['gain']['ReturnedValue']['win'].toString()}==================>');
        print('=====================Persantagec========>${response2.data['gain']['ReturnedValue']['Persantage'].toString()}==================>');

        if(response2.data['gain']['ReturnedValue']['Persantage']!=0&&response2.data['gain']['ReturnedValue']['Persantage']!='0'){
          Provider.of<RoomViewmodel>(roomcontext,listen: false).addComboWin( amount:response2.data['gain']['ReturnedValue']['win'],persantage: response2.data['gain']['ReturnedValue']['Persantage']);

        }

        user.Updatecoins(coins: int.parse(response2.data['gain']['coins'].toString()));
        prsantage=response2.data['gain']['ReturnedValue']['win'].toString();
        print(response2.data['gain']);
      }else{
        prsantage='';
        print('🎁 ⚠️ LUCKY GIFT FAILED: ${response2.statusCode}');
      }
    } catch (e, s) {
      print('🎁 ❌ LUCKY GIFT ERROR: $e');
      print(s);
      prsantage='';
      if (e is DioError) {
        print(e.response?.data['errNum']);
      }
    }

    return prsantage;
  }

  Future<String> SentCompoGift({ context,Roomid,Listuser,giftid,quantity,Cost}) async {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);
    String prsantage='';
    try {
      FormData formData = FormData.fromMap({
        "Listuser": Listuser.toString(),
        "room_id": Roomid.toString(),
        "user_id": UserId.toString(),
        "quantity": quantity.toString(),
        "gift_id": giftid.toString(),
        "Cost":Cost.toString()

      });

      Response response2 = await _post('ComboGift', 'api/SentCompo', formData);

      if (response2.statusCode == 200) {
        print('=====================ReturnMyCOINS========>${response2.data['gain']['coins'].toString()}==================>');
        print('=====================ReturnWin========>${response2.data['gain']['ReturnedValue']['win'].toString()}==================>');
        print('=====================Persantagec========>${response2.data['gain']['ReturnedValue']['Persantage'].toString()}==================>');
        if(response2.data['gain']['ReturnedValue']['Persantage']!=0&&response2.data['gain']['ReturnedValue']['Persantage']!='0'){
          Provider.of<RoomViewmodel>(roomcontext,listen: false). addComboWin( amount:response2.data['gain']['ReturnedValue']['win'],persantage: response2.data['gain']['ReturnedValue']['Persantage']);

        }



        user.Updatecoins(coins: int.parse(response2.data['gain']['coins'].toString()));
        prsantage=response2.data['gain']['ReturnedValue']['win'].toString();
        print(response2.data['gain']);
      }else{
        prsantage='';
        print('🎁 ⚠️ COMBO GIFT FAILED: ${response2.statusCode}');
      }
    } catch (e, s) {
      print('🎁 ❌ COMBO GIFT ERROR: $e');
      print(s);
      prsantage='';
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return prsantage;
  }

  Future<bool> SendEmoje({ context,Emoje,Room_id}) async {
    print( Emoje.toString());
    var send=true;
    try {
      FormData formData = FormData.fromMap({
        "emoji": Emoje.toString(),
        "room_id": Room_id.toString(),
        "user_id":UserId.toString(),
      });

      Response response2 = await _post('Emoji', 'api/Sendemoji', formData);

      if (response2.statusCode == 200) {

        send=true;

      }else{

        send=false;
      }
    } catch (e, s) {
      print('🎁 ❌ EMOJI ERROR: $e');
      print(s);

      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return send;
  }

  Future<bool> SentImageRoom({ context,image,Room_id}) async {

    var send=true;
    try {
      FormData formData =   FormData.fromMap({
        "image":await MultipartFile.fromFile(image?.path, filename: image?.path?.split('/')?.last),
        "room_id": Room_id.toString(),
        "user_id":UserId.toString(),
      });

      Response response2 = await dio.post(
        'api/SendImage',
        data: formData,
      );

      if (response2.statusCode == 200) {

        send=true;
         
      }else{

        send=false;
      }
    } catch (e) {
      print(e);

      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return send;
  }
  Future<bool> Playdice({ context,Room_id}) async {

    var send=true;
    try {
      FormData formData = FormData.fromMap({

        "room_id": Room_id.toString(),
        "user_id":UserId.toString(),
      });

      Response response2 = await dio.post(
        'api/Playdice',
        data: formData,
      );

      if (response2.statusCode == 200) {

        send=true;
         
      }else{

        send=false;
      }
    } catch (e) {
      print(e);

    }

    return send;
  }
  Future<bool> Playrollet({ context,Room_id,Name}) async {

    var send=true;
    try {
      FormData formData = FormData.fromMap({

        "room_id": Room_id.toString(),
        "user_id":UserId.toString(),
        "name":Name.toString(),
      });

      Response response2 = await dio.post(
        'api/Playrollet',
        data: formData,
      );

      if (response2.statusCode == 200) {

        send=true;
         
      }else{

        send=false;
      }
    } catch (e) {
      print(e);

    }

    return send;
  }
  Future<bool> Addinsults ({context, type,message})async{
    bool update=false;

    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId,
        "type": type,
        "text":message.toString(),
      });

      Response response2 = await dio.post(
        'api/Addinsult',
        data: formData,
      );

      if (response2.statusCode == 200) {
        update=true;
        print('true');
      }else{
        update=false;
        print('false');
      }
    } catch (e) {
      if (e is DioError) {

        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }
    return update;
  }
}
