import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/features/alert/pages/alert_create_edit_page.dart';
import 'package:immoplus/app/features/alert/pages/alert_list_page.dart';
import 'package:immoplus/app/features/alert/pages/alert_success_page.dart';
import 'package:immoplus/app/features/for_me/favorite_page.dart';
import 'package:immoplus/app/features/immo_relais/pages/relais_marketplace_page.dart';
import 'package:immoplus/app/features/immo_relais/pages/relais_my_interests_page.dart';
import 'package:immoplus/app/features/immo_relais/pages/relais_my_page.dart';
import 'package:immoplus/app/features/immo_relais/pages/relais_received_interests_page.dart';
import 'package:immoplus/app/features/immo_relais/pages/report_relais_step1_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class MyChoicePage extends StatefulWidget {
  const MyChoicePage({super.key});
  static const String routePath = '/for_me';
  static const String name = 'MyChoicePage';

  @override
  State<MyChoicePage> createState() => _MyChoicePageState();
}

class _MyChoicePageState extends State<MyChoicePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Imatch',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: const Color(0xFF2548E5), // Blue from screenshots
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[500],
                  labelStyle: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Je déménage'),
                    Tab(text: 'J’emménage'),
                    Tab(text: 'Mes favoris'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _MovingHub(),
                  AlertListPage(embedded: true),
                  FavoritePage(embedded: true),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: switch (_tabController.index) {
        0 => FloatingActionButton(
            onPressed: _createNewRelaisRequest,
            backgroundColor: AppColors.primary,
            shape: const CircleBorder(),
            elevation: 0,
            child: const Icon(Icons.add, color: Colors.white, size: 32),
          ),
        1 => FloatingActionButton(
            onPressed: _createNewAlert,
            backgroundColor: AppColors.primary,
            shape: const CircleBorder(),
            elevation: 0,
            child: const Icon(Icons.add, color: Colors.white, size: 32),
          ),
        _ => null,
      },
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
    color: const Color(0xFF2548E5),
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
            itemBuilder: (context, index) => _MovingHubCard(item: _movingHubItems[index]),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7E6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.25)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Iconsax.lamp_charge, color: Color(0xFFF59E0B), size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Vous déménagez ? On vous aide à trouver vite votre nouveau logement, avec des bonus à la clé.",
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
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
              style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              item.subtitle,
              style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey.shade600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
