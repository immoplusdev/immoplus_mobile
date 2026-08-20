import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/reverse_search/reverse_search_model.dart';
import 'package:immoplus/app/features/suggest/logic/reverse_search_cubit.dart';
import 'package:immoplus/app/features/suggest/logic/reverse_search_state.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/features/suggest/widgets/reverse_search_chip.dart';
import 'package:immoplus/app/features/suggest/widgets/zone_selection_sheet.dart';
import 'package:immoplus/app/features/suggest/widgets/personnes_selection_sheet.dart';
import 'package:immoplus/app/features/suggest/widgets/budget_selection_sheet.dart';
import 'package:immoplus/app/features/suggest/widgets/date_selection_sheet.dart';
import 'package:immoplus/app/features/suggest/pages/reverse_search_map_page.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/utils/toast_utils.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ReverseSearchPage extends StatefulWidget {
  final Widget? tabBar;

  const ReverseSearchPage({super.key, this.tabBar});

  @override
  State<ReverseSearchPage> createState() => _ReverseSearchPageState();
}

class _ReverseSearchPageState extends State<ReverseSearchPage> {
  final _cubit = getIt<ReverseSearchCubit>();

  List<SelectedZone> _selectedZones = [
    const SelectedZone(id: '1', nom: 'Cocody, Abidjan', lat: 5.359951, lng: -4.008256),
  ];
  DateTime? _dateDebut = DateTime.now();
  DateTime? _dateFin = DateTime.now().add(const Duration(days: 4));
  int _nombrePersonnes = 3;
  double _budgetMin = 40000;
  double _budgetMax = 80000;

  ReverseSearchRequest? _lastRequest;
  bool _isMapPushed = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR', null);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _submit() {
    if (_dateDebut == null || _dateFin == null) return;

    if (_selectedZones.isEmpty) {
      ToastUtils.showError(
          description: "Veuillez sélectionner au moins une zone.");
      return;
    }

    final request = ReverseSearchRequest(
      zones: _selectedZones
          .map((z) => ReverseSearchZone(
                adresse: z.nom,
                lat: z.lat,
                lng: z.lng,
              ))
          .toList(),
      dateDebut: _dateDebut!,
      dateFin: _dateFin!,
      nombrePersonnes: _nombrePersonnes,
      budgetMin: _budgetMin,
      budgetMax: _budgetMax,
      notes: "Pas de préférence",
    );

    _lastRequest = request;
    _cubit.initiateSearch(request);
  }

  String get _dateText {
    if (_dateDebut == null || _dateFin == null) return "Dates ?";
    final dFormat = DateFormat('d');
    final mFormat = DateFormat('MMM', 'fr_FR');
    if (_dateDebut!.month == _dateFin!.month) {
      return "${dFormat.format(_dateDebut!)} au ${dFormat.format(_dateFin!)} ${mFormat.format(_dateFin!)}.";
    }
    return "${dFormat.format(_dateDebut!)} ${mFormat.format(_dateDebut!)} au ${dFormat.format(_dateFin!)} ${mFormat.format(_dateFin!)}";
  }

  String get _budgetText {
    final formatter = NumberFormat('#,###', 'fr_FR');

    if (_budgetMin == 0 && _budgetMax == 0) return "Budget ?";

    final isMinK = _budgetMin >= 1000 && (_budgetMin % 1000 == 0);
    final isMaxK = _budgetMax >= 1000 && (_budgetMax % 1000 == 0);

    if (_budgetMin == 0) {
      final maxStr = isMaxK
          ? '${(_budgetMax / 1000).toInt()} 000'
          : formatter.format(_budgetMax.toInt());
      return "-$maxStr F";
    }

    if (_budgetMax >= 200000) {
      final minStr = isMinK
          ? '${(_budgetMin / 1000).toInt()} 000'
          : formatter.format(_budgetMin.toInt());
      return "$minStr F +";
    }

    if (isMinK && isMaxK) {
      final kMin = (_budgetMin / 1000).toInt();
      final kMax = (_budgetMax / 1000).toInt();
      return "$kMin et $kMax 000 F";
    }

    final minStr = formatter.format(_budgetMin.toInt());
    final maxStr = formatter.format(_budgetMax.toInt());
    return "$minStr et $maxStr F";
  }

  String get _zonesText {
    if (_selectedZones.isEmpty) return "Où ?";
    return _selectedZones.first.nom;
  }

  String? get _zoneBadgeText {
    if (_selectedZones.length > 1) {
      return "+${_selectedZones.length - 1}";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Colors.black, size: 22),
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            ),
            if (widget.tabBar != null) widget.tabBar!,

            // Rule 4: No hard divider — consistent 8px-based rhythm

            Expanded(
              child:
                  BlocConsumer<ReverseSearchCubit, ReverseSearchState>(
                listener: (context, state) {
                  state.maybeWhen(
                    error: (msg) {
                      _isMapPushed = false;
                      ToastUtils.showError(description: msg);
                    },
                    searching: (searchId, props, classic) {
                      if (!_isMapPushed && _lastRequest != null) {
                        _isMapPushed = true;
                        context.pushNamed(
                          ReverseSearchMapPage.routeName,
                          extra: {
                            'cubit': _cubit,
                            'request': _lastRequest!,
                          },
                        ).then((_) {
                          _isMapPushed = false;
                          _cubit
                              .cancelSearch(searchId); // Clean up if user goes back
                        });
                      }
                    },
                    orElse: () {},
                  );
                },
                builder: (context, state) {
                  return state.maybeWhen(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    orElse: () => _buildForm(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    const textStyle = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w400,
      color: Color(0xFF4A4A4A),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Que cherchez- vous ?',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                    ),
                    const SizedBox(height: 16),

                    // ── Ligne 1: Je cherche a [Ville] ──
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Je cherche a ', style: textStyle),
                          ReverseSearchChip(
                            text: _zonesText,
                            badge: _zoneBadgeText,
                            onTap: _showZoneSheet,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ── Ligne 2: du [Dates] pour ──
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('du ', style: textStyle),
                          ReverseSearchChip(
                            text: _dateText,
                            onTap: _showDateSheet,
                          ),
                          const Text(' pour', style: textStyle),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ── Ligne 3: [Personnes] , entre ──
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ReverseSearchChip(
                            text: _nombrePersonnes >= 8
                                ? '8 personnes'
                                : '$_nombrePersonnes personnes',
                            badge: _nombrePersonnes >= 8 ? '+' : null,
                            onTap: _showPersonnesSheet,
                          ),
                          const Text(', entre', style: textStyle),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ── Ligne 4: [Budget] ──
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ReverseSearchChip(
                            text: _budgetText,
                            onTap: _showBudgetSheet,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0, top: 12.0, left: 20, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButtom(
                text: 'Lancer la recherche',
                onClick: _submit,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDateSheet() async {
    final range = await DateSelectionSheet.show(context, _dateDebut, _dateFin);
    if (range != null) {
      setState(() {
        _dateDebut = range.start;
        _dateFin = range.end;
      });
    }
  }

  void _showZoneSheet() async {
    final result = await ZoneSelectionSheet.show(context, _selectedZones);
    if (result != null) {
      setState(() => _selectedZones = result);
    }
  }

  void _showPersonnesSheet() async {
    final result =
        await PersonnesSelectionSheet.show(context, _nombrePersonnes);
    if (result != null) {
      setState(() {
        _nombrePersonnes = result;
      });
      // _submit();
    }
  }

  void _showBudgetSheet() async {
    final result =
        await BudgetSelectionSheet.show(context, _budgetMin, _budgetMax);
    if (result != null) {
      setState(() {
        _budgetMin = result.min;
        _budgetMax = result.max;
      });
    }
  }
}
