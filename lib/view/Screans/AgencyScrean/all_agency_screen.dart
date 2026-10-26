import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/viewmodels/Agency_ViewModel/Agency_ViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../MainScreans/ProfileScrean/MyagencyProfile.dart';

const Color _green = Colors.green;
final Color _greenLight = Colors.green.shade100;

class AllAgenciesScrean extends StatefulWidget {
  const AllAgenciesScrean({super.key});

  @override
  State<AllAgenciesScrean> createState() => _AllAgenciesScreanState();
}

class _AllAgenciesScreanState extends State<AllAgenciesScrean> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
    // GetAgency بتنادي notifyListeners فلازم بعد أول frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AagencyViewModel>(context, listen: false)
          .GetAgency(context: context);
    });
  }

  void _scrollListener() {
    final agency = Provider.of<AagencyViewModel>(context, listen: false);
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 20 &&
        !agency.showloading2) {
      agency.GetMoreAgency(context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final agency = Provider.of<AagencyViewModel>(context, listen: true);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_green, Colors.white],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        title: const Text(
          "الوكالات",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      extendBodyBehindAppBar: false,
      body: RefreshIndicator(
        color: _green,
        onRefresh: () async => agency.GetAgency(context: context),
        child: agency.showloading && agency.Agences.isEmpty
            ? const Center(child: CircularProgressIndicator(color: _green))
            : agency.Agences.isEmpty
            ? ListView(
          children: const [
            SizedBox(height: 200),
            Center(child: Text("لا توجد وكالات")),
          ],
        )
            : ListView.builder(
          controller: _controller,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
              horizontal: 15, vertical: 10),
          itemCount: agency.Agences.length + 1,
          itemBuilder: (context, index) {
            if (index == agency.Agences.length) {
              // لودينج أسفل القائمة (pagination)
              return agency.showloading2
                  ? const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                    child: CircularProgressIndicator(
                        color: _green)),
              )
                  : const SizedBox(height: 20);
            }
            return _AgencyItem(
              item: agency.Agences[index],
              onTap: () {
                agency.GetAgencyinfo(
                    info: agency.Agences[index], context: context);
                navigateTo(
                    context: context, screen: MyAgencyScrean());
              },
            );
          },
        ),
      ),
    );
  }
}

class _AgencyItem extends StatelessWidget {
  final dynamic item; // Agencymodel
  final VoidCallback onTap;

  const _AgencyItem({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final int? kind = item.agencyKind;
    final bool canJoin = kind == 0 || kind == 2; // نفس منطق MyAgencyScrean
    final bool canSell = kind == 1 || kind == 2;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // الصورة
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 85,
                  width: 85,
                  color: Colors.grey.shade200,
                  child: (item.image ?? '').toString().isEmpty
                      ? const Icon(Icons.groups, color: _green, size: 40)
                      : Image(
                    image: CachedNetworkImageProvider(item.image),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                        Icons.groups,
                        color: _green,
                        size: 40),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // البيانات
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: '${item.appid ?? ''}'));
                            Dialogs().showtoast('تم النسخ');
                          },
                          child: Icon(Icons.copy,
                              size: 20, color: Colors.grey.shade600),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Id : ${item.appid ?? ''}",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text("${item.userNumber ?? 0}",
                            style: const TextStyle(color: _green)),
                        const SizedBox(width: 4),
                        const Icon(Icons.group, size: 18, color: _green),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                                color: _greenLight,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              item.user?.name ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black87),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // الأيقونات على اليسار
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (canJoin)
                    const Icon(Icons.group, color: _green, size: 26),
                  if (canSell)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.monetization_on_outlined,
                          color: _green, size: 28),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}