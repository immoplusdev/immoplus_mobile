import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/enums/home_tab.dart';
import 'package:immoplus/app/data/models/remote/suggest/suggestion_model.dart';
import 'package:immoplus/app/features/estate_detail/estate_page.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/features/suggest/pages/search_result_page.dart';
import 'package:immoplus/app/features/suggest/logic/suggest_cubit.dart';
import 'package:immoplus/app/features/suggest/logic/suggest_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_text_field.dart';
import 'package:immoplus/app/features/suggest/pages/components/suggestion_tile.dart';
import 'package:immoplus/app/features/suggest/pages/components/suggest_search_bar.dart';

class SuggestPage extends StatefulWidget {
  final String? category;
  final double? lat;
  final double? lng;

  const SuggestPage({
    super.key,
    this.category,
    this.lat,
    this.lng,
  });

  static const String routeName = "suggest";
  static const String routePath = "/suggest";

  @override
  State<SuggestPage> createState() => _SuggestPageState();
}

class _SuggestPageState extends State<SuggestPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showClearButton = false;
  late final SuggestCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<SuggestCubit>();
    _searchController.addListener(_onSearchTextChanged);

    // Auto focus on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
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
            category: widget.category,
          );
        },
      );
    } else {
      _cubit.fetchSuggestions(query: ''); // Triggers initial state
    }
  }

  void _handleSearchSubmit(String text) {
    if (text.trim().isEmpty) return;

    context.pushNamed(
      SearchResultPage.routeName,
      extra: {
        'category': widget.category ?? 'residence',
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
        'category': widget.category ?? HomeTab.residence.category,
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
              child: BlocBuilder<SuggestCubit, SuggestState>(
                bloc: _cubit,
                builder: (context, state) {
                  return state.when(
                    initial: () => const Center(
                      child: Text(
                        'Commencez à saisir pour voir les suggestions',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
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
                      child: Text(
                        'Erreur: $msg',
                        style: const TextStyle(color: Colors.redAccent),
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
}
