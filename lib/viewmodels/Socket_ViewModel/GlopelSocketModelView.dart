import 'dart:convert';
import 'dart:developer';
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/models/gifts.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:ahlachat/models/Usermodel.dart';

PusherChannelsFlutter Glopalpusher = PusherChannelsFlutter.getInstance();
class GlopelViewmodel extends ChangeNotifier{

  pusherinit()async{
    await Glopalpusher.init(
        apiKey: "8fa13ab9035fe6dc3f9a",
        cluster: "mt1",
      onConnectionStateChange: (current, previous) {
        print('🔗 PUSHER STATE: $previous → $current');
      },
      onError: (message, code, error) {
        print('❌ PUSHER ERROR: $message | code: $code | $error');
      },
      onSubscriptionSucceeded: (channel, data) {
        print('✅ SUBSCRIBED: $channel | $data');
      },
      onSubscriptionError: (message, error) {
        print('❌ SUBSCRIPTION ERROR: $message | $error');
      },
      onEvent: (event) {
        print('🌐 GLOBAL EVENT: ${event.channelName} | ${event.eventName} | ${event.data}');
      },
    );
    await Glopalpusher.connect();

  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {


    if(currentState=='RECONNECTING'){
      Dialogs().showtoast('Internet is offline');
      SystemNavigator.pop();
    }
  }

  Future ConnectGlopalScocket( context)async {
    Glopalpusher.subscribe( channelName: UserId.toString());
    Glopalpusher.subscribe(channelName: 'Gigo',onEvent: (e){



      degisenMenu(data:jsonDecode(e.data),state:jsonDecode(e.data)['state']);

    });


    notifyListeners();
  }

  Future DisConnect( )async{
    Glopalpusher.unsubscribe( channelName: 'Gigo',);
    notifyListeners();
  }

  degisenMenu({data,state, index}) async{
    switch (state) {
      case 0:
        usermodel sender=usermodel.fromJson(data['data']['Sender']);
        usermodel Reciver=usermodel.fromJson(data['data']['Reciver']);
        Gift giftinfo=Gift.fromJson(data['data']['gift']);
        Provider.of<GiftsViewModel>(roomcontext,listen: false).GitGlopalGiftData(reciver:Reciver,sender: sender,gift: giftinfo,Quantati:data['data']['Quantati'],Room_id: data['data']['Roomid'],state:0,Roomname:data['data']['Room_name']  );
        break;
      case 1:
        usermodel sender=usermodel.fromJson(data['data']['Sender']);
        Gift giftinfo=Gift.fromJson(data['data']['gift']);
        Provider.of<GiftsViewModel>(roomcontext,listen: false).GitGlopalGiftData(reciver:sender,sender: sender,gift: giftinfo,Quantati:data['data']['Quantati'],Room_id: data['data']['Roomid'] ,state:1 ,Roomname:data['data']['Room_name'] );
        break;
      case 2:

        usermodel sender=usermodel.fromJson(data['data']['Sender']);
        usermodel Reciver=usermodel.fromJson(data['data']['Reciver']);
        Gift giftinfo=Gift.fromJson(data['data']['gift']);
      //  Provider.of<GiftsViewModel>(roomcontext,listen: false).GitGlopalLuckyData(reciver:Reciver,sender: sender,gift: giftinfo,Quantati:data['data']['Quantati'].toString(),Room_id: data['data']['Roomid'],state:0,Roomname:data['data']['Room_name']  );
        break;
      case 3:

        usermodel user=usermodel.fromJson(data['data']['user']);
        RoomModel Room=RoomModel.fromJson(data['data']['room']);

        Provider.of<GiftsViewModel>(roomcontext,listen: false).GitGlopalLuckyData(  sender: user,Room: Room,Room_id:Room.id,state:0,Roomname:Room.name  );
      if(Room.id==Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.id){
        SmartDialog.showLoading(
          builder: (context) => Container(width: 250,height: 250,decoration: BoxDecoration(borderRadius: BorderRadius.circular(15) ,),child: Lottie.asset(
              'assets/image/1844-timer.json',  repeat: false,reverse: false, frameRate: FrameRate.max,animate: true  ),  ),
        );
      }


        break;
      default:

    }
  }




}