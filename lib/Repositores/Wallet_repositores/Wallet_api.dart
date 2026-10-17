
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../models/PayPalPackage.dart';
import '../../util/app_constants.dart';

class PurchasaApi {
  static const String _apiKey = 'goog_QbGwYjyXlePJXAYCANAMIAAbvsh';

  final List<PayPalPackage> PayPalPackages = [];

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.BASE_URL,
      headers: {
        'Accept': 'application/json',
        'Connection': 'Keep-Alive',
        'Authorization': Token,
        'awqeASERQW': '8/325*mAIOEN',
        'userid': UserId.toString(),
        'UserIP': UserIP,
      },
    ),
  );

  // Initialize RevenueCat
  static Future<void> init() async {
    print('========== REVENUECAT INIT ==========');

    try {
      await Purchases.setDebugLogsEnabled(true);
      await Purchases.setup(_apiKey);

      print('REVENUECAT INITIALIZED SUCCESSFULLY');
    } on PlatformException catch (e, stackTrace) {
      print('REVENUECAT INIT ERROR');
      print('CODE: ${e.code}');
      print('MESSAGE: ${e.message}');
      print('DETAILS: ${e.details}');
      print('STACK TRACE: $stackTrace');
      rethrow;
    } catch (e, stackTrace) {
      print('UNEXPECTED INIT ERROR: $e');
      print('STACK TRACE: $stackTrace');
      rethrow;
    }

    print('=====================================');
  }

  // Fetch RevenueCat Offerings
  static Future<List<Offering>> fetchoffers() async {
    print('========== REVENUECAT OFFERS ==========');

    try {
      await Purchases.setAttributes({
        'id': UserId.toString(),
      });

      print('USER ID: $UserId');
      print('Fetching offerings...');

      final Offerings offerings = await Purchases.getOfferings();

      print('ALL OFFERINGS: ${offerings.all}');

      final Offering? current = offerings.current;

      if (current == null) {
        print('NO CURRENT OFFERING FOUND');
        print('Check your RevenueCat Offering configuration.');
        print('======================================');

        return [];
      }

      print('CURRENT OFFERING: $current');
      print('OFFERING IDENTIFIER: ${current.identifier}');
      print('AVAILABLE PACKAGES COUNT: '
          '${current.availablePackages.length}');

      for (final Package package in current.availablePackages) {
        print('--------------------------------------');
        print('PACKAGE IDENTIFIER: ${package.identifier}');
        print('PACKAGE TYPE: ${package.packageType}');
        print('STORE PRODUCT: ${package.storeProduct}');
        print('PRODUCT IDENTIFIER: '
            '${package.storeProduct.identifier}');
        print('PRODUCT TITLE: ${package.storeProduct.title}');
        print('PRODUCT PRICE: ${package.storeProduct.price}');
      }

      print('========== OFFERS COMPLETED ==========');

      return [current];
    } on PlatformException catch (e, stackTrace) {
      print('========== REVENUECAT ERROR ==========');
      print('ERROR CODE: ${e.code}');
      print('ERROR MESSAGE: ${e.message}');
      print('ERROR DETAILS: ${e.details}');
      print('STACK TRACE: $stackTrace');
      print('======================================');

      return [];
    } catch (e, stackTrace) {
      print('UNEXPECTED REVENUECAT ERROR: $e');
      print('STACK TRACE: $stackTrace');

      return [];
    }
  }

  // Purchase RevenueCat Package
  static Future<bool> purchesPackage(Package package) async {
    print('========== PURCHASE PACKAGE ==========');
    print('PACKAGE IDENTIFIER: ${package.identifier}');
    print('PRODUCT: ${package.storeProduct}');

    try {
      final PurchaseResult customerInfo =
      await Purchases.purchasePackage(package);

      print('PURCHASE SUCCESS');
      print('CUSTOMER INFO: $customerInfo');
      print('======================================');

      return true;
    } on PlatformException catch (e, stackTrace) {
      print('========== PURCHASE ERROR ==========');
      print('ERROR CODE: ${e.code}');
      print('ERROR MESSAGE: ${e.message}');
      print('ERROR DETAILS: ${e.details}');
      print('STACK TRACE: $stackTrace');
      print('====================================');

      return false;
    } catch (e, stackTrace) {
      print('UNEXPECTED PURCHASE ERROR: $e');
      print('STACK TRACE: $stackTrace');

      return false;
    }
  }
}
