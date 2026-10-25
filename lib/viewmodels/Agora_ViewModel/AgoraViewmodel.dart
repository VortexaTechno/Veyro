import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../util/app_constants.dart';
import '../Auth_Viewmodel/LoginViewModel.dart';
import '../Music_Viewmodel/MusicViewmodel.dart';
import '../Room_Viewmodel/Room_Viewmodel.dart';

class AgoraViewmodel extends ChangeNotifier {
  /// Agora App ID
  static const String APP_ID =
      '2d1320fdea0940e58ff09f630e47d9a8';

  bool muted = true;

  bool KickedFromChair = false;

  bool disableAudio = false;

  bool playmusic = false;

  bool Rebeate = false;

  RtcEngine? _engine;
  bool _initializing = false;
  bool _handlersRegistered = false;
  bool _disposed = false;
  String? _joinedChannel;

  List usersuid = [];

  List PlaySong = [];

  List<Map> userjoin = [];

  List speakerids = [];

  List UserIDS = [];

  int index = 0;

  int userjoindid = 0;

  int speakeruid = 0;

  int volumnaudio = 50;

  double initialValue = 0.0;

  // ============================================================
  // GENERAL
  // ============================================================

  void ChangeRepeate(state) {
    Rebeate = state;
    notifyListeners();
  }

  void updateKickedFromChair({value}) {
    KickedFromChair = value;
    notifyListeners();
  }

  // ============================================================
  // AGORA INITIALIZATION
  // ============================================================

  Future<void> initialize({
    ClientRoleType? role,
    required String Token,
    required String channelName,
  }) async {
    if (_initializing || _disposed) {
      debugPrint('[AGORA] Initialization already running or disposed');
      return;
    }

    _initializing = true;
    try {
      print('');
      print('========================================');
      print('🎙️ AGORA INITIALIZE');
      print('========================================');
      print('🎙️ APP ID: $APP_ID');
      print(
        '🎙️ TOKEN: '
            '${Token.isEmpty ? "EMPTY ❌" : "RECEIVED ✅"}',
      );
      print('🎙️ TOKEN LENGTH: ${Token.length}');
      print('🎙️ CHANNEL: $channelName');
      print('🎙️ USER ID: $UserId');
      print('🎙️ ROLE: $role');
      print('========================================');

      // --------------------------------------------------------
      // Validate token
      // --------------------------------------------------------

      if (Token.trim().isEmpty) {
        print('❌ AGORA ERROR: Token is EMPTY');
        return;
      }

      if (channelName.trim().isEmpty) {
        print('❌ AGORA ERROR: Channel name is EMPTY');
        return;
      }

      if (UserId == null || UserId!.trim().isEmpty) {
        print('❌ AGORA ERROR: UserId is EMPTY');
        return;
      }

      final int uid = int.parse(UserId!);

      // --------------------------------------------------------
      // If old engine exists, leave it before creating a new one
      // --------------------------------------------------------

      // Reuse the existing engine instead of destroying it
// every time the user enters a room.
      if (_engine != null && _joinedChannel != null) {
        debugPrint('[AGORA] Leaving previous channel');

        await _engine!.leaveChannel();
        _joinedChannel = null;

        debugPrint('[AGORA] Previous channel left');
      }

      // --------------------------------------------------------
      // Initialize Agora engine
      // --------------------------------------------------------

      await _initAgoraRtcEngine(
        role: role,
      );
      if (!_handlersRegistered) {
        _addAgoraEventHandlers();
        _handlersRegistered = true;
      }
      // --------------------------------------------------------
      // Register events
      // --------------------------------------------------------

      final ClientRoleType currentRole =
          role ?? ClientRoleType.clientRoleAudience;

      final bool isBroadcaster =
          currentRole == ClientRoleType.clientRoleBroadcaster;

      // --------------------------------------------------------
      // Set local mute state
      // --------------------------------------------------------

      if (isBroadcaster) {
        muted = false;
      } else {
        muted = true;
      }

      // --------------------------------------------------------
      // Agora channel options
      // --------------------------------------------------------

      final ChannelMediaOptions options =
      ChannelMediaOptions(
        clientRoleType: currentRole,

        channelProfile:
        ChannelProfileType.channelProfileLiveBroadcasting,

        // Broadcaster publishes microphone.
        publishMicrophoneTrack: isBroadcaster,

        // This application is audio room only.
        publishCameraTrack: false,

        // Audience must automatically receive remote audio.
        autoSubscribeAudio: true,

        // No video needed.
        autoSubscribeVideo: false,
      );

      print('');
      print('🚀 AGORA JOIN CHANNEL');
      print('➡️ CHANNEL: $channelName');
      print('➡️ UID: $uid');
      print('➡️ ROLE: $currentRole');
      print(
        '➡️ PUBLISH MIC: '
            '${options.publishMicrophoneTrack}',
      );
      print('➡️ AUTO SUBSCRIBE AUDIO: true');
      print('➡️ AUTO SUBSCRIBE VIDEO: false');
      print(
        '➡️ TOKEN PREVIEW: '
            '${Token.substring(
          0,
          Token.length > 15 ? 15 : Token.length,
        )}...',
      );
      print('');

      // --------------------------------------------------------
      // Join Agora channel
      // --------------------------------------------------------

      await _engine!.joinChannel(
        token: Token,
        channelId: channelName,
        uid: uid,
        options: options,
      );
      _joinedChannel = channelName;
      print('✅ AGORA JOIN REQUEST SENT');
      print('========================================');
      print('');

      notifyListeners();
    } catch (e, stackTrace) {
      print('');
      print('========================================');
      print('❌ AGORA INITIALIZE/JOIN ERROR');
      print('========================================');
      print('ERROR: $e');
      print('STACKTRACE: $stackTrace');
      print('========================================');

      // Don't rethrow here because this method is called from
      // room navigation and we don't want to crash the app.
    }
    finally {
      _initializing = false;
    }
  }

  // ============================================================
  // AGORA ENGINE
  // ============================================================

  Future<void> _initAgoraRtcEngine({
    ClientRoleType? role,
  }) async {
    try {
      print('🔧 Creating Agora engine...');
      if (_engine != null) {
        debugPrint('[AGORA] Reusing existing engine');
        return;
      }
      _engine = createAgoraRtcEngine();

      await _engine!.initialize(
        const RtcEngineContext(
          appId: APP_ID,
        ),
      );

      print('✅ Agora engine initialized');

      // --------------------------------------------------------
      // Enable audio
      // --------------------------------------------------------

      await _engine!.enableAudio();

      print('✅ Agora audio enabled');

      // --------------------------------------------------------
      // Live broadcasting profile
      // --------------------------------------------------------

      await _engine!.setChannelProfile(
        ChannelProfileType.channelProfileLiveBroadcasting,
      );

      print('✅ Agora channel profile set');

      // --------------------------------------------------------
      // Enable audio volume indication
      // Used for speaker indicators.
      // --------------------------------------------------------

      await _engine!.enableAudioVolumeIndication(
        interval: 250,
        smooth: 3,
        reportVad: true,
      );

      print('✅ Audio volume indication enabled');

      // --------------------------------------------------------
      // Set initial role
      // --------------------------------------------------------

      if (role != null) {
        await _engine!.setClientRole(
          role: role,
        );

        print('✅ Initial role set: $role');
      }

      // --------------------------------------------------------
      // Initial microphone state
      // --------------------------------------------------------

      if (role == ClientRoleType.clientRoleBroadcaster) {
        muted = false;

        await _engine!.muteLocalAudioStream(
         false,
        );

        await _engine!.adjustRecordingSignalVolume(
          400,
        );

        print('🎤 Initial role = BROADCASTER');
        print('🎤 Microphone enabled');
      } else {
        muted = true;

        print('👂 Initial role = AUDIENCE');
        print('👂 Microphone publishing disabled');
      }

      notifyListeners();
    } catch (e, stackTrace) {
      print('❌ AGORA ENGINE INITIALIZATION ERROR');
      print('ERROR: $e');
      print('STACKTRACE: $stackTrace');

      rethrow;
    }
  }

  // ============================================================
  // END AGORA
  // ============================================================

  Future<void> EndAgora() async {
    final engine = _engine;

    muted = true;

    usersuid.clear();
    userjoin.clear();
    speakerids.clear();
    UserIDS.clear();

    if (engine != null && _joinedChannel != null) {
      try {
        await engine.leaveChannel();
        debugPrint('[AGORA] Channel left successfully');
      } catch (e) {
        debugPrint('[AGORA] leaveChannel error: $e');
      } finally {
        _joinedChannel = null;
      }
    }

    if (!_disposed) {
      notifyListeners();
    }
  }

  // ============================================================
  // AUDIO ROOM ENABLE / DISABLE
  // ============================================================

  void disableAudioroomvoice() {
    disableAudio = false;

    playmusic = false;

    PlaySong.clear();

    notifyListeners();
  }

  Future<void> closeroomvoice() async {
    try {
      await _engine?.disableAudio();

      disableAudio = true;

      print('🔇 ROOM AUDIO DISABLED');

      notifyListeners();
    } catch (e) {
      print('❌ closeroomvoice ERROR: $e');
    }
  }

  Future<void> enableroomvoice() async {
    try {
      await _engine?.enableAudio();

      disableAudio = false;

      print('🔊 ROOM AUDIO ENABLED');

      notifyListeners();
    } catch (e) {
      print('❌ enableroomvoice ERROR: $e');
    }
  }

  // ============================================================
  // BROADCASTER / AUDIENCE
  // ============================================================

  Future<void> SetasBroadcaster() async {
    try {
      print('');
      print('🎤 SWITCHING TO BROADCASTER');

      if (_engine == null) {
        print('❌ Agora engine is NULL');
        return;
      }

      // Change role first.
      await _engine!.setClientRole(
        role: ClientRoleType.clientRoleBroadcaster,
      );

      print('✅ Client role = BROADCASTER');

      // Enable microphone publishing.
      await _engine!.muteLocalAudioStream(
         false,
      );

      print('🎤 Local microphone UNMUTED');

      // Set microphone volume.
      await _engine!.adjustRecordingSignalVolume(
        400,
      );

      muted = false;

      print('🎤 Microphone volume = 400');
      print('🎤 BROADCASTER READY');

      notifyListeners();
    } catch (e, stackTrace) {
      print('❌ SetasBroadcaster ERROR');
      print('ERROR: $e');
      print('STACKTRACE: $stackTrace');
    }
  }

  Future<void> SetasAudience() async {
    try {
      print('');
      print('👂 SWITCHING TO AUDIENCE');

      if (_engine == null) {
        print('❌ Agora engine is NULL');
        return;
      }

      // Stop publishing local microphone.
      await _engine!.muteLocalAudioStream(
         true,
      );

      // Change role.
      await _engine!.setClientRole(
        role: ClientRoleType.clientRoleAudience,
      );

      muted = true;

      print('🔇 Local microphone publishing disabled');
      print('👂 Client role = AUDIENCE');

      notifyListeners();
    } catch (e, stackTrace) {
      print('❌ SetasAudience ERROR');
      print('ERROR: $e');
      print('STACKTRACE: $stackTrace');
    }
  }

  // ============================================================
  // MUTE LOCAL MICROPHONE
  // ============================================================

  Future<void> Mute() async {
    try {
      print('');
      print('🔇 MUTE LOCAL MICROPHONE');

      if (_engine == null) {
        print('❌ Agora engine is NULL');
        return;
      }

      await _engine!.muteLocalAudioStream(
         true,
      );

      muted = true;

      print('✅ LOCAL MICROPHONE MUTED');

      notifyListeners();
    } catch (e, stackTrace) {
      print('❌ Mute ERROR');
      print('ERROR: $e');
      print('STACKTRACE: $stackTrace');
    }
  }

  // ============================================================
  // UNMUTE LOCAL MICROPHONE
  // ============================================================

  Future<void> UnMute() async {
    try {
      print('');
      print('🎤 UNMUTE LOCAL MICROPHONE');

      if (_engine == null) {
        print('❌ Agora engine is NULL');
        return;
      }

      // User needs broadcaster role to publish microphone.
      await _engine!.setClientRole(
        role: ClientRoleType.clientRoleBroadcaster,
      );

      print('✅ Client role = BROADCASTER');

      // Enable local microphone publishing.
      await _engine!.muteLocalAudioStream(
         false,
      );

      print('🎤 Local microphone UNMUTED');

      await _engine!.adjustRecordingSignalVolume(
        400,
      );

      muted = false;

      print('🎤 Recording volume = 400');
      print('✅ LOCAL MICROPHONE READY');

      notifyListeners();
    } catch (e, stackTrace) {
      print('❌ UnMute ERROR');
      print('ERROR: $e');
      print('STACKTRACE: $stackTrace');
    }
  }

  // ============================================================
  // KICKED FROM CHAIR
  // ============================================================

  Future<void> keickedfromasAudience() async {
    try {
      muted = true;

      JoinChairs = false;
      KickedFromChair = false;

      if (_engine != null) {
        await _engine!.muteLocalAudioStream(
        true,
        );

        await _engine!.setClientRole(
          role: ClientRoleType.clientRoleAudience,
        );
      }

      print('👢 User moved to AUDIENCE');

      notifyListeners();
    } catch (e) {
      print('❌ keickedfromasAudience ERROR: $e');
    }
  }

  // ============================================================
  // REMOTE USER AUDIO
  // ============================================================

  Future<void> unmuteusermic(uid) async {
    try {
      print('🔊 UNMUTE REMOTE USER: $uid');

      await _engine?.muteRemoteAudioStream(
        uid: uid,
        mute: false,
      );

      print('✅ Remote user $uid audio enabled');

      notifyListeners();
    } catch (e) {
      print('❌ unmuteusermic ERROR: $e');
    }
  }

  Future<void> muteusermic(uid) async {
    try {
      print('🔇 MUTE REMOTE USER: $uid');

      await _engine?.muteRemoteAudioStream(
        uid: uid,
        mute: true,
      );

      print('✅ Remote user $uid audio muted');

      notifyListeners();
    } catch (e) {
      print('❌ muteusermic ERROR: $e');
    }
  }

  Future<void> xxxxx(uid) async {
    try {
      await _engine?.muteRemoteAudioStream(
        uid: uid,
        mute: true,
      );

      notifyListeners();
    } catch (e) {
      print('❌ xxxxx ERROR: $e');
    }
  }

  Future<void> mutebyuid({
    required uid,
    required context,
  }) async {
    try {
      final RoomViewmodel Room =
      Provider.of<RoomViewmodel>(
        context,
        listen: false,
      );

      if (Room.Mutedids.contains(uid)) {
        Room.Mutedids.remove(uid);

        await _engine?.muteRemoteAudioStream(
          uid: uid,
          mute: false,
        );

        print('🔊 REMOTE USER $uid UNMUTED');
      } else {
        Room.Mutedids.add(uid);

        await _engine?.muteRemoteAudioStream(
          uid: uid,
          mute: true,
        );

        print('🔇 REMOTE USER $uid MUTED');
      }

      notifyListeners();
    } catch (e) {
      print('❌ mutebyuid ERROR: $e');
    }
  }

  // ============================================================
  // AUDIO MIXING / MUSIC
  // ============================================================

  Future<void> StartAudioMexing({
    required String filePath,
    required int duration,
    required String tittle,
    required int indexsong,
  }) async {
    try {
      PlaySong.clear();

      playmusic = true;

      index = indexsong;

      PlaySong.add(tittle);

      await _engine?.startAudioMixing(
        filePath: filePath,
        loopback: false,
        cycle: -1,
      );

      print('🎵 Audio mixing started: $filePath');

      notifyListeners();
    } catch (e) {
      print('❌ StartAudioMexing ERROR: $e');
    }
  }

  Future<void> next(context) async {
    try {
      final MusicViewModel music =
      Provider.of<MusicViewModel>(
        context,
        listen: false,
      );

      if (music.SongsList.length == index + 1) {
        Dialogs().showtoast('لا يوجد اغاني اخري');
      } else {
        PlaySong.clear();

        playmusic = true;

        PlaySong.add(
          music.SongsList[index + 1].displayName,
        );

        await _engine?.startAudioMixing(
          filePath: music.SongsList[index + 1].data,
          loopback: false,
          cycle: -1,
        );

        music.play(
          music.SongsList[index + 1].data,
        );

        index = index + 1;
      }

      notifyListeners();
    } catch (e) {
      print('❌ next ERROR: $e');
    }
  }

  Future<void> last(context) async {
    try {
      final MusicViewModel music =
      Provider.of<MusicViewModel>(
        context,
        listen: false,
      );

      print(index + 1);
      print(music.SongsList.length);

      if (index <= 0) {
        Dialogs().showtoast('لا يوجد اغاني سابقة');
      } else {
        PlaySong.clear();

        playmusic = true;

        PlaySong.add(
          music.SongsList[index - 1].displayName,
        );

        await _engine?.startAudioMixing(
          filePath: music.SongsList[index - 1].data,
          loopback: false,
          cycle: -1,
        );

        music.play(
          music.SongsList[index - 1].data,
        );

        index = index - 1;
      }

      notifyListeners();
    } catch (e) {
      print('❌ last ERROR: $e');
    }
  }

  Future<void> setaudiovolum(int volum) async {
    try {
      volumnaudio = volum;

      await _engine?.adjustAudioMixingVolume(
        volum,
      );

      notifyListeners();
    } catch (e) {
      print('❌ setaudiovolum ERROR: $e');
    }
  }

  void volumnausdio(int volum) {
    volumnaudio = volum;

    notifyListeners();
  }

  Future<void> stopAudioMexing(context) async {
    try {
      playmusic = false;

      final MusicViewModel music =
      Provider.of<MusicViewModel>(
        context,
        listen: false,
      );

      await _engine?.pauseAudioMixing();

      music.player.pause();

      notifyListeners();
    } catch (e) {
      print('❌ stopAudioMexing ERROR: $e');
    }
  }

  Future<void> resumAudioMexing(context) async {
    try {
      final MusicViewModel music =
      Provider.of<MusicViewModel>(
        context,
        listen: false,
      );

      playmusic = true;

      await _engine?.resumeAudioMixing();

      music.player.play();

      notifyListeners();
    } catch (e) {
      print('❌ resumAudioMexing ERROR: $e');
    }
  }

  Future<void> pauseAudioMixing() async {
    try {
      await _engine?.pauseAudioMixing();

      notifyListeners();
    } catch (e) {
      print('❌ pauseAudioMixing ERROR: $e');
    }
  }

  Future<void> resumeAudioMixing() async {
    try {
      await _engine?.resumeAudioMixing();

      notifyListeners();
    } catch (e) {
      print('❌ resumeAudioMixing ERROR: $e');
    }
  }

  Future<void> setAudioMixingPosition(
      int duration,
      ) async {
    try {
      await _engine?.setAudioMixingPosition(
        duration,
      );

      notifyListeners();
    } catch (e) {
      print('❌ setAudioMixingPosition ERROR: $e');
    }
  }

  // ============================================================
  // AUDIO EVENT HANDLERS
  // ============================================================

  void _addAgoraEventHandlers() {
    _engine?.registerEventHandler(
      RtcEngineEventHandler(
        // ------------------------------------------------------
        // ERROR
        // ------------------------------------------------------

        onError: (
            ErrorCodeType err,
            String msg,
            ) {
          print('');
          print('❌❌❌ AGORA ERROR ❌❌❌');
          print('ERROR CODE: $err');
          print('MESSAGE: $msg');
          print('');
        },

        // ------------------------------------------------------
        // JOIN SUCCESS
        // ------------------------------------------------------

        onJoinChannelSuccess: (
            RtcConnection connection,
            int elapsed,
            ) {
          userjoindid =
              connection.localUid ?? 0;

          print('');
          print('========================================');
          print('✅ AGORA JOIN SUCCESS');
          print('CHANNEL: ${connection.channelId}');
          print('LOCAL UID: ${connection.localUid}');
          print('ELAPSED: $elapsed');
          print('========================================');
          print('');

          notifyListeners();
        },

        // ------------------------------------------------------
        // LEAVE
        // ------------------------------------------------------

        onLeaveChannel: (
            RtcConnection connection,
            RtcStats stats,
            ) {
          print('');
          print('🚪 AGORA LEAVE CHANNEL');
          print('CHANNEL: ${connection.channelId}');
          print('');

          usersuid.clear();
          userjoin.clear();
          speakerids.clear();

          notifyListeners();
        },

        // ------------------------------------------------------
        // REMOTE USER JOINED
        // ------------------------------------------------------

        onUserJoined: (
            RtcConnection connection,
            int uid,
            int elapsed,
            ) {
          print('');
          print('========================================');
          print('👤 REMOTE USER JOINED');
          print('REMOTE UID: $uid');
          print('CHANNEL: ${connection.channelId}');
          print('========================================');
          print('');

          if (!usersuid.contains(uid)) {
            usersuid.add(uid);
          }

          final bool alreadyExists =
          userjoin.any(
                (element) =>
            element['uid'] == uid,
          );

          if (!alreadyExists) {
            userjoin.add({
              'userid': userjoindid,
              'uid': uid,
            });
          }

          // Make sure remote audio is subscribed.
          _engine?.muteRemoteAudioStream(
            uid: uid,
            mute: false,
          );

          notifyListeners();
        },

        // ------------------------------------------------------
        // REMOTE USER LEFT
        // ------------------------------------------------------

        onUserOffline: (
            RtcConnection connection,
            int uid,
            UserOfflineReasonType reason,
            ) {
          print('');
          print('👤 REMOTE USER OFFLINE');
          print('UID: $uid');
          print('REASON: $reason');
          print('');

          usersuid.remove(uid);

          userjoin.removeWhere(
                (element) =>
            element['uid'] == uid,
          );

          speakerids.removeWhere(
                (element) =>
            element['uid'] == uid,
          );

          notifyListeners();
        },

        // ------------------------------------------------------
        // REMOTE AUDIO STATE
        // ------------------------------------------------------

        onRemoteAudioStateChanged: (
            RtcConnection connection,
            int remoteUid,
            RemoteAudioState state,
            RemoteAudioStateReason reason,
            int elapsed,
            ) {
          print('');
          print('🔊🔊🔊 REMOTE AUDIO STATE 🔊🔊🔊');
          print('REMOTE UID: $remoteUid');
          print('AUDIO STATE: $state');
          print('AUDIO REASON: $reason');
          print('ELAPSED: $elapsed');
          print('CHANNEL: ${connection.channelId}');
          print('');

          notifyListeners();
        },

        // ------------------------------------------------------
        // LOCAL AUDIO STATE
        // ------------------------------------------------------

        onLocalAudioStateChanged: (
            RtcConnection connection,
            LocalAudioStreamState state,
            LocalAudioStreamReason reason,
            ) {
          print('');
          print('🎤 LOCAL AUDIO STATE');
          print('STATE: $state');
          print('REASON: $reason');
          print('');
        },

        // ------------------------------------------------------
        // AUDIO VOLUME
        // ------------------------------------------------------

        onAudioVolumeIndication: (
            RtcConnection connection,
            List<AudioVolumeInfo> volumeInfo,
            int totalVolume,
            int totalRemoteVolume,
            ) {
          DateTime _lastVolumeUiUpdate = DateTime.fromMillisecondsSinceEpoch(0);
          for (final speaker in volumeInfo) {
            final int volume =
                speaker.volume ?? 0;

            if (volume > 70) {
              if (speaker.uid != 0) {
                speakerids.add({
                  'uid': speaker.uid,
                  'time': DateTime.now(),
                });
              }

              print(
                '🔊 SPEAKING UID: '
                    '${speaker.uid} '
                    'VOLUME: $volume',
              );
            }
          }

          // Remove old speaking users.
          for (final item
          in List.from(speakerids)) {
            final DateTime? time =
            item['time'];

            if (time != null &&
                DateTime.now()
                    .difference(time)
                    .inSeconds >
                    2) {
              speakerids.remove(item);
            }
          }
          final now = DateTime.now();

          if (now.difference(_lastVolumeUiUpdate).inMilliseconds >= 500) {
            _lastVolumeUiUpdate = now;
            notifyListeners();
          }
        },
      ),
    );

    print('✅ Agora event handlers registered');
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _disposed = true;
    unawaited(_releaseAgoraEngine());
    super.dispose();
  }

  Future<void> _releaseAgoraEngine() async {
    final engine = _engine;

    // Prevent any further use of this engine.
    _engine = null;
    _joinedChannel = null;

    if (engine == null) return;

    try {
      await engine.leaveChannel();
    } catch (e) {
      debugPrint('[AGORA] leaveChannel during dispose: $e');
    }

    try {
      await engine.release();
      debugPrint('[AGORA] Engine released');
    } catch (e) {
      debugPrint('[AGORA] release during dispose: $e');
    }
  }
}