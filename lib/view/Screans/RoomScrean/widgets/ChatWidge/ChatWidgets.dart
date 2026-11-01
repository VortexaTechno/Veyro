
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/MainScreans/MessageScrean/MessageScrean.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/MusicPlayer.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/emoji/emojisscrean.dart';
import 'package:ahlachat/view/widgets/Entertainment.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/InboxRooms_Viewmodel/InboxRoomsViewmodel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../GiftBox/GiftBox.dart';
class ChatWidgets extends StatelessWidget {
  const ChatWidgets({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=   Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    AgoraViewmodel Agora= Provider.of<AgoraViewmodel>(context,listen: true);
    var wait=5;
    return  Padding(
      padding: const EdgeInsets.only(bottom: 7,left: 5),
      child: Container(width: SizeConfig.screenWidth!,color: Colors.transparent,child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(onTap:(){
            Provider.of<InboxroomViewModel>(context,listen: false).GetInboxroom(context: context);
            showModalBottomSheet(backgroundColor: Colors.white,isScrollControlled: false, barrierColor:Colors.black.withAlpha(1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )),
              context: context,
              builder: (context) {
                return  MessageScrean();
              },
            );

            user.changeNewmessage(false);
          },
            child: Image.asset('assets/image/ic_room_msg.png',height:35 ),
          ),
           SizedBox(width: 10,) ,
          // InkWell(onTap: (){
          //   showModalBottomSheet(barrierColor:Colors.transparent,backgroundColor:  Colors.white ,shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight:Radius.circular(10), )),
          //     context: context,
          //     builder: (context) {
          //       return Entertainment();
          //     },
          //   );
          //
          // },child: Image.asset(Images.entertainment,height:35)),
          if(JoinChairs)    if(Room.checkadmin(context: context)||(Room.Currentroom?.supervisorsId?.contains(user.userinfo?.id.toString())??false))       InkWell(onTap: (){
            showModalBottomSheet(barrierColor:Colors.transparent,  backgroundColor: Colors.black,elevation: 0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )),
              context: context,
              builder: (context) {
                return const MusicPlayerRoom();
              },
            );
          },child: Image.asset('assets/image/ic_more_icon_music.png',height:35)),

          Spacer(),
          const GiftBox(),


          Spacer(),
          SizedBox(width: 12,) ,
          if(JoinChairs)  Padding(
            padding: const EdgeInsets.symmetric(horizontal:3),
            child: InkWell(onTap: () {


              if(Agora.muted==true&&Room.checkmute()){
                Room.Changemicestateadmin(userId:UserId ,state: 0 );
                Agora.UnMute();
                Room.updatemute(context: context,state: 0,user_id: UserId);
              }else{

                Room.Changemicestateadmin(userId:UserId,state: 1 );
                Room.updatemute(context: context,state: 1,user_id: UserId);
                Agora.Mute();

              }


            }, child: Image.asset(!Agora.muted?'assets/image/icon_room_open_mic.png':'assets/image/icon_room_close_mic.png',height: 35, )),
          ),
          SizedBox(width: 12,) ,
          if(JoinChairs)   InkWell(onTap: (){
            showModalBottomSheet(barrierColor:Colors.transparent,backgroundColor:  Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )),
              context: context,
              builder: (context) {
                return const EmojiTabBar();
              },
            );

          },child: Image.asset(Images.imoje,height: 35 )),

          SizedBox(width: 12,) ,

          InkWell(onTap: () {
            Room.ChairsRoom.clear();
            Room.ChairMaps.clear();
            Room.ClearMentionid();
            Room.Currentroom?.chairs?.forEach((element) {
              if(element.userId!=null&&element.userId.toString()!=user.userinfo?.id.toString()&&element.user!=null){
                Room.ChairMaps.add({
                  'id': element.user?.id.toString(),
                  'display': element.user?.name,
                  'full_name': element.user?.image,
                },);

              }
            });
            Room.showSpinner7();
          },child: Container(
            decoration: BoxDecoration(color:whitecolor2.withOpacity(0.3),borderRadius: BorderRadius.circular(15) ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 2),

              child: Text('Say Hi',style: TextStyle(color:whitecolor2,)),
            ),

          )),

        ],
      ),),
    );
  }
}
