import 'dart:convert';

import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/view/Screans/Authentication/LoginScrean/LoginScrean.dart';
import 'package:ahlachat/view/Screans/Layouts/NavBar.dart';
import 'package:ahlachat/view/Screans/StartBanner/StartBannerScrean.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
        FlutterNativeSplash.remove(); // اشيل الـ splash عشان شاشة النت تظهر
        Dialogs().showtoast('Internet is offline');
        Navigator.pushNamed(context, AppConstants.InternetConnection_Screan);
        return;
      }

      await Helper().ids();
      Helper().checkVersion();
      if (!mounted) return;

      final userState = Provider.of<LoginViewmodel>(context, listen: false);
      await userState.getAllconstant(context);
      if (!mounted) return;

      await checklogin();
    } catch (e, stackTrace) {
      debugPrint('CONNECTIVITY CHECK ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);
      _sessionCheckStarted = false;
      FlutterNativeSplash.remove();
    }
  }

  Future<void> checklogin() async {
    final userState = Provider.of<LoginViewmodel>(context, listen: false);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final dataUser = prefs.getString('UserData');

      if (token == null ||
          token.trim().isEmpty ||
          dataUser == null ||
          dataUser.isEmpty) {
        _finish(userState, LoginScrean());
        return;
      }

      final decoded = jsonDecode(dataUser);
      if (decoded is! Map) {
        await prefs.remove('token');
        await prefs.remove('UserData');
        _finish(userState, LoginScrean());
        return;
      }

      final user = usermodel.fromJson(Map<String, dynamic>.from(decoded));
      if (user.id == null) {
        await prefs.remove('token');
        await prefs.remove('UserData');
        _finish(userState, LoginScrean());
        return;
      }

      UserId = user.id.toString();
      userState.MyUSERINFO(user);
      userState.waitingConstDate(context);

      if (!mounted) return;

      final banner = userState.StartBannerData;
      final hasBanner = banner != null &&
          banner.photo != null &&
          banner.photo!.isNotEmpty;

      if (!mounted) return;

// من غير precache: افتح الصفحة على طول
      _finish(userState, hasBanner ? StartBannerScrean() : ButtomNavigation());
    } catch (e, stackTrace) {
      debugPrint('SPLASH LOGIN ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      _finish(userState, LoginScrean());
    }
  }

  void _finish(LoginViewmodel userState, Widget page) {
    userState.UpdateCurrentPage(page);
    if (mounted) {
      setState(() => _sessionCheckCompleted = true);
    }
    // شيل الـ native splash بعد ما أول فريم للصفحة الجديدة يترسم
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  void initState() {
    super.initState();
    // ❌ شيلنا FlutterNativeSplash.remove() من هنا
    checkemulator();
    checklanguage();
    checkConnectitivy();
    getIPAddress();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final userState = Provider.of<LoginViewmodel>(context, listen: true);

    if (!_sessionCheckCompleted) {
      // نفس شكل الـ native splash عشان مايبقاش فيه فرق (مفيش loading)
      return Scaffold(
        backgroundColor: Colors.white, // خليها نفس لون الـ splash بتاعك
        body: Center(
          child: Image.asset(Images.logo, width: 180),
        ),
      );
    }

    return userState.CurrentBage;
  }
}
