import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/dimensions.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../../models/Chatroom.dart';
import '../../../../../viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import '../../../RolletUserScrean/RolletUserScrean.dart';

class EmojiTabBar extends StatelessWidget {
  const EmojiTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GiftsViewModel gits = Provider.of<GiftsViewModel>(context, listen: true);
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    RoomViewmodel Room = Provider.of<RoomViewmodel>(context, listen: true);

    return Container(
        height: SizeConfig.screenHeight! / 2.7,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
            color: Colors.white),
        child: DefaultTabController(
          length: user.emojisCategory.length,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              TabBar(
                  indicatorColor: MainColor,
                  labelColor: MainColor,
                  unselectedLabelColor: Colors.black54,
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  automaticIndicatorColorAdjustment: true,
                  tabs: List.generate(
                    user.emojisCategory.length,
                    (index) => Tab(
                      child: CachedNetworkImage(
                          imageUrl: user.emojisCategory[index].name ?? '',
                          height: 25),
                    ),
                  )),
              Expanded(
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: List.generate(user.emojisCategory.length, (index) {
                    // فلترة مرة واحدة
                    final list = (user.emojisCategory[index].emoji ?? [])
                        .where((e) => (e.image ?? '').isNotEmpty)
                        .toList();

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 0.8,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                        ),
                        itemCount: list.length,
                        itemBuilder: (ctx, i) {
                          final emoji = list[i];
                          return InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Room.SentEmoji(context: context, emoji: emoji.image);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: emoji.image!,
                                  height: 50,
                                  errorWidget: (_, __, ___) =>
                                  const Icon(Icons.broken_image, color: Colors.grey),
                                ),
                                Text(
                                  emoji.emojiName ?? '',
                                  style: style4.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ));
  }
}
