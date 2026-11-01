import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../util/app_constants.dart';
import '../../../../viewmodels/Games_ViewModel/Games_ViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ahlachat/util/styles.dart';





class GameScrean extends StatefulWidget {
  int index;
  GameScrean({required this.index});

  @override
  GameScreanState createState() => GameScreanState();
}

class GameScreanState extends State<GameScrean> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      GamesViewModel Games =
      Provider.of<GamesViewModel>(context, listen: false);

      Games.IncreamentGames(
        id: Games.GamesList[widget.index].id,
        index: widget.index,
      );
      if (Games.GamesList[widget.index].oriantation == 1) {
        Orintation();
      }
      final path = Games.GamesList[widget.index].path;
      if (path != null) {
        _controller.loadRequest(Uri.parse(_gameUrl(path)));
      }
    });

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  String _gameUrl(String link) {
    final encodedToken = Uri.encodeComponent(Token ?? '');
    if (encodedToken.isEmpty || link.contains('token=$encodedToken')) {
      return link;
    }
    if (link.endsWith('token=')) {
      return '$link$encodedToken';
    }
    return '$link${link.contains('?') ? '&' : '?'}token=$encodedToken';
  }

  Orintation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  UpOrintation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    GamesViewModel Games = Provider.of<GamesViewModel>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        if (Games.GamesList[widget.index].oriantation == 1) {
          UpOrintation();
        }
        return true;
      },
      child: Scaffold(
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}


/// The games picker displayed from inside a room.
/// Games are loaded only after the room-games button is pressed.
class RoomGamesSheet extends StatefulWidget {
  const RoomGamesSheet({super.key, required this.roomContext});

  final BuildContext roomContext;

  @override
  State<RoomGamesSheet> createState() => _RoomGamesSheetState();
}

class _RoomGamesSheetState extends State<RoomGamesSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GamesViewModel>().GetGames(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final games = context.watch<GamesViewModel>();
    return SafeArea(
      top: false,
      child: Container(
        height: MediaQuery.of(context).size.height * .52,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text('الألعاب', style: style2.copyWith(fontSize: 16)),
            const SizedBox(height: 12),
            Expanded(
              child: games.showloading
                  ? const Center(child: CircularProgressIndicator())
                  : games.GamesList.isEmpty
                  ? const Center(child: Text('لا توجد ألعاب متاحة الآن'))
                  : GridView.builder(
                itemCount: games.GamesList.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 12,
                  childAspectRatio: .78,
                ),
                itemBuilder: (context, index) {
                  final game = games.GamesList[index];
                  return InkWell(
                   // borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(widget.roomContext).push(
                        MaterialPageRoute(
                          builder: (_) => GameScrean(index: index),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: CachedNetworkImage(
                              imageUrl: game.image ?? '',
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => const Center(
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              ),
                              errorWidget: (_, __, ___) => const Icon(
                                Icons.sports_esports_rounded,
                                size: 42,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          game.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: style2.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}




