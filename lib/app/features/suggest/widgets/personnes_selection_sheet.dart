import 'package:flutter/material.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_button.dart';

class PersonnesSelectionSheet extends StatefulWidget {
  final int initialPersonnes;

  const PersonnesSelectionSheet({super.key, required this.initialPersonnes});

  static Future<int?> show(BuildContext context, int initial) {
    return showModalBottomSheet<int>(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => PersonnesSelectionSheet(initialPersonnes: initial),
    );
  }

  @override
  State<PersonnesSelectionSheet> createState() =>
      _PersonnesSelectionSheetState();
}

class _PersonnesSelectionSheetState extends State<PersonnesSelectionSheet> {
  late int _tempPers;

  @override
  void initState() {
    super.initState();
    _tempPers = widget.initialPersonnes;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Combien de voyageurs ?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$_tempPers',
                  style: const TextStyle(
                      fontSize: 50, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  _CustomIcButton(
                      icon: Icons.remove,
                      onTap: () {
                        if (_tempPers > 1) setState(() => _tempPers--);
                      }),
                  const SizedBox(width: 8),
                  _CustomIcButton(
                      icon: Icons.add,
                      onTap: () {
                        setState(() => _tempPers++);
                      }),
                ],
              )
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [1, 2, 4, 6, 8].map((n) {
              final isSelected = _tempPers == n || (n == 8 && _tempPers >= 8);
              return GestureDetector(
                onTap: () => setState(() => _tempPers = n),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : null,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : Colors.grey.shade400)),
                  child: Center(
                    child: Text(n == 8 ? '8+' : '$n',
                        style: TextStyle(
                            color:
                                isSelected ? Colors.white : Color(0xff797979),
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          CustomButtom(
            text: 'Continuer',
            onClick: () => Navigator.pop(context, _tempPers),
          )
        ],
      ),
    );
  }
}

class _CustomIcButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  const _CustomIcButton({required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xffD9D9D9),
          ),
          borderRadius: BorderRadius.circular(12)),
      child: IconButton(
        icon: Icon(icon),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300)),
        ),
        onPressed: onTap,
      ),
    );
  }
}
