import 'dart:io';

import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/Screans/Layouts/widgets/AnimateAddRoom.dart';
import 'package:ahlachat/view/Screans/MainScreans/MainScrean/ExploreScrean.dart';
import 'package:ahlachat/view/Screans/MainScreans/MainScrean/RoomFollowScrean.dart';
import 'package:ahlachat/view/Screans/SearchScrean/SearchScrean.dart';
import 'package:ahlachat/view/widgets/ModelSheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../../../util/Dialogs.dart';
import '../../../../../util/Localization.dart';
import '../../../../../util/app_constants.dart';
import '../../../../../util/dimensions.dart';
import '../../../../../util/images.dart';
import '../../../../../util/styles.dart';
import '../../../../../viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import '../../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../../../../viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import '../../../../../viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import '../../../../../viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import '../../../MomentScrean/MomentScrean.dart';
import '../NewRoomsScrean.dart';
import '../TrendScrean.dart';

class MainScrean extends StatefulWidget {
  MainScrean({Key? key}) : super(key: key);

  @override
  State<MainScrean> createState() => _MainScreanState();
}

class _MainScreanState extends State<MainScrean>
    with SingleTickerProviderStateMixin {
  Future printIps() async {
    for (var interface in await NetworkInterface.list()) {
      print('== Interface: ${interface.name} ==');
      Dialogs().showtoast(interface.addresses.length.toString());
      for (var addr in interface.addresses) {
        print(
            '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name} ${addr.isMulticast}');
      }
    }
  }

  TabController? Tabcontroller;

  @override
  void initState() {
    super.initState();
    Tabcontroller = TabController(vsync: this, length: 2);

    Tabcontroller?.addListener(() {
      print(Tabcontroller?.index);
      if (Tabcontroller?.index == 2) {
        Provider.of<RoomViewmodel>(context, listen: false)
            .GetNewRoom(context: context);
      } else if (Tabcontroller?.index == 0) {
        Provider.of<RoomViewmodel>(context, listen: false)
            .GetFollowingUserRoom(context);

        Provider.of<RoomViewmodel>(context, listen: false)
            .GetRecommendedRoom(context);
      } else if (Tabcontroller?.index == 3) {
        Provider.of<RoomViewmodel>(context, listen: false)
            .GetExploreRoom(context);
        Provider.of<RoomViewmodel>(context, listen: false)
            .GetCountries(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room = Provider.of<RoomViewmodel>(context, listen: true);
    RoomViewmodel Rooms = Provider.of<RoomViewmodel>(context, listen: true);
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    SvgViewmodel svga = Provider.of<SvgViewmodel>(context, listen: true);
    RoomPlayViewModel RoomPlay =
        Provider.of<RoomPlayViewModel>(context, listen: true);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Builder(builder: (context) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TabBar(
                      indicator: MaterialIndicator(
                        color: MainColor,
                        height: 5,
                        topLeftRadius: 0,
                        topRightRadius: 0,
                        bottomLeftRadius: 5,
                        horizontalPadding: 10,
                        bottomRightRadius: 5,
                        tabPosition: TabPosition.bottom,
                      ),
                      isScrollable: true,
                      controller: Tabcontroller,
                      labelStyle: style2.copyWith(height: 1, fontSize: 16),
                      unselectedLabelColor: Colors.black45,
                      labelColor: Colors.black,
                      onTap: (val) {
                        print(val);
                        if (val == 1) {
                          Room.GetNewRoom(context: context);
                        }
                      },
                      tabs: [
                        Tab(
                          text: getLang(context: context, key: "Trind"),
                        ),
                        Tab(
                          text: getLang(context: context, key: "New"),
                        ),
                      ]),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Image.asset(Images.SearchIcon, height: 25),
                      onPressed: () {
                        Room.SearchController.clear();
                        Room.SearchRooms.clear();
                        navigateTo(context: context, screen: SearchScrean());
                      },
                    ),
                    IconButton(
                      icon: Image.asset(Images.RoomIcon, height: 40),
                      onPressed: () {
                        if (Room.LeaveLoading == true) {
                          Dialogs().showtoast('رجاء انتظر ترك الغرفه');
                        } else {
                          if (user.userinfo?.currentroom != null) {
                            Room.EnterRoom(
                                id: user.userinfo?.currentroom?.id,
                                context: context,
                                adminId: user.userinfo?.id);
                          } else {
                            if (RoomPlay.HasRoom == true) {
                              Dialogs().showtoast(getLang(
                                  context: context, key: "Another_Room"));
                            } else {
                              GlopalbottomSheet(
                                  isscrollable: true,
                                  context: context,
                                  Screan: AddRoomScrean());
                            }
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
        body: TabBarView(
          controller: Tabcontroller,
          children: [
            TrendScrean(),
            NewRoomsScrean(),

            //  MomentScrean(),
          ],
        ),
      ),
    );
  }
}
