import 'package:flutter/material.dart';
import 'package:immoplus/app/widgets/custom_button.dart';

class SelectedZone {
  final String nom;
  final double lat;
  final double lng;

  const SelectedZone({
    required this.nom,
    required this.lat,
    required this.lng,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedZone &&
          runtimeType == other.runtimeType &&
          nom == other.nom;

  @override
  int get hashCode => nom.hashCode;
}

class ZoneSelectionSheet extends StatefulWidget {
  final List<SelectedZone> initialSelectedZones;
  
  const ZoneSelectionSheet({super.key, required this.initialSelectedZones});

  static Future<List<SelectedZone>?> show(BuildContext context, List<SelectedZone> initial) {
    return showModalBottomSheet<List<SelectedZone>>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => ZoneSelectionSheet(initialSelectedZones: initial),
    );
  }

  @override
  State<ZoneSelectionSheet> createState() => _ZoneSelectionSheetState();
}

class _ZoneSelectionSheetState extends State<ZoneSelectionSheet> {
  final List<SelectedZone> availableZones = const [
    SelectedZone(nom: 'Cocody Angre', lat: 5.359951, lng: -4.008256),
    SelectedZone(nom: 'Rivera Palmeraie', lat: 5.361520, lng: -3.966750),
    SelectedZone(nom: 'Macory Zone 4', lat: 5.297420, lng: -3.992640),
    SelectedZone(nom: 'Plateau', lat: 5.328320, lng: -4.019550),
    SelectedZone(nom: 'Yopougon', lat: 5.334000, lng: -4.072000),
    SelectedZone(nom: 'Bassam', lat: 5.204500, lng: -3.737100),
    SelectedZone(nom: 'Assinie', lat: 5.127400, lng: -3.275000),
  ];
  
  late List<SelectedZone> _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.initialSelectedZones);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ou ?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableZones.map((z) {
              final isSelected = _tempSelected.contains(z);
              return ChoiceChip(
                label: Text(z.nom),
                selected: isSelected,
                selectedColor: Colors.black,
                labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: isSelected ? Colors.black : Colors.grey.shade300),
                ),
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _tempSelected.add(z);
                    } else {
                      _tempSelected.remove(z);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          CustomButtom(
            text: 'Garder ces ${_tempSelected.length} zones',
            onClick: () => Navigator.pop(context, _tempSelected),
          )
        ],
      ),
    );
  }
}
