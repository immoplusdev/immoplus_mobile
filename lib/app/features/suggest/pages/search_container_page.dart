import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/data/enums/home_tab.dart';
import 'package:immoplus/app/features/suggest/pages/suggest_page.dart';
import 'package:immoplus/app/features/suggest/pages/reverse_search_page.dart';

class SearchContainerPage extends StatefulWidget {
  final HomeTab? homeTab;
  final double? lat;
  final double? lng;

  const SearchContainerPage({
    super.key,
    this.homeTab,
    this.lat,
    this.lng,
  });

  static const String routeName = "search_container";
  static const String routePath = "/search_container";

  @override
  State<SearchContainerPage> createState() => _SearchContainerPageState();
}

class _SearchContainerPageState extends State<SearchContainerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Recherche'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
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
                    color: const Color(0xFF2548E5),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[500],
                  labelStyle: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Normale'),
                    Tab(text: 'Inversée'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics:
                    const NeverScrollableScrollPhysics(), // Evite les conflits de swipe avec les listes
                children: [
                  SuggestPage(
                    homeTab: widget.homeTab,
                    lat: widget.lat,
                    lng: widget.lng,
                  ),
                  const ReverseSearchPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
