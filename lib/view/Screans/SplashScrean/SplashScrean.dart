import 'dart:convert';

import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/view/Screans/Authentication/LoginScrean/LoginScrean.dart';
import 'package:ahlachat/view/Screans/Layouts/NavBar.dart';
import 'package:ahlachat/view/Screans/StartBanner/StartBannerScrean.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Language_Viewmodel/LanguageViewmodel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScrean extends StatefulWidget {
  const SplashScrean({Key? key}) : super(key: key);

  @override
  State<SplashScrean> createState() => _SplashScreanState();
}

class _SplashScreanState extends State<SplashScrean> {
  bool _sessionCheckStarted = false;
  bool _sessionCheckCompleted = false;

  Future<void> checklanguage() async {
    final prefs = await SharedPreferences.getInstance();

    Lang = prefs.getString('Lang');

    debugPrint('language: $Lang');

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> checkemulator() async {
    if (kReleaseMode) {
      final runningOnEmulator = await isRunningOnEmulator();

      if (runningOnEmulator) {
        SystemNavigator.pop();
      }
    }
  }

  Future<bool> isRunningOnEmulator() async {
    try {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;

      return deviceInfo.model.toLowerCase().contains('sdk') ||
          deviceInfo.model.toLowerCase().contains('emulator') ||
          !deviceInfo.isPhysicalDevice;
    } on PlatformException {
      return true;
    }
  }

  Future<void> checkConnectitivy() async {
    if (_sessionCheckStarted) return;

    _sessionCheckStarted = true;

    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (!mounted) return;

      final isConnected =
          connectivityResult.contains(ConnectivityResult.mobile) ||
              connectivityResult.contains(ConnectivityResult.wifi) ||
              connectivityResult.contains(ConnectivityResult.ethernet);

      if (!isConnected) {
        _sessionCheckStarted = false;

        Dialogs().showtoast('Internet is offline');

        Navigator.pushNamed(
          context,
          AppConstants.InternetConnection_Screan,
        );

        return;
      }

      await Helper().ids();
      Helper().checkVersion();

      if (!mounted) return;

      await checklogin();

      if (!mounted) return;

      await Provider.of<LoginViewmodel>(
        context,
        listen: false,
      ).getAllconstant(context);
    } catch (e, stackTrace) {
      debugPrint('CONNECTIVITY CHECK ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      _sessionCheckStarted = false;
    }
  }

  Future<void> checklogin() async {
    final userState = Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString('token');
      final dataUser = prefs.getString('UserData');

      debugPrint(
        'SPLASH TOKEN EXISTS: '
            '${token != null && token.trim().isNotEmpty}',
      );

      debugPrint(
        'SPLASH USER DATA EXISTS: '
            '${dataUser != null && dataUser.isNotEmpty}',
      );

      if (token == null ||
          token.trim().isEmpty ||
          dataUser == null ||
          dataUser.isEmpty) {
        userState.UpdateCurrentPage(LoginScrean());
        _sessionCheckCompleted = true;
        return;
      }

      final decoded = jsonDecode(dataUser);

      if (decoded is! Map) {
        await prefs.remove('token');
        await prefs.remove('UserData');

        userState.UpdateCurrentPage(LoginScrean());
        _sessionCheckCompleted = true;
        return;
      }

      final userData = Map<String, dynamic>.from(decoded);
      final user = usermodel.fromJson(userData);

      if (user.id == null) {
        await prefs.remove('token');
        await prefs.remove('UserData');

        userState.UpdateCurrentPage(LoginScrean());
        _sessionCheckCompleted = true;
        return;
      }

      UserId = user.id.toString();

      userState.MyUSERINFO(user);

      userState.waitingConstDate(context);

      if (!mounted) return;

      if (user.StarterBanner != null) {
        userState.UpdateCurrentPage(StartBannerScrean());
      } else {
        userState.UpdateCurrentPage(ButtomNavigation());
      }

      _sessionCheckCompleted = true;
    } catch (e, stackTrace) {
      debugPrint('SPLASH LOGIN ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      userState.UpdateCurrentPage(LoginScrean());
      _sessionCheckCompleted = true;
    }
  }

  @override
  void initState() {
    super.initState();

    FlutterNativeSplash.remove();

    checkemulator();
    checklanguage();
    checkConnectitivy();
    getIPAddress();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final userState = Provider.of<LoginViewmodel>(
      context,
      listen: true,
    );

    if (!_sessionCheckCompleted) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return userState.CurrentBage;
  }
}
