
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/UserChairs/ChairWidget.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/UserChairs/chairLockwidget.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';

class UserChair extends StatelessWidget {
  const UserChair({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final room = Provider.of<RoomViewmodel>(context);
    final user = Provider.of<LoginViewmodel>(context);
    final agora = Provider.of<AgoraViewmodel>(context);

    // كل الكراسي الراجعة من API
    final chairs = room.Currentroom?.chairs ?? [];

    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      cacheExtent: 15.6,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: chairs.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.05,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
      ),
      itemBuilder: (context, index) {
        final chair = chairs[index];

        final userId = int.tryParse(
          chair.userId?.toString() ?? '0',
        ) ?? 0;

        final hasUser = chair.userId != null;

        final isSpeaking = agora.speakerids.any(
              (element) => element['uid'] == userId,
        );

        final imogeList = user.imoge.where(
              (element) => element['uid'] == userId,
        );

        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // الكرسي المشغول
              if (hasUser)
                Align(
                  alignment: Alignment.center,
                  child: Chairwidget(index: index),
                ),

              // الكرسي الفارغ أو المقفول
              if (!hasUser)
                Align(
                  alignment: Alignment.center,
                  child: ChairLockwidget(index: index),
                ),

              // حالة المايك
              if (hasUser)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    bottom: 50,
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                      ),
                      child: CircleAvatar(
                        backgroundColor:
                        isSpeaking && chair.mute == 0
                            ? Colors.red
                            : Colors.white54,
                        radius: 10,
                        child: Icon(
                          chair.mute == 0
                              ? Icons.mic
                              : Icons.mic_off_outlined,
                          color: whitecolor,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ),

              // الإيموجي
              if (hasUser && imogeList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: SizedBox(
                    height: 80,
                    width: 80,
                    child: CachedNetworkImage(
                      imageUrl: imogeList.first['imoge'],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
