import 'package:ahlachat/util/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Wallet_ViewModel/Wallet_ViewModel.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/models/store_product_wrapper.dart';

class RechargeScrean extends StatefulWidget {
  const RechargeScrean({super.key});

  @override
  State<RechargeScrean> createState() => _RechargeScreanState();
}

class _RechargeScreanState extends State<RechargeScrean> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final wallet = Provider.of<WalletViewmodel>(
        context,
        listen: false,
      );

      debugPrint('========== RECHARGE SCREEN OPENED ==========');
      debugPrint('Starting Google Play / RevenueCat request...');

      wallet.FeatchOffers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wallet = Provider.of<WalletViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: whitecolor,
        centerTitle: true,
        title: Text(
          getLang(context: context, key: 'Recharge'),
          style: style6.copyWith(fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Google Pay',
                    style: style6.copyWith(fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/image/Google.png.png',
                    height: 20,
                    width: 20,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (wallet.showloading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (wallet.packages.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.shopping_bag_outlined,
                              size: 45,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No Google Play packages available.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                debugPrint(
                                  'Retrying RevenueCat offerings request...',
                                );
                                wallet.FeatchOffers();
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: wallet.packages.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final package = wallet.packages[index];
                      final StoreProduct product = package.storeProduct;

                      return InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          debugPrint(
                            '========== GOOGLE PLAY PACKAGE SELECTED ==========',
                          );
                          debugPrint('Package ID: ${package.identifier}');
                          debugPrint('Product ID: ${product.identifier}');
                          debugPrint('Price: ${product.priceString}');

                          wallet.purchasePackage(
                            Backage: package,
                            context: context,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFC0C1C4).withOpacity(0.4),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                Images.coins,
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${product.description} '
                                  '${getLang(context: context, key: "Coins")}',
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: Text(
                                  product.priceString,
                                  style: style3.copyWith(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
