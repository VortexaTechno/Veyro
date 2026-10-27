
import 'package:ahlachat/main.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../Repositores/Wallet_repositores/Wallet_api.dart';
import '../../models/PayPalPackage.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';

class WalletViewmodel extends ChangeNotifier {
  bool showloading = false;

  List<Package> packages = [];
  List<PayPalPackage> PayPalPackages = [];

  // Response information to display on the Wallet page
  String responseMessage = '';
  String responseData = '';
  int? responseStatusCode;
  bool? responseSuccess;

  void showSpinner() {
    showloading = true;
    notifyListeners();
  }

  void hiddeSpinner() {
    showloading = false;
    notifyListeners();
  }

  void clearResponse() {
    responseMessage = '';
    responseData = '';
    responseStatusCode = null;
    responseSuccess = null;
    notifyListeners();
  }

  void setResponse({
    required String message,
    String data = '',
    int? statusCode,
    required bool success,
  }) {
    responseMessage = message;
    responseData = data;
    responseStatusCode = statusCode;
    responseSuccess = success;

    print('========== WALLET RESPONSE ==========');
    print('SUCCESS: $responseSuccess');
    print('STATUS CODE: $responseStatusCode');
    print('MESSAGE: $responseMessage');
    print('DATA: $responseData');
    print('=====================================');

    notifyListeners();
  }

  // Fetch RevenueCat offerings

  static Future<List<Offering>> fetchoffers() async {
    debugPrint('========== REVENUECAT OFFERS ==========');

    try {
      debugPrint('USER ID: $UserId');
      debugPrint('Fetching RevenueCat offerings...');

      await Purchases.setAttributes({
        'id': UserId.toString(),
      });

      final Offerings offerings = await Purchases.getOfferings();

      debugPrint('ALL OFFERINGS: ${offerings.all.keys.toList()}');

      final Offering? current = offerings.current;

      if (current == null) {
        debugPrint('ERROR: CURRENT OFFERING IS NULL');
        debugPrint('Check RevenueCat dashboard configuration.');
        return [];
      }

      debugPrint('CURRENT OFFERING: ${current.identifier}');
      debugPrint('PACKAGES COUNT: ${current.availablePackages.length}');

      for (final package in current.availablePackages) {
        debugPrint('PACKAGE ID: ${package.identifier}');
        debugPrint('PRODUCT ID: ${package.storeProduct.identifier}');
        debugPrint('PRODUCT TITLE: ${package.storeProduct.title}');
        debugPrint('PRODUCT PRICE: ${package.storeProduct.priceString}');
      }

      return [current];
    } on PlatformException catch (e, stackTrace) {
      debugPrint('========== REVENUECAT PLATFORM ERROR ==========');
      debugPrint('CODE: ${e.code}');
      debugPrint('MESSAGE: ${e.message}');
      debugPrint('DETAILS: ${e.details}');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('========== REVENUECAT ERROR ==========');
      debugPrint('$e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> FeatchOffers() async {
    debugPrint('========== FETCH OFFERS STARTED ==========');

    showSpinner();

    try {
      final offerings = await PurchasaApi.fetchoffers();

      debugPrint('========== REVENUECAT OFFERS ==========');
      debugPrint('OFFERINGS COUNT: ${offerings.length}');

      for (final offering in offerings) {
        debugPrint('OFFERING ID: ${offering.identifier}');
        debugPrint(
          'AVAILABLE PACKAGES: ${offering.availablePackages.length}',
        );
      }

      packages = offerings
          .expand((offering) => offering.availablePackages)
          .toList();

      debugPrint('========== REVENUECAT PACKAGES ==========');
      debugPrint('PACKAGES COUNT: ${packages.length}');

      for (final package in packages) {
        debugPrint('PACKAGE ID: ${package.identifier}');
        debugPrint(
          'PRODUCT ID: ${package.storeProduct.identifier}',
        );
        debugPrint(
          'PRODUCT TITLE: ${package.storeProduct.title}',
        );
        debugPrint(
          'PRODUCT TYPE: ${package.storeProduct.productCategory}',
        );
        debugPrint(
          'PRICE: ${package.storeProduct.priceString}',
        );
      }

      if (packages.isEmpty) {
        setResponse(
          message: 'No Google Play packages available.',
          data: 'RevenueCat returned no available packages.',
          success: false,
        );
      } else {
        setResponse(
          message: 'Google Play packages loaded successfully.',
          data: 'Packages count: ${packages.length}',
          success: true,
        );
      }

      notifyListeners();
    } catch (e, stackTrace) {
      packages = [];

      debugPrint('========== FETCH OFFERS ERROR ==========');
      debugPrint('ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      setResponse(
        message: 'Failed to load Google Play packages.',
        data: e.toString(),
        success: false,
      );

      notifyListeners();
    } finally {
      hiddeSpinner();
    }
  }


  // Purchase package
  Future<void> purchasePackage({
    required Package Backage,
    dynamic context,
  }) async {
    showSpinner();

    try {
      print('WALLET: Purchasing ${Backage.identifier}');

      final bool state =
      await PurchasaApi.purchesPackage(Backage);

      if (state == false) {
        setResponse(
          message: 'Purchase failed. Check the error logs.',
          data: 'Package: ${Backage.identifier}',
          success: false,
        );

        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: 'Sorry',
          ),
        );
      } else {
        setResponse(
          message: 'Purchase completed successfully',
          data: 'Package: ${Backage.identifier}',
          success: true,
        );

        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: 'Done_Succ',
          ),
        );
      }
    } catch (e, stackTrace) {
      print('PURCHASE VIEWMODEL ERROR: $e');
      print(stackTrace);

      setResponse(
        message: 'Purchase exception',
        data: e.toString(),
        success: false,
      );
    } finally {
      hiddeSpinner();
    }
  }

}
