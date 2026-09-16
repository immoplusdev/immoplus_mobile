import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/features/immo_relais/pages/report_relais_step1_page.dart';
import 'package:immoplus/app/features/immo_relais/widgets/relais_my_section.dart';
import 'package:immoplus/app/utils/app_colors.dart';

/// Page dédiée "Pour moi" — mes relais publiés, ouverte depuis la carte
/// bento du hub "Je déménage".
class RelaisMyPage extends StatefulWidget {
  const RelaisMyPage({super.key});
  static const String name = 'RELAIS_MY_PAGE';
  static const String routePath = '/relais/my';

  @override
  State<RelaisMyPage> createState() => _RelaisMyPageState();
}

class _RelaisMyPageState extends State<RelaisMyPage> {
  final _refreshNotifier = ValueNotifier<int>(0);
  bool _hasRequests = false;

  @override
  void dispose() {
    _refreshNotifier.dispose();
    super.dispose();
  }

  Future<void> _createNewRequest() async {
    await context.pushNamed(ReportRelaisStep1Page.name);
    _refreshNotifier.value++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Pour moi'), centerTitle: true),
      body: RelaisMySection(
        refreshNotifier: _refreshNotifier,
        onRequestsLoaded: (hasRequests) {
          if (mounted) setState(() => _hasRequests = hasRequests);
        },
      ),
      floatingActionButton: _hasRequests
          ? FloatingActionButton(
              onPressed: _createNewRequest,
              backgroundColor: AppColors.primary,
              shape: const CircleBorder(),
              elevation: 0,
              child: const Icon(Icons.add, color: Colors.white, size: 32),
            )
          : null,
    );
  }
}
