import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
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
  TabController? _tabController;
  late final bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    final sessionManager = getIt<SessionManager>();
    _isLoggedIn = sessionManager.currentUser != null;
    if (_isLoggedIn) {
      _tabController = TabController(length: 2, vsync: this);
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return SuggestPage(
        homeTab: widget.homeTab,
        lat: widget.lat,
        lng: widget.lng,
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          physics:
              const NeverScrollableScrollPhysics(), // Evite les conflits de swipe avec les listes
          children: [
            ReverseSearchPage(
              tabBar: _buildTabBar(),
            ),
            SuggestPage(
              homeTab: widget.homeTab,
              lat: widget.lat,
              lng: widget.lng,
              tabBar: _buildTabBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    // Rule 4: 8px-based vertical rhythm (16px top = 2×8, 16px bottom = 2×8)
    // Rule 2: 16px top creates clear visual separation from the search bar above
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(25),
        ),
        child: TabBar(
          controller: _tabController,
          // Rule 3: isScrollable false ensures equal-width tabs (flex: 1 equivalent)
          isScrollable: false,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: const Color(0xFF2548E5),
            borderRadius: BorderRadius.circular(25),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[500],
          // Rule 5: identical fontWeight in both states prevents micro-shift
          // on toggle — the active state is distinguished solely by the
          // indicator pill background, not by text width changes.
          labelStyle: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          dividerColor: Colors.transparent,
          labelPadding: EdgeInsets.zero, // Rule 3: no extra padding asymmetry
          tabs: const [
            Tab(text: 'On cherche pour toi'),
            Tab(text: 'Tu cherches'),
          ],
        ),
      ),
    );
  }
}
