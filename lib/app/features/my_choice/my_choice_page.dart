import 'package:flutter/material.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_module_status_response.dart';
import 'package:immoplus/app/data/repositories/relais_repository.dart';
import 'package:immoplus/app/features/alert/pages/alert_create_edit_page.dart';
import 'package:immoplus/app/features/alert/pages/alert_list_page.dart';
import 'package:immoplus/app/features/alert/pages/alert_success_page.dart';
import 'package:immoplus/app/features/for_me/favorite_page.dart';
import 'package:immoplus/app/features/immo_relais/pages/relais_marketplace_page.dart';
import 'package:immoplus/app/features/immo_relais/pages/relais_my_interests_page.dart';
import 'package:immoplus/app/features/immo_relais/pages/relais_my_page.dart';
import 'package:immoplus/app/features/immo_relais/pages/relais_received_interests_page.dart';
import 'package:immoplus/app/features/immo_relais/pages/report_relais_step1_page.dart';
import 'package:immoplus/app/widgets/above_nav_bar_fab_location.dart';

class MyChoicePage extends StatefulWidget {
  const MyChoicePage({super.key});
  static const String routePath = '/for_me';
  static const String name = 'MyChoicePage';

  @override
  State<MyChoicePage> createState() => _MyChoicePageState();
}

class _MyChoicePageState extends State<MyChoicePage> {
  late Future<RelaisModuleStatusResponse> _moduleStatusFuture;

  @override
  void initState() {
    super.initState();
    _moduleStatusFuture =
        getIt<RelaisRepository>().getModuleStatus().catchError(
      (e) {
        debugPrint('Relais module status check failed: $e');
        return const RelaisModuleStatusResponse(active: true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RelaisModuleStatusResponse>(
      future: _moduleStatusFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              title: Text('Imatch'),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.immoBorderDefault,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final isRelaisActive = snapshot.data?.active ?? true;
        return _MyChoiceContentView(isRelaisActive: isRelaisActive);
      },
    );
  }
}

class _MyChoiceContentView extends StatefulWidget {
  final bool isRelaisActive;
  const _MyChoiceContentView({required this.isRelaisActive});

  @override
  State<_MyChoiceContentView> createState() => _MyChoiceContentViewState();
}

class _MyChoiceContentViewState extends State<_MyChoiceContentView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.isRelaisActive ? 3 : 2,
      vsync: this,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _createNewRelaisRequest() async {
    await context.pushNamed(ReportRelaisStep1Page.name);
  }

  Future<void> _createNewAlert() async {
    final result = await context.pushNamed(AlertCreateEditPage.name);
    if (result == true && mounted) {
      await context.pushNamed(AlertSuccessPage.name);
    }
  }

  Widget? _buildFloatingActionButton() {
    if (widget.isRelaisActive) {
      return switch (_tabController.index) {
        0 => FloatingActionButton(
            onPressed: _createNewRelaisRequest,
            backgroundColor: AppColors.primary,
            shape: const CircleBorder(),
            elevation: 0,
            child: const Icon(Icons.add, color: AppColors.white, size: 32),
          ),
        1 => FloatingActionButton(
            onPressed: _createNewAlert,
            backgroundColor: AppColors.primary,
            shape: const CircleBorder(),
            elevation: 0,
            child: const Icon(Icons.add, color: AppColors.white, size: 32),
          ),
        _ => null,
      };
    } else {
      return switch (_tabController.index) {
        0 => FloatingActionButton(
            onPressed: _createNewAlert,
            backgroundColor: AppColors.primary,
            shape: const CircleBorder(),
            elevation: 0,
            child: const Icon(Icons.add, color: AppColors.white, size: 32),
          ),
        _ => null,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text('Imatch'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.immoBorderDefault,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: AppColors.white,
                  unselectedLabelColor: AppColors.immoTextSecondary,
                  labelStyle: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  dividerColor: AppColors.transparent,
                  tabs: [
                    if (widget.isRelaisActive) Tab(text: 'Je déménage'),
                    Tab(text: 'J’emménage'),
                    Tab(text: 'Mes favoris'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  if (widget.isRelaisActive) const _MovingHub(),
                  const AlertListPage(embedded: true),
                  const FavoritePage(embedded: true),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: AboveNavBarFabLocation.endFloat,
    );
  }
}

class _MovingHubItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final void Function(BuildContext context) onTap;

  const _MovingHubItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

final List<_MovingHubItem> _movingHubItems = [
  _MovingHubItem(
    title: 'Pour moi',
    subtitle: 'Mes demandes publiées',
    icon: Iconsax.truck_fast,
    color: AppColors.blue550,
    onTap: (context) => context.pushNamed(RelaisMyPage.name),
  ),
  _MovingHubItem(
    title: 'Autour de moi',
    subtitle: 'Logements disponibles',
    icon: Iconsax.global_search,
    color: const Color(0xFF00A389),
    onTap: (context) => context.pushNamed(RelaisMarketplacePage.name),
  ),
  _MovingHubItem(
    title: 'Mes intérêts',
    subtitle: 'Logements qui me plaisent',
    icon: Iconsax.heart,
    color: const Color(0xFFE5497B),
    onTap: (context) => context.pushNamed(RelaisMyInterestsPage.name),
  ),
  _MovingHubItem(
    title: 'Reçues',
    subtitle: 'Demandes reçues sur mes relais',
    icon: Iconsax.receive_square,
    color: const Color(0xFFFF9F43),
    onTap: (context) => context.pushNamed(RelaisReceivedInterestsPage.name),
  ),
];

/// Onglet "Je déménage" — hub bento : chaque carte ouvre une page dédiée
/// (Pour moi / Autour de moi / Mes intérêts / Reçues) au lieu de sous-onglets.
class _MovingHub extends StatelessWidget {
  const _MovingHub();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.95,
            ),
            itemCount: _movingHubItems.length,
            itemBuilder: (context, index) =>
                _MovingHubCard(item: _movingHubItems[index]),
          ),
          SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7E6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.immoFeedbackWarning.withValues(alpha: 0.25)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Iconsax.lamp_charge,
                    color: AppColors.immoFeedbackWarning, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Vous déménagez ? On vous aide à trouver vite votre nouveau logement, avec des bonus à la clé.",
                    style: AppTypography.font(
                      fontSize: 12,
                      color: AppColors.immoTextLabel,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _MovingHubCard extends StatelessWidget {
  final _MovingHubItem item;
  const _MovingHubCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => item.onTap(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.immoBorderDefault),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: item.color, size: 22),
            ),
            const Spacer(),
            Text(
              item.title,
              style:
                  AppTypography.font(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              item.subtitle,
              style: AppTypography.font(
                  fontSize: 12, color: AppColors.immoTextSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
