
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../util/app_constants.dart';

class PurchasaApi {
  static const String _apiKey = 'goog_QbGwYjyXlePJXAYCANAMIAAbvsh';


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

      print('ALL OFFERING IDENTIFIERS: ${offerings.all.keys}');
      print('CURRENT OFFERING: ${offerings.current?.identifier}');

      // Use Current Offering first, otherwise fallback to "veyro".
      final Offering? selectedOffering =
          offerings.current ?? offerings.all['veyro'];

      if (selectedOffering == null) {
        print('ERROR: No Current Offering and "veyro" was not found.');
        print('Available offerings: ${offerings.all.keys}');
        print('======================================');

        return [];
      }

      print('SELECTED OFFERING: ${selectedOffering.identifier}');
      print(
        'AVAILABLE PACKAGES COUNT: '
            '${selectedOffering.availablePackages.length}',
      );

      for (final Package package in selectedOffering.availablePackages) {
        final StoreProduct product = package.storeProduct;

        print('--------------------------------------');
        print('PACKAGE IDENTIFIER: ${package.identifier}');
        print('PACKAGE TYPE: ${package.packageType}');
        print('PRODUCT IDENTIFIER: ${product.identifier}');
        print('PRODUCT TITLE: ${product.title}');
        print('PRODUCT DESCRIPTION: ${product.description}');
        print('PRODUCT PRICE: ${product.price}');
        print('PRODUCT PRICE STRING: ${product.priceString}');
      }

      print('========== OFFERS COMPLETED ==========');

      // Keep the existing return type: List<Offering>.
      return [selectedOffering];
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
