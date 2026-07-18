import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/enums/home_tab.dart';
import 'package:immoplus/app/data/models/remote/suggest/suggestion_model.dart';
import 'package:immoplus/app/features/estate_detail/estate_page.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/features/suggest/pages/search_result_page.dart';
import 'package:immoplus/app/features/suggest/logic/suggest_cubit.dart';
import 'package:immoplus/app/features/suggest/logic/suggest_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/features/suggest/pages/components/suggestion_tile.dart';
import 'package:immoplus/app/features/suggest/pages/components/suggest_search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';

import 'package:immoplus/app/features/suggest/pages/components/search_history_tile.dart';
import 'package:immoplus/app/features/suggest/pages/components/recommendation_for_you_tile.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/models/local/search_history_item.dart';
import 'package:immoplus/app/utils/connectivity_mixin.dart';
import 'package:gap/gap.dart';

class SuggestPage extends StatefulWidget {
  final HomeTab? homeTab;
  final double? lat;
  final double? lng;

  const SuggestPage({
    super.key,
    this.homeTab,
    this.lat,
    this.lng,
  });

  static const String routeName = "suggest";
  static const String routePath = "/suggest";

  @override
  State<SuggestPage> createState() => _SuggestPageState();
}

class _SuggestPageState extends State<SuggestPage> with ConnectivityMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showClearButton = false;
  late final SuggestCubit _cubit;

  List<SearchHistoryItem> _allHistory = [];
  List<SearchHistoryItem> get _searchHistory {
    final cat = widget.homeTab?.category ?? '';
    return _allHistory.where((e) => e.category == cat).toList();
  }

  bool _isLoadingRecommendations = true;
  List<dynamic> _recommendedItems = [];
  bool _showAllHistory = false;

  @override
  void onConnectionRestored() {
    final state = _cubit.state;
    state.maybeWhen(
      error: (_) => _onSearchTextChanged(),
      orElse: () {},
    );
  }

  @override
  void initState() {
    super.initState();
    _cubit = getIt<SuggestCubit>();
    _searchController.addListener(_onSearchTextChanged);
    setupConnectivityListener();

    _loadInitialData();

    // Auto focus on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final list = prefs.getStringList('suggest_history_objects') ?? [];
      try {
        _allHistory = list.map((e) => SearchHistoryItem.fromJson(e)).toList();
      } catch (e) {
        _allHistory = [];
      }
    });

    try {
      if (widget.homeTab == HomeTab.residence) {
        final res = await getIt<ResidenceRepository>().getResidences(
            page: 1,
            perPage: 5,
            where: {"_where": '{"_field":"score","_op":"eq","_val":100}'});
        _recommendedItems = res.data?.cast<dynamic>() ?? [];
      } else {
        final res = await getIt<BienImmobilierRepository>().getBiensImmobiliers(
            page: 1,
            perPage: 5,
            where: {"_where": '{"_field":"score","_op":"eq","_val":100}'});
        _recommendedItems = res.data?.cast<dynamic>() ?? [];
      }
    } catch (e) {
      // Ignorer silencieusement pour l'instant
    }

    if (mounted) {
      setState(() {
        _isLoadingRecommendations = false;
      });
    }
  }

  void _saveSearchToHistory(String query) async {
    final text = query.trim();
    if (text.isEmpty) return;

    final cat = widget.homeTab?.category ?? '';

    _allHistory.removeWhere((e) => e.query == text && e.category == cat);
    _allHistory.insert(0, SearchHistoryItem(query: text, category: cat));

    if (_allHistory.length > 50) {
      _allHistory.removeLast();
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'suggest_history_objects',
      _allHistory.map((e) => e.toJson()).toList(),
    );
    if (mounted) {
      setState(() {});
    }
  }

  void _removeFromHistory(String query) async {
    final cat = widget.homeTab?.category ?? '';
    _allHistory.removeWhere((e) => e.query == query && e.category == cat);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'suggest_history_objects',
      _allHistory.map((e) => e.toJson()).toList(),
    );
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    disposeConnectivityListener();
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    _focusNode.dispose();
    EasyDebounce.cancel('suggest_debounce');
    super.dispose();
  }

  void _onSearchTextChanged() {
    setState(() {
      _showClearButton = _searchController.text.isNotEmpty;
    });

    final query = _searchController.text;
    if (query.trim().length >= 2) {
      EasyDebounce.debounce(
        'suggest_debounce',
        const Duration(milliseconds: 300),
        () {
          _cubit.fetchSuggestions(
            query: query,
            lat: widget.lat,
            lng: widget.lng,
            category: widget.homeTab?.category,
          );
        },
      );
    } else {
      EasyDebounce.cancel('suggest_debounce');
      _cubit.fetchSuggestions(query: ''); // Triggers initial state
    }
  }

  void _handleSearchSubmit(String text) {
    if (text.trim().isEmpty) return;

    _saveSearchToHistory(text);

    context.pushNamed(
      SearchResultPage.routeName,
      extra: {
        'category': widget.homeTab?.category ?? HomeTab.residence.category,
        'search': text,
        'villeId': null,
        'communeId': null,
        'displayText': text,
      },
    );
  }

  Future<void> _handleSuggestionClick(SuggestionModel suggestion) async {
    final query = _searchController.text;

    // 1. Track Click on suggestions (non-blocking)
    if (suggestion.id != null && suggestion.type != null) {
      _cubit.trackSuggestionClick(
        query: query,
        type: suggestion.type!.name,
        id: suggestion.id!,
      );
    }

    if (!mounted) return;

    final type = suggestion.type;
    final label = suggestion.label ?? '';
    if (label.isNotEmpty) {
      _saveSearchToHistory(label);
    }

    // 2. Direct Detail Redirection
    if (type == SuggestionType.bien) {
      context.pushNamed(
        EstatePage.name,
        pathParameters: {'idProduct': suggestion.id ?? ''},
      );
      return;
    } else if (type == SuggestionType.residence) {
      context.pushNamed(
        ResidencePage.name,
        pathParameters: {'idProduct': suggestion.id ?? ''},
      );
      return;
    }

    // 3. Indirect Redirection to listing page (SearchResultPage)
    String? search;
    String? villeId;
    String? communeId;
    String displayText;

    if (type == SuggestionType.ville) {
      villeId = suggestion.id;
      displayText = suggestion.label ?? '';
    } else if (type == SuggestionType.commune) {
      communeId = suggestion.id;
      displayText = suggestion.label ?? '';
    } else if (type == SuggestionType.query) {
      search = suggestion.label;
      displayText = suggestion.label ?? '';
    } else if (type == SuggestionType.price) {
      search = query; // Keeps the text typed, does not touch the search field
      displayText = query;
    } else {
      search = suggestion.label;
      displayText = suggestion.label ?? '';
    }

    context.pushNamed(
      SearchResultPage.routeName,
      extra: {
        'category': widget.homeTab?.category ?? HomeTab.residence.category,
        'search': search,
        'villeId': villeId,
        'communeId': communeId,
        'displayText': displayText,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            SuggestSearchBar(
              controller: _searchController,
              focusNode: _focusNode,
              showClearButton: _showClearButton,
              showSearchButton: true,
              onClear: () {
                _searchController.clear();
              },
              onFieldSubmitted: _handleSearchSubmit,
              onSearchPressed: () =>
                  _handleSearchSubmit(_searchController.text),
              onBackPressed: () => context.pop(),
            ),

            const Divider(height: 1),

            // Suggestion list
            Expanded(
              child: BlocConsumer<SuggestCubit, SuggestState>(
                bloc: _cubit,
                listener: (context, state) {
                  state.maybeWhen(
                    error: (msg) => showConnectionErrorDialog(),
                    orElse: () {},
                  );
                },
                builder: (context, state) {
                  return state.when(
                    initial: () => _buildInitialState(),
                    loading: () => Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                    success: (suggestions) {
                      if (suggestions.isEmpty) {
                        return const Center(
                          child: Text(
                            'Aucune suggestion trouvée',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: suggestions.length,
                        separatorBuilder: (context, index) => SizedBox(
                          height: 0,
                        ),
                        itemBuilder: (context, index) {
                          final suggestion = suggestions[index];

                          return SuggestionTile(
                            suggestion: suggestion,
                            query: _searchController.text,
                            onTap: () => _handleSuggestionClick(suggestion),
                            onCopy: (value) {
                              _searchController.text = value;
                              _searchController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset: _searchController.text.length),
                              );
                            },
                          );
                        },
                      );
                    },
                    error: (msg) => Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    final historyToShow =
        _showAllHistory ? _searchHistory : _searchHistory.take(3).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        if (_searchHistory.isNotEmpty) ...[
          ...historyToShow.map((item) {
            final query = item.query;
            return SearchHistoryTile(
              query: query,
              onTap: () {
                _handleSearchSubmit(query);
              },
              onRemove: () => _removeFromHistory(query),
            );
          }),
          if (_searchHistory.length > 3)
            InkWell(
              onTap: () {
                setState(() {
                  _showAllHistory = !_showAllHistory;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _showAllHistory ? 'Voir moins' : 'Voir plus',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const Gap(6),
                    Icon(
                      _showAllHistory
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          const Gap(12),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const Gap(16),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Tu pourrais aimer',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _isLoadingRecommendations = true;
                  });
                  _loadInitialData();
                },
                child: Row(
                  children: [
                    const Icon(Icons.refresh, color: Colors.grey, size: 16),
                    const Gap(4),
                    const Text(
                      'Actualiser',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_isLoadingRecommendations)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_recommendedItems.isEmpty)
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Aucune recommandation trouvée',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ..._recommendedItems.map((item) {
            return RecommendationForYouTile(
              item: item,
              onTap: () {
                Constantes.tempPage = Utils.getCurrentLocation();
                if (item is ResidenceModel) {
                  context.push(ResidencePage.route((item).id), extra: item);
                } else if (item is BienImmobilierModel) {
                  context.push('/estate_detail/${(item).id}');
                }
              },
            );
          }),
      ],
    );
  }
}
