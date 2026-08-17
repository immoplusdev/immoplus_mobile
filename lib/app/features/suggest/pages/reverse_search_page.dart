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
  const ReverseSearchPage({super.key});

  @override
  State<ReverseSearchPage> createState() => _ReverseSearchPageState();
}

class _ReverseSearchPageState extends State<ReverseSearchPage> {
  final _cubit = getIt<ReverseSearchCubit>();

  List<SelectedZone> _selectedZones = [
    SelectedZone(id: '1', nom: 'Cocody Angre', lat: 5.359951, lng: -4.008256),
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
                id: z.id,
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
      notes: "Test",
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
    final kMin = (_budgetMin / 1000).toInt();
    final kMax = (_budgetMax / 1000).toInt();
    if (_budgetMax >= 150000) return "${kMin} 000 F +";
    return "$kMin et $kMax 000 F";
  }

  String get _zonesText {
    if (_selectedZones.isEmpty) return "Ou ?";
    return _selectedZones.map((z) => z.nom).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<ReverseSearchCubit, ReverseSearchState>(
          listener: (context, state) {
            state.maybeWhen(
              error: (msg) {
                _isMapPushed = false;
                // ToastUtils.showError(description: msg);
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
                    _cubit.cancelSearch(searchId); // Clean up if user goes back
                  });
                }
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Center(child: CircularProgressIndicator()),
              orElse: () => _buildForm(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Text(
                    'Que cherchez- vous ?',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 12,
                    children: [
                      const Text('Je cherche a',
                          style:
                              TextStyle(fontSize: 28, color: Colors.black87)),
                      ReverseSearchChip(
                          text: _zonesText, onTap: _showZoneSheet),
                      const Text('du',
                          style:
                              TextStyle(fontSize: 28, color: Colors.black87)),
                      ReverseSearchChip(text: _dateText, onTap: _showDateSheet),
                      const Text('pour',
                          style:
                              TextStyle(fontSize: 28, color: Colors.black87)),
                      ReverseSearchChip(
                          text: '$_nombrePersonnes personnes',
                          onTap: _showPersonnesSheet),
                      const Text(', entre',
                          style:
                              TextStyle(fontSize: 28, color: Colors.black87)),
                      ReverseSearchChip(
                          text: _budgetText, onTap: _showBudgetSheet),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ), // Add top padding since AppBar is removed
        Divider(),
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0, left: 24, right: 24),
          child: CustomButtom(
            text: 'Lancer la recherche',
            onClick: _submit,
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
