import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ahlachat/Repositores/Follow_repositores/Follow_api.dart';
import 'package:ahlachat/Repositores/Moment_repositores/Moment_api.dart';
import 'package:ahlachat/Repositores/Shop_repositores/Shop_api.dart';
import 'package:ahlachat/main.dart';
import 'package:ahlachat/models/FamilyModel.dart';
import 'package:ahlachat/models/Inboxroom.dart';
import 'package:ahlachat/models/MessageModel.dart';
import 'package:ahlachat/models/emoji.dart';
import 'package:ahlachat/models/emojicategory.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/view/Screans/Authentication/LoginScrean/LoginScrean.dart';
import 'package:ahlachat/view/Screans/ChatScrean/ChatScrean.dart';
import 'package:ahlachat/view/Screans/HostreportScrean/HostreportScrean.dart';
import 'package:ahlachat/view/Screans/SearchScrean/widgets/SearchPeople.dart';
import 'package:ahlachat/viewmodels/InboxRooms_Viewmodel/InboxRoomsViewmodel.dart';
import 'package:ahlachat/viewmodels/Moment_Viewmodel/Moment_ViewModel.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:image_cropper/image_cropper.dart';

 import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../Repositores/user_repositores/user_api.dart';
import '../../models/Banner.dart';
import '../../models/LevelsFrame.dart';
import '../../models/MyVip.dart';
import '../../models/NotificationModel.dart';
import '../../models/UserGiftsmodel.dart';
import '../../models/Usermodel.dart';
import '../../models/VipModel.dart';
import '../../models/shipping.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';
import '../../util/helperclass.dart';
import '../Room_Viewmodel/Room_Viewmodel.dart';


class LoginViewmodel extends ChangeNotifier {
  int menuit= 0 ;
  int Acceptluckycount=0;
  resetAcceptluckycount(){
    Acceptluckycount=0;
  }

   Incrementluckycount(){
    Acceptluckycount=Acceptluckycount+1;
  }
  int? SelectGuessList;
  int? Guesscoins;
  int ? Packageid;
  UpdatePackageid({val}){
    Packageid=val;
    notifyListeners();
  }
  NewLuckyPackage({context,Roomid}) async {

    await userapi().NewLuckyPackage(Coins:Packageid , Roomid:Roomid , context: context)
        .then((value) {
      if(value==true){
        userinfo?.coins= (userinfo?.coins??0)-(Packageid??0);
         notifyListeners();
      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }

    });

    notifyListeners();
  }
  AcceptLuckyPackage({context,Roomid,Luckyid}) async {
    Incrementluckycount();
    await userapi().AcceptLuckyPackage(luckid:Luckyid  , Roomid:Roomid , context: context)
        .then((value) {
      if(value==true){

        notifyListeners();
      }else{

      }

    });

    notifyListeners();
  }
  NewGuess({context,Roomid}) async {
    ShowGlopalLoading();
    await userapi().NewGuess(Coins:Guesscoins ,Sendergueess:SelectGuessList ,Roomid:Roomid , context: context)
        .then((value) {
      if(value==true){


        notifyListeners();
      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }
      DismissGlopalLoading();
    });

    notifyListeners();
  }

  PlayGuess({context,Roomid,guessid,required int coins}) async {
    ShowGlopalLoading();
    await userapi().PlayGuess(guessid: guessid ,Sendergueess:SelectGuessList ,Roomid:Roomid , context: context)
        .then((value) {
      if(value==true){
        userinfo?.coins= (userinfo?.coins??0)-coins;

        notifyListeners();
      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }
      DismissGlopalLoading();
    });

    notifyListeners();
  }
  SelectGuess({val}){
    SelectGuessList=val;
    notifyListeners();
  }
  SelectGuesscoins({val}){
    Guesscoins=val;
    notifyListeners();
  }
  updateMenuit(val){
    menuit=val;
    notifyListeners();
  }
String CurrentIndex='5';


  TextEditingController SearchController=TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;
  usermodel? userroominfo;
  usermodel ?joinuserprofile;
  usermodel ? userProfileData;
  TextEditingController textEditingController = TextEditingController();
  String currentText = "";
  String Flag='flags/egy.png';
  String Code='+20';
  String Country='Egypt';
  String  Flag2 ='flags/egy.png';
  String ?Code2 ;
  String ?Name2 ;
  var UsernameComp;
  var PasswordComp;
  var HistoryComp;
  int ginder=0;
  int day=0;
  int year=0;
  int month=0;
  int ?sendcodestate;
  TextEditingController LoginPhonenumber=  TextEditingController();
  TextEditingController LoginID=  TextEditingController();
  TextEditingController LoginPassword=  TextEditingController();
  bool showloading = false;
  bool showloading2 = false;
  bool showloading3= false;
  bool showloading4= false;
  bool showloading5= false;
  bool showloading6= false;
  bool showloading7= false;
  bool showloading8= false;
  bool showloading9= false;
  bool showloading10= false;
  bool showloading11= false;
  bool showloading12= false;
  bool showloading13= false;
  bool showloading14= false;
  bool showloading15= false;
  bool showloading16= false;
  bool showloading31= false;
  List<usermodel>Searchusers=[];
  TextEditingController Content=TextEditingController();
  TextEditingController Contact=TextEditingController();
  var Googleaccount;
  var Signupimage;
  var Updateimage;
  var Reportimage;
  var Edimage;
  var Comimage;
  var ProfileImage;
  var Avatarlink;
  var name;
  var phone;
  var password;
  bool gender = false;
  bool obscureText = false;
  String? Username;
  String? Password;
  String? PhoneNumber;
  String? Description;
  String? City;
  String? History;
  String? FaceBook;
  List<Bannerss> Banners=[];
  List<emojimodel> emojis=[];
  List<emojecategory> emojisCategory=[];
  List Giftcatigoris=[];
  List LuckyGiftcatigoris=[];
  List Roomcatigoris=[];
  List background=[];
  AddFirstbackground({val}){
    background.insert(0, {'id':0,'image':val});

    notifyListeners();
  }
  List <shipping> Shipping=[];
  List <LevelFrame> LevelFrames=[];
  usermodel ?ShowProfiluser;
  String Selectedday = DateTime.now().day.toString();
  String Selectedmonth = DateTime.now().month.toString();
  String Selectedyear = DateTime.now().year.toString();
  String? Choose='Help';
  String? Choose2="WhatsApp";
List<usergifts>UserGift=[];
  List< Notificationmodel>Notifications=[];

List imoge=[];
 List Luckypackages=[];
bool value = false;
usermodel? playerinfo;
usermodel? userinfo;
bool  Newmessage=false;
List selectedcolor=[];
Widget CurrentBage= SizedBox();
int TargetMin=0;
  GetTargetTime({ context})async {
    ShowGlopalLoading();
    await userapi()
        .GetTimeTarget(  context: context)
        .then((value) {
      navigateTo(context: context, screen: HostreportScrean());
      TargetMin=value;
      notifyListeners();
      DismissGlopalLoading();
    });
    notifyListeners();
  }
UserGifts({ context})async {
  ShowGlopalLoading();
  await userapi()
      .GetUserGifts(  context: context)
      .then((value) {

    UserGift=value;
    notifyListeners();
    DismissGlopalLoading();
  });
  notifyListeners();
}
InboxRoomModel ? ChatRoom=InboxRoomModel();
GetInBoxChat({ context,userid,user})async {
  InboxroomViewModel    Inboxrooms= Provider.of<InboxroomViewModel>(context,listen: false);

  ShowGlopalLoading();
    await Followapi().CheckFriends( userid ).then((value)async {
if(value==true){
  await userapi()
      .ChatInBox( userid:userid )
      .then((value) {
    if(value?.id!=null){
      ChatRoom=value;

      Provider.of<InboxroomViewModel>(context,listen: false).textEditingController.clear();

      navigateTo(context: context, screen: ChatScrean(InboxContent: ChatRoom,states: 0,));
    }else{


      Provider.of<InboxroomViewModel>(context,listen: false).textEditingController.clear();
      ChatRoom=InboxRoomModel(id: 0,senderId: UserId,userId:userid.toString(),user: user,sender: userinfo,createdAt: userinfo?.createdAt,lastMessage: '',message: [], numberUnread: 0,updatedAt:userinfo?.createdAt  ) ;

      navigateTo(context: context, screen: ChatScrean(InboxContent:ChatRoom,states: 0,));
    }

    DismissGlopalLoading();
  });
}else{
  Dialogs().showtoast('يجب ان تصبح صديق اولا');
}


    DismissGlopalLoading();
  });

  notifyListeners();
}
addtochatRoom(Message value){
  ChatRoom?.message?.add(value);
  notifyListeners();
}
UpdateChatRoom({InboxRoomModel ?value}){

  ChatRoom=value;
  notifyListeners();
}
Future ProfileImagepick(context) async {
  await userapi().getImageGalary().then((value) {
    if(value!=null){
      Cropimage2(value);
      print(value.runtimeType);
    }

    notifyListeners();
  });
  notifyListeners();
}
Cropimage2(value) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: value.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
      ],
    );

    if (croppedFile != null) {
      ProfileImage = File(croppedFile.path);
      AddProfileImage();
      notifyListeners();
    }
  }


AddProfileImage( ) async {
  ShowGlopalLoading();
  await userapi().
  AddProfileImage( image:ProfileImage )
      .then((value) {
    if(value.id!=null){
      userProfileData?.ProfileImages?.add(value);

      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
      notifyListeners();
    }else{
      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
    }
    DismissGlopalLoading();
  });

  notifyListeners();
}

deleteProfileImage(imageid)async{
  ShowGlopalLoading();
  await userapi().DeleteProfileImage( ImageId: imageid )
      .then((value) {
        if(value==true){
          userProfileData?.ProfileImages?.removeWhere((element) => element.id==imageid);
          Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
        }else{
          Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

        }
        notifyListeners();
        DismissGlopalLoading();
  });
}
likepost(Postid,value){
  userProfileData?.Postuser?.where((element) => element.id==Postid).first.like?.add(value);
  notifyListeners();
}
  DeletePost({context,postid})async{
    ShowGlopalLoading();
    await Momentapi().DeletePost(context: context,postid: postid).then((value) {
      if(value==true){
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));

        Provider.of<MomentViewModel>(context,listen: false).GeneralPosts.removeWhere((element) => element.id==postid);
      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }
      notifyListeners();
      DismissGlopalLoading();
    });
  }

AddComment(Postid,value){

  userProfileData?.Postuser?.where((element) => element.id==Postid).first.commentsuser?.add(value);
  notifyListeners();
}

removeLikepost(Postid,value){
  userProfileData?.Postuser?.where((element) => element.id==Postid).first.like?.removeWhere((element) => element.userId.toString()==userProfileData?.id.toString());

  notifyListeners();
}


UpdateCurrentIndex(String val){
  CurrentIndex=val;
  notifyListeners();
}
UserpdateEntry({context, Entry}) async {
  ShowGlopalLoading();
  await shopapi().UpdateEntry(Entry:Entry, context: context)
      .then((value) {
    if(value==true){
      userinfo?.entry=AppConstants.Image_URL+Entry;
      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
    }else{
      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

    }
    DismissGlopalLoading();
  });

  notifyListeners();
}

UserpdateFrame({context, Frame}) async {
  ShowGlopalLoading();
  await shopapi().
  UpdateFrame(Frame:Frame, context: context)
      .then((value) {
    if(value==true){
      userinfo?.frameimage=AppConstants.Image_URL+Frame;
      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
    }else{
      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

    }
    DismissGlopalLoading();
  });

  notifyListeners();
}
UpdateCurrentPage(  Widget  Bage){
  CurrentBage=Bage;
  notifyListeners();
}
adduserimoge({int ?id, imoges}){
  imoge.add({'uid':id ,'time': DateTime.now(),'imoge':imoges});
  print(id);
  if(imoge.length>0){
    Timer.periodic(Duration(seconds:1,), (timer) {
      for (var i in imoge){
        if(DateTime.now().difference(i['time']).inSeconds>3){
          if(imoge.length>0){
            imoge.remove(i) ;
            notifyListeners();
            break;
          }


        }
      }


    });
  }

  notifyListeners();
}


  LuckYPackage({int ?id, Lucky}){
    resetAcceptluckycount();
    Luckypackages.add({'id':id ,'time': DateTime.now(),'Lucky':Lucky});
    print(Luckypackages);
    if(Luckypackages.length>0){
      Timer.periodic(Duration(seconds:2,), (timer) {
        for (var i in Luckypackages){
          if(DateTime.now().difference(i['time']).inSeconds>5){
            if(Luckypackages.length>0){
              Luckypackages.remove(i) ;
              notifyListeners();
              break;
            }


          }
        }


      });
    }

    notifyListeners();
  }
checkShareRoom({id}){
  if(SharedRoomIds.contains(id)){
    return true;
  }else {
    return false;
  }

}
AddFamilyRequest(int val){
  userinfo?.FamilyRequests?.add(val);
  notifyListeners();
}

RemoveFamilyRequest(id){
  userinfo?.FamilyRequests?.remove(id);
  notifyListeners();
}
LeaveFamily(id){
  userinfo?.FamilyRequests?.remove(id);
  userinfo?.FamilyId=null;
  userinfo?.MyFamil=null;
  userinfo?.FamilyModels=null;
  notifyListeners();
}

CreateFamily(FamilyModel val){
  userinfo?.coins=(userinfo?.coins??0)-5000;
  userinfo?.FamilyAdmin=1;
  userinfo?.FamilyId=val.id;
  userinfo?.MyFamil=val;
  notifyListeners();
}
Updatecoins({required int coins}){

  userinfo?.coins=coins   ;

  notifyListeners();
}
MyUSERINFO(usermodel U){
  userinfo=U;
  notifyListeners();
}
  Exchangecoins({context,jwile})async{
    ShowGlopalLoading();
    userinfo?.Input=(userinfo?.Input??0)-int.parse(jwile);

    await userapi().Exchangecoins(context: context,jwile:jwile ).then((value) {
      if(value[0]==true){
       userinfo?.coins= value[1];
       Dialogs().showtoast( value[1].toString());

      }else{
        userinfo?.Input=(userinfo?.Input??0)+int.parse(jwile);
      }
      DismissGlopalLoading();
      notifyListeners();

    });
  }
  GetNotification({ context})async {
    showSpinner15();
    await userapi()
        .UserNotification(  context: context)
        .then((value) {
      hideSpinner15();
      Notifications=value;

    });
    notifyListeners();
  }
  addtoselectedcolor({int ?color}){
    selectedcolor.clear();
    selectedcolor.add(color);
    notifyListeners();
  }
  updateAgency(){
    userinfo?.agency=null;
    notifyListeners();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<void> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize();

      final GoogleSignInAccount account =
      await _googleSignIn.authenticate();

      print('Google User: ${account.email}');
      print('Name: ${account.displayName}');
      print('ID: ${account.id}');
    } catch (e) {
      print('Google Sign In Error: $e');
    }
  }
  SearchGetusers({context,text}) async {

    ShowGlopalLoading();
    await userapi().SearchUser( text).then((value) {
      Searchusers=value;
print(Searchusers.length);
      navigateTo(context: context,screen: Searchpeople());
      DismissGlopalLoading();
    });
    notifyListeners();
  }
  void hideSpinner31(){
    showloading31= false;
    notifyListeners();
  }
  void showSpinner31(){
    showloading31 = true;
    notifyListeners();
  }
  changeNewmessage(value){
    userinfo?.MessageNumber=(userinfo?.MessageNumber??0)+1;
    Newmessage=value;
    notifyListeners();
  }

  RemoveMessage( ){
  if((userinfo?.MessageNumber??0)>0&&userinfo?.MessageNumber!=null){
    userinfo?.MessageNumber=(userinfo?.MessageNumber??0)-1;
  }

print(userinfo?.MessageNumber);
    notifyListeners();
  }
  AddKarisma(value){
    userinfo?.Karisma=value;
    notifyListeners();
  }
  AddCoins(value){
    userinfo?.coins=value;
    notifyListeners();
  }
  AddCoinspluse({value}){
    userinfo?.coins=(userinfo?.coins??0) +value as int;

    notifyListeners();
  }
  MinusCoinspluse({value}){
    userinfo?.coins=(userinfo?.coins??0) -value as int;

    notifyListeners();
  }
  Changecoins({value}){
    userinfo?.coins= value as int;
    notifyListeners();
  }
  UpdateUsernameComp({name}){
    UsernameComp=name;
    notifyListeners();
  }
  UpdatePasswordComp({name}){
    PasswordComp=name;
    notifyListeners();
  }
  updatesendcodestate({value}){
    sendcodestate=value;
    notifyListeners();
  }

  clearCodepins(){
    currentText='';
    textEditingController.clear();

    notifyListeners();
  }


  ByeVip({context,VipModel? vip})async{
    ShowGlopalLoading();
    await userapi().ByeVip(context: context,Vip: vip,).then((value){
      if(value?.id!=null){

      //  userinfo?.MyVip=value;
        userinfo?.coins= (userinfo?.coins??0)-(vip?.cost??0);
        userinfo?.Karisma=(( userinfo?.Karisma??0)+((value?.Vip?.level??0)*LEVELAMOUNT)) as int?;
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
      }
      DismissGlopalLoading();
    });
    notifyListeners();
  }
   UseVip({context,MyVipmodel? Myvip})async{
  ShowGlopalLoading();
  await userapi().UseVip( Vip: Myvip,).then((value){
    if(value?.id!=null){


     userinfo?.MyVip=value;
     if(value?.newId!=null){
       userinfo?.Newid=value?.newId;
     }
       if(value?.Vip?.coloredMessage!=null){
         userinfo?.ColoredMessage=value?.Vip?.coloredMessage;
       }
       if(value?.Vip?.hidden!=0){
         userinfo?.Hidden=1;
       }

       if(value?.Vip?.entry!=null){
         userinfo?.entry=value?.Vip?.urlentry;
       }
       if(value?.Vip?.frame!=null){
         userinfo?.frameimage=value?.Vip?.urlframe;
       }
       if(value?.Vip?.bubbles!=null){
         userinfo?.frameimage=value?.Vip?.profileEntry;
       }
     Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
     notifyListeners();
    }
    DismissGlopalLoading();
  });
  notifyListeners();
}


  RemoveVip({ MyVipmodel ?MyVip})async{
    ShowGlopalLoading();

    await userapi().RemoveVip( MyVip: MyVip,).then((value){
      if(value==true){

        userinfo?.MyVip=null;
        if(MyVip?.Vip?.urlentry==userinfo?.entry){
          userinfo?.entry=null;
      }
      if(MyVip?.Vip?.urlframe==userinfo?.frameimage){

      userinfo?.frameimage=null;
      }
      if(MyVip?.Vip?.profileEntry==userinfo?.bubbles){

      userinfo?.bubbles=null;
      }
      if(MyVip?.newId==userinfo?.Newid){
      userinfo?.Newid=null;
      }
      if(MyVip?.colorMessage==userinfo?.ColoredMessage){
      userinfo?.ColoredMessage=null;
      }

      if(MyVip?.Vip?.hidden==1){
      userinfo?.Hidden=0;
      }
        notifyListeners();
      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

      }
      DismissGlopalLoading();
      notifyListeners();
    });
    notifyListeners();
  }
  void showSpinner13() {
    showloading13= true;
    notifyListeners();
  }

  void hideSpinner13() {

    showloading13 = false;
    notifyListeners();
  }


  void showSpinner14() {

    showloading14= true;
    notifyListeners();
  }

  void hideSpinner14() {

    showloading14 = false;
    notifyListeners();
  }

  void showSpinner16() {

    showloading16= true;
    notifyListeners();
  }

  void hideSpinner16() {

    showloading16 = false;
    notifyListeners();
  }
  void showSpinner15() {

    showloading15= true;
    notifyListeners();
  }

  void hideSpinner15() {

    showloading15 = false;
    notifyListeners();
  }

  void showSpinner12() {
    print(' 9');
    showloading12= true;
    notifyListeners();
  }

  void hideSpinner12() {

    showloading12 = false;
    notifyListeners();
  }
  void showSpinner9() {

    showloading9= true;
    notifyListeners();
  }

  void hideSpinner9() {

    showloading9 = false;
    notifyListeners();
  }
  void showSpinner10() {
    print(' 9');
    showloading10= true;
    notifyListeners();
  }
  void hideSpinner10() {

    showloading10 = false;
    notifyListeners();
  }


  void showSpinner11() {

    showloading11= true;
    notifyListeners();
  }
  void hideSpinner11(){

    showloading11 = false;
    notifyListeners();
  }
  UpdateFlagCode({Flag1,Code1,Country1}){
    Flag=Flag1;
    Code=Code1;
    Country=Country1;
    notifyListeners();
  }
  UpdateFlagCode2({Flag1,Code1,Name1}){
    Flag2=Flag1;
    Code2=Code1;
    Name2=Name1;
    notifyListeners();
  }
  void showSpinner8() {
    print(' 8');
    showloading8 = true;
    notifyListeners();
  }
  userlogin({context}) async {
    if (Code == '+20' && LoginPhonenumber.text.startsWith('0')) {
      LoginPhonenumber.text = LoginPhonenumber.text.substring(1);
    }

    ShowGlopalLoading();
    try {

      final value = await userapi().UserLogin(
        Phonenumber: Code + LoginPhonenumber.text,
        context: context,
      );

      print('✅ Login API Success');
      print('Response: ${value.toJson()}');

      if (value.id != null) {
        print('✅ Login Success');
        print('User ID: ${value.id}');

        userinfo = value;
      }
    } on DioException catch (e) {
      print('URL: ${e.requestOptions.uri}');
      print('Data sent: ${e.requestOptions.data}');
      print('Response: ${e.response?.data}');
      if (e.response?.statusCode == 404) {
        print('URL: ${e.requestOptions.uri}');
        print('Data sent: ${e.requestOptions.data}');
        print('Response: ${e.response?.data}');
      }
    } finally {
      DismissGlopalLoading(); // اقفل اللودينج (اسم الدالة حسب اللي عندك)
    }
    notifyListeners();
  }
  SendCodeRlogin({context,phonenumber})async{

    await userapi().SendCodeRlogin(context: context,phonenumber:phonenumber);
    notifyListeners();
  }
  SendCodeSignUp({context,phonenumber})async{ 
    await userapi().SendCodeSignUp(context: context,phonenumber:phonenumber);
    notifyListeners();
  }
  ReSendCodeRlogin({context,phonenumber})async{
    showSpinner9();
    await userapi().ReSendCodelogin(context: context,phonenumber:phonenumber);
    notifyListeners();
  }
  EnterCodelogin({context,code,Phonenumber})async{
    await userapi().EnterCodelogin(Phonenumber:Phonenumber,context: context,code:code.toString()).then((e){

    });
    notifyListeners();
  }
  EnterCodeSignUp({context,code,})async{
    await userapi().EnterCodeSignUp(context: context,code:code.toString());
    notifyListeners();
  }
  void hideSpinner8() {

    showloading8 = false;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  GetShoweduserProfile(userdata){
    userProfileData=userdata;
    UserProfileData(  id:userdata.id);
    notifyListeners();
  }
  UserProfileData({id,context})async {
    ShowGlopalLoading();

    await userapi()
        .UserProfileData(id:id , context: context)
        .then((value) {
      DismissGlopalLoading();

      if(value.id!=null){
        userProfileData = value;

        notifyListeners();
      }
    });
    notifyListeners();
  }
  void showSpinner7() {

    showloading7= true;
    notifyListeners();
  }
  void hideSpinner7() {

    showloading7 = false;
    notifyListeners();
  }
  clearreport(){
  Choose="Help";
  Choose2="WhatsApp";
  Reportimage=null;
  Contact.clear();
  Content.clear();
}
  MyGifts({context}) async {
    await userapi()
        .MyGifts(   context: context)
        .then((value) {
 userinfo?.giftssent=value[0];
 userinfo?.giftscollect=value[1];
    });
    notifyListeners();
  }
  SendReport({context }) async {
    showSpinner7();
    await userapi()
        .SendReport(   context: context,image: Reportimage,contact_type: Choose2,contact: Contact.text,feedback:Content.text,feedback_type:Choose  )
        .then((value) {
 if(value==true){
   Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
 }else{
   Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

 }
 clearreport();
 hideSpinner6();
 hideSpinner7();
    });
    notifyListeners();
  }
  void showSpinner6() {
    print(' 2');
    showloading6 = true;
    notifyListeners();
  }
  SetChoose({value}){
    Choose=value;
    notifyListeners();
  }
  SetChoose2({value}){
    Choose2=value;
    notifyListeners();
  }
  void hideSpinner6() {

    showloading6 = false;
    notifyListeners();
  }
  void showSpinner4() {

    showloading4 = true;
    notifyListeners();
  }
  void hideSpinner4() {

    showloading4 = false;
    notifyListeners();
  }
  void showSpinner5() {

    showloading5 = true;
    notifyListeners();
  }

  void hideSpinner5() {

    showloading5 = false;
    notifyListeners();
  }


  RemoveCoins({required int cost}){
    userinfo?.coins= (userinfo?.coins??0) - cost   ;
    notifyListeners();
  }
  UpdateFrame({frames}){
    userinfo?.frameimage=AppConstants.Image_URL+frames;
    notifyListeners();
  }
  UpdateEnterbubles({frames}){
    userinfo?.Enterbubles=AppConstants.Image_URL+frames;
    notifyListeners();
  }
  UpdateProfilebubles({frames}){
    userinfo?.bubbles=AppConstants.Image_URL+frames;
    notifyListeners();
  }
  removeFrame(){
    userinfo?.frameimage='';
    notifyListeners();
  }
  removeEntry(){
    userinfo?.entry='';
    notifyListeners();
  }
  removeEnterbubles(){
  userinfo?.Enterbubles='';
  notifyListeners();
  }
  removeProfilebubles(){
    userinfo?.bubbles='';
    notifyListeners();
  }
  UpdateEntry({Entry}){
    userinfo?.entry=AppConstants.Image_URL+Entry;
    notifyListeners();
  }
  void ChangeHistory(Histor){
    History=Histor;
    notifyListeners();
  }
  void ChangeCity({Cityname}){
    City=Cityname;
    notifyListeners();
  }


  Removebubbles({context}) async {
    showSpinner13();
    await userapi().Removebubbles(context:context).then((value) {
      if(value==true){
        userinfo?.bubbles=null;
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

      }
      hideSpinner13();
    });

    notifyListeners();
  }
   updatebubbles({context, bubbles}) async {
     ShowGlopalLoading();
    await userapi().
    Updatebubbles(bubbles: bubbles, context: context)
        .then((value) {
      if(value==true){
        userinfo?.bubbles=AppConstants.Image_URL+bubbles;
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));

      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

      }
      DismissGlopalLoading();
    });

    notifyListeners();
  }
  List _extractList(Map value, List<String> keys) {
    for (final k in keys) {
      final v = value[k];
      if (v is List && v.isNotEmpty) return v;
    }

    const ignored = ['catigoris', 'luckycatigoris', 'emojicategory'];
    for (final entry in value.entries) {
      final k = entry.key.toString().toLowerCase();
      if (k.contains('categ') &&
          !ignored.contains(k) &&
          entry.value is List &&
          (entry.value as List).isNotEmpty) {
        print('AUTO-FOUND categories key: ${entry.key}');
        return entry.value as List;
      }
    }

    print('⚠️ No room categories from server, using defaults');
    return [
      {'id': 1, 'name': 'دردشة'},
      {'id': 2, 'name': 'ترفيه'},
      {'id': 3, 'name': 'موسيقى'},
      {'id': 4, 'name': 'ألعاب'},
      {'id': 5, 'name': 'أصدقاء'},
      {'id': 6, 'name': 'عائلة'},
      {'id': 7, 'name': 'أخرى'},
    ];
  }
  updateColoredMessage({context})async{
    showSpinner13();
    await userapi().
    updateColoredMessage(Color:selectedcolor.first , context: context)
        .then((value) {
      if(value==true){
        userinfo?.ColoredMessage=Color;
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));

      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

      }
      hideSpinner13();
    });

    notifyListeners();

  }
  LoginId({context})async{
    ShowGlopalLoading();
    await userapi(). UserLoginID(ID: LoginID.text,Password: LoginPassword.text,  context: context);
    notifyListeners();

  }

  SetHidden({context,hidden})async{
    showSpinner13();
    await userapi(). setHidden(Hidden: hidden,  context: context)
        .then((value) {
      if(value==true){
        userinfo?.Hidden=hidden;
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));

      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

      }
      hideSpinner13();
    });

    notifyListeners();

  }
  void  toggle() {
      obscureText = !obscureText;
      notifyListeners();
  }
  void showSpinner() {

    showloading = true;
    notifyListeners();
  }
  void hideSpinner() {

    showloading = false;
    notifyListeners();
  }
  void showSpinner2() {

    showloading2 = true;
    notifyListeners();
  }
  void hideSpinner2() {

    showloading2 = false;
    notifyListeners();
  }
  void showSpinner3() {

    showloading3 = true;
    notifyListeners();
  }
  void hideSpinner3() {

    showloading3 = false;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  getuserroominfo({usermodel? user}){

    userroominfo=user;
    notifyListeners();
  }
  userinfoRoom({id, context}) async {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: false);

    showSpinner3();
    await userapi()
        .userinfoRoom(id:id ,roomid: Room.Currentroom?.id.toString(),context: context).then((value) {
      hideSpinner3();
      if(value.id!=null){

        userroominfo = value;
        notifyListeners();
      }
    });
    notifyListeners();
  }
  checksignup({name, phone, context}) async {

    showSpinner();
    await userapi()
        .CheckRegester(name: name, phone: phone, context: context)
        .then((value) {
      hideSpinner();


    });
    notifyListeners();
  }
  UserLoginVerify({context,Parimater}) async {
    ShowGlopalLoading();

    await userapi()
        .UserLoginVerify( context: context,Parimater:Parimater)
        .then((value) {
      hideSpinner();

      if(value.id!=null){

        userinfo = value;

      }

    }).then((value) => hideSpinner());
    notifyListeners();
  }
  userinformation({ context}) async {

    userinfo = await userapi().Userinfo( context: context);
    notifyListeners();
  }
  userinformationID({ID, context}) async {
    showSpinner();
     await userapi().UserinfoID(ID:  ID.toString(), context: context).then((value) {

     if(value.id!=null){
       playerinfo=value;
     }else {
       Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

       Navigator.pop(context);
     }
     hideSpinner();
    });
    notifyListeners();
  }
  updateNormalProfile({FlagCITY,ginder,City,token,context,Password, Description,name,PhoneNumber,year,month,day}) async {

    ShowGlopalLoading();


    await userapi().UpdatenormalProfile(
        token: token,
        Description: Description,
        context: context,Flag:FlagCITY,
         name:name,ginder:ginder,Image: Edimage,Password: Password,PhoneNumber:PhoneNumber, City:City, day: day,month: month,year: year)
        .then((value) {

       if(value.id!=null){
        userinfo?.password = value.password;
        userinfo?.name = value.name;
        userinfo?.description = value.description;
        userinfo?.ginder = value.ginder;
        userinfo?.image=value.image;
      }
       DismissGlopalLoading();
    });
    notifyListeners();
  }
  updatephoto({token, photo, context,avatar}) async {
    showSpinner2();

    await userapi()
        .FutureUpdatephoto(
        token: token,
        photo:photo,
        avatar:avatar,
        context: context)
        .then((value) {
      hideSpinner();

      userinfo?.image= value;
      hideSpinner2();
    });
    notifyListeners();
  }
  SendCodeResetPassword({context,phonenumber})async{
    await userapi().SendPhoneCodeResetPassword(context: context,phonenumber:phonenumber);
    notifyListeners();
  }

  waitingConstDate(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map value=  jsonDecode(prefs.getString('ConstData')??'') ;


      List list =value['Banner'];
      list.forEach((element) {Banners.add(Bannerss.fromJson(element));});
      List emojilist =value['emoji'];
    //  emojilist.forEach((element) {emojis.add(emojimodel.fromJson(element));});
      Giftcatigoris=value['catigoris'];

      LuckyGiftcatigoris=value['luckycatigoris'];
      Roomcatigoris=value['Roomcategory'];
      background=value['background'];
    AppLink = value['version']?['AppLink']?.toString() ?? '';
      Appversion=value['version']['version'];


      List datalist =value['Shipping'];




      datalist.forEach((element) {
        Shipping.add(shipping.fromJson(element));
      });

      prefs.setString('ConstData',jsonEncode(value));



      // if(Appversion!=version&&Appversion!=''){
      //   Dialogs().showdialog(context: context, tittle: 'Update App', content: 'We have a new version of the application update the application now', buttontext: getLang( context: context, key: "Yes"), onTap: ()async{
      //     Navigator.pop(context);
      //     Helper().launchInBrowser(AppLink);
      //     SystemNavigator.pop();
      //   });
      // }else{
      //
      // }





    notifyListeners();
  }
Future<String?>  getId() async {
  var deviceInfo = DeviceInfoPlugin();
  print(deviceInfo);
  if (Platform.isIOS) { // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else if(Platform.isAndroid) {
    print('Platform.isAndroid');
    var androidDeviceInfo = await deviceInfo.androidInfo;

    return androidDeviceInfo.id; // unique ID on Android
  }
}
  getAllconstant(context) async {
    await userapi().getAllconstant(context).then((value) async {
      if (value == null || value is! Map) {
        print('❌ GetConstData returned null');
        return;
      }

      // response ناقص؟ متعتبرهوش حظر
      if (!value.containsKey('banstatus')) {
        print('⚠️ GetConstData incomplete response: ${value.keys}');
        return;
      }

      if (value['banstatus'].toString() == '0') {
        print('CONST KEYS: ${value.keys}');

        Banners.clear();
        emojis.clear();
        emojisCategory.clear();
        Shipping.clear();

        // الأهم الأول: دول مش بيعتمدوا على موديلات
        Giftcatigoris = value['catigoris'] ?? [];
        LuckyGiftcatigoris = value['luckycatigoris'] ?? [];
        Roomcatigoris = _extractList(value, [
          'Roomcategory',
          'RoomCategory',
          'roomcategory',
          'Roomcategories',
          'room_category',
        ]);
        background = value['background'] ?? [];

        try {
          AppLink = value['version']['AppLink']?.toString() ?? '';
          Appversion = value['version']['version']?.toString() ?? '';
        } catch (e) {
          print('❌ version parse: $e');
        }

        // الموديلات: كل واحد معزول عشان لو وقع ميوقفش الباقي
        try {
          for (final e in (value['Banner'] as List? ?? [])) {
            Banners.add(Bannerss.fromJson(e));
          }
        } catch (e) {
          print('❌ Banner parse: $e');
        }

        try {
          for (final e in (value['emoji'] as List? ?? [])) {
            emojis.add(emojimodel.fromJson(e));
          }
        } catch (e) {
          print('❌ emoji parse: $e');
        }

        try {
          for (final e in (value['emojiCategory'] as List? ?? [])) {
            emojisCategory.add(emojecategory.fromJson(e));
          }
        } catch (e) {
          print('❌ emojiCategory parse: $e');
        }

        try {
          for (final e in (value['Shipping'] as List? ?? [])) {
            Shipping.add(shipping.fromJson(e));
          }
        } catch (e) {
          print('❌ Shipping parse: $e');
        }

        // تحديث إجباري
        try {
          if (value['version']['ForceUpdate'].toString() == '1') {
            if (Appversion != version && Appversion != '') {
              Fluttertoast.showToast(
                  msg: 'يجب عليك تحديث التطبيق إلى الإصدار الأخير  حتي تستطيع استخدامه',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 15.0);
              Helper().launchInBrowser(AppLink);
              SystemNavigator.pop();
            }
          }
        } catch (e) {
          print('❌ ForceUpdate check: $e');
        }

        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('ConstData', jsonEncode(value));
        } catch (e) {
          print('❌ save prefs: $e');
        }
      } else {
        // حظر حقيقي: banstatus موجودة وقيمتها مش 0
        Dialogs().showtoast('تم حظر هذا الحساب');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        navigateTo(context: context, screen: LoginScrean());
      }

      notifyListeners();
    });
    notifyListeners();
  }
  Future getReportImage( context) async {
    await userapi().getImageGalary().then((value) {
      Reportimage=null;
      Reportimage=value;
      notifyListeners();

    });

    notifyListeners();
  }
  updateComimage({image}){
    Comimage=image;
    notifyListeners();
  }
  Future ComtImage(context) async {
    await userapi().getImageGalary().then((value) {
      if(value!=null){
        Cropimage(value);
        print(value.runtimeType);
      }

      notifyListeners();
    });
    notifyListeners();
  }
  Future<void> Cropimage(value) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: value.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
      ],
    );

    if (croppedFile != null) {
      Comimage = File(croppedFile.path);
      notifyListeners();
    }
  }
  Future getEdittImage(context) async {
    await userapi().getImageGalary().then((value) {
      Edimage=null;
      Edimage=value;
      notifyListeners();
    });
    notifyListeners();
  }
  Future getImageGalary(kind,context) async {
    await userapi().getImageGalary().then((value) {
      Signupimage=null;
      if(value!=null){
        Signupimage=value;
      }



    });
    if(kind==null){
      
    }else{
     
      updatephoto(context: context,avatar: Avatarlink,token: Token,photo:Signupimage );
    }
    notifyListeners();
  }
  Future getImageAvatar({link, kind, context}) async {
    Signupimage = null;
    Avatarlink = link;
    if(kind==null){
     
    }else{
   
      updatephoto(context: context,avatar: Avatarlink,token: Token,photo:Signupimage );
    }
    notifyListeners();
  }
  checklogin(context)async{

    await userapi().checklogin(context);

  }
  checkuserkind({id,context}){
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);

    if(id.toString()==user.userinfo?.id.toString()){
      return true;
    }else{
      return false;
    }
  }
  selectginder() {
    gender = !gender;
    print(gender);
    notifyListeners();
  }
  selectage({day, month, year}) {
    Selectedday = day.toString();
    Selectedmonth = month.toString();
    Selectedyear = year.toString();
    notifyListeners();
  }
  Future<void> Signout({required BuildContext context}) async {
    showSpinner10();

    try {
      final value = await userapi().SignOut(context: context);

      if (value == true) {
        // تسجيل الخروج من Google
        try {
          final googleSignIn = GoogleSignIn.instance;
          await googleSignIn.signOut();
        } catch (e) {
          debugPrint('Google SignOut Error: $e');
        }

        // تسجيل الخروج من Firebase
        await _firebaseAuth.signOut();

        // تنظيف بيانات المستخدم
        LoginPhonenumber.clear();
        Code2 = null;

        day = 0;
        year = 0;
        month = 0;

        Name2 = null;
        Comimage = null;

        // الانتقال إلى شاشة Login
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppConstants.Login_Screan,
                (route) => false,
          );

          Dialogs().showtoast(
            getLang(
              context: NavigationService.navigatorKey.currentContext,
              key: "Done_Succ",
            ),
          );
        }
      } else {
        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: "Sorry",
          ),
        );
      }
    } catch (e) {
      debugPrint('Signout Error: $e');

      Dialogs().showtoast(
        getLang(
          context: NavigationService.navigatorKey.currentContext,
          key: "Sorry",
        ),
      );
    } finally {
      hideSpinner10();
      notifyListeners();
    }
  }

  RegesterNewUser({context}) async {
    SmartDialog.showLoading( );
    await userapi().RegesterNewUser(context: context,image: Comimage,year:year,month:month ,day:day,name:UsernameComp,city:Name2 ,Flag: Flag2,ginder:ginder ,phone_number: Code+LoginPhonenumber.text).then((value) {
      if(value.id!=null){
      userinfo=value;

       }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

      }
      SmartDialog.dismiss();
    });

    notifyListeners();
  }

  Future<void> RegesterNewUser2({required BuildContext context}) async {
    SmartDialog.showLoading();

    try {
      final value = await userapi().RegesterNewUser2(
        password: PasswordComp,
        context: context,
        image: Comimage,
        year: year,
        month: month,
        day: day,
        name: UsernameComp,
        city: Name2,
        Flag: Flag2,
        ginder: ginder,
      );

      if (value.id != null) {
        userinfo = value;
      }
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');

      print('ERROR MESSAGE TO DISPLAY: $message');

      Dialogs().showtoast(message);
    } finally {
      SmartDialog.dismiss();
    }

    notifyListeners();
  }

  // Future<User?> signInWithFacebook({context}) async {
  //   final fb = FacebookLogin();
  //   final response = await fb.logIn();
  //   if (response.status == FacebookLoginStatus.success) {
  //     final accessToken = response.accessToken;
  //     final userCredential = await _firebaseAuth.signInWithCredential(
  //       FacebookAuthProvider.credential(accessToken!.token),
  //     );
  //     print(userCredential.user?.uid);
  //    // Provider.of<LoginViewmodel>(context,listen: false).UserSocialRegester(context: context, uuid:userCredential.user?.uid,social: "1");
  //     return userCredential.user;
  //   } else if (response.status == FacebookLoginStatus.cancel) {
  //
  //     throw FirebaseAuthException(
  //       code: 'ERROR_ABORTED_BY_USER',
  //       message: 'Sign in aborted by user_repositores',
  //     );
  //   } else if (response.status == FacebookLoginStatus.error) {
  //
  //     throw FirebaseAuthException(
  //       code: 'ERROR_FACEBOOK_LOGIN_FAILED',
  //       message: response.error?.developerMessage,
  //     );
  //   } else {
  //     throw UnimplementedError();
  //   }
  // }



}
