import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/data/enums/home_tab.dart';
import 'package:immoplus/app/features/suggest/pages/search_container_page.dart';
import 'package:immoplus/app/features/suggest/pages/suggest_page.dart';

class HomeSearchField extends StatefulWidget {
  const HomeSearchField({
    super.key,
    required this.isFurnitureTab,
    required this.currentIndex,
    required this.searchController,
    required this.showClearButton,
    required this.onClear,
    required this.onFilterPressed,
    required this.onFieldSubmitted,
    required this.onChanged,
  });

  final bool isFurnitureTab;
  final int currentIndex;
  final TextEditingController searchController;
  final bool showClearButton;
  final VoidCallback onClear;
  final VoidCallback onFilterPressed;
  final ValueChanged<String> onFieldSubmitted;
  final ValueChanged<String> onChanged;

  @override
  State<HomeSearchField> createState() => _HomeSearchFieldState();
}

class _HomeSearchFieldState extends State<HomeSearchField> {
  static const List<String> _cities = [
    "Un logement",
    "une résidence",
    "un appartement",
    "une villa",
    "un hôtel"
  ];
  static const String _placeholder = 'Que cherchez-vous ?';

  int _currentCityIndex = 0;
  Timer? _timer;
  bool _isSearching = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);

    if (widget.searchController.text.isNotEmpty && widget.isFurnitureTab) {
      _isSearching = true;
    }

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted && !_isSearching) {
        setState(() {
          _currentCityIndex = (_currentCityIndex + 1) % _cities.length;
        });
      }
    });
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && widget.searchController.text.isEmpty) {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  void didUpdateWidget(HomeSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      setState(() {
        _isSearching = false;
      });
      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchInput = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left side: Search Icon
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 8.0),
          child: Icon(
            Iconsax.search_normal_1,
            color: AppColors.primary,
            size: 18,
          ),
        ),
        // Middle: Column (search input top, animated cities bottom)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isSearching)
                Container(
                  height: 35,
                  alignment: Alignment.centerLeft,
                  child: TextFormField(
                    controller: widget.searchController,
                    focusNode: _focusNode,
                    onFieldSubmitted: widget.onFieldSubmitted,
                    onChanged: widget.onChanged,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: _placeholder,
                      hintStyle: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                )
              else ...[
                // Row 1: Search input (text view)
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.searchController.text.isNotEmpty
                        ? widget.searchController.text
                        : _placeholder,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                // Row 2: City text
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 0.8),
                            end: Offset.zero,
                          ).animate(animation),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Align(
                        key: ValueKey<String>(_cities[_currentCityIndex]),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _cities[_currentCityIndex],
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        // Right side: Settings/Clear Icon
        Padding(
            padding: const EdgeInsets.only(right: 12.0, left: 8.0),
            child: widget.showClearButton
                ? GestureDetector(
                    onTap: () {
                      widget.onClear();
                      _focusNode.unfocus();
                    },
                    child: const Icon(
                      Icons.cancel,
                      color: Colors.grey,
                      size: 18,
                    ),
                  )
                : SizedBox.shrink()
            // GestureDetector(
            //     onTap: widget.onFilterPressed,
            //     child: Icon(
            //       Iconsax.setting_4,
            //       color: AppColors.primary,
            //       size: 20,
            //     ),
            //   ),
            ),
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radiusButton),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          if (widget.isFurnitureTab) {
            setState(() {
              _isSearching = true;
            });
            _focusNode.requestFocus();
          } else {
            final homeTab = HomeTab.values[widget.currentIndex];
            context.pushNamed(
              SearchContainerPage.routeName,
              extra: {
                'homeTab': homeTab,
                'lat': FilterHandler.lat,
                'lng': FilterHandler.long,
              },
            );
          }
        },
        behavior: HitTestBehavior.opaque,
        child: searchInput,
      ),
    );
  }
}
