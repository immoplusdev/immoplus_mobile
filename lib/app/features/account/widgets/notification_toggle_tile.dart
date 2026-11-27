import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/services/notification_permission_service.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/account/widgets/settings_tile.dart';

/// Interrupteur « Notifications » du profil. L'état reflète l'autorisation
/// système et le choix de l'utilisateur ; il est relu au retour dans l'app
/// (ex. après un passage par les réglages du téléphone).
class NotificationToggleTile extends StatefulWidget {
  const NotificationToggleTile({
    super.key,
    required this.shape,
    required this.leading,
    required this.titleStyle,
  });

  final ShapeBorder shape;
  final Widget leading;
  final TextStyle titleStyle;

  @override
  State<NotificationToggleTile> createState() => _NotificationToggleTileState();
}

class _NotificationToggleTileState extends State<NotificationToggleTile>
    with WidgetsBindingObserver {
  bool? _enabled;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  Future<void> _refresh() async {
    final active = await NotificationPermissionService.isActive();
    if (mounted) setState(() => _enabled = active);
  }

  Future<void> _toggle(bool value) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _enabled = value;
    });
    try {
      if (value) {
        await NotificationPermissionService.enable();
      } else {
        await NotificationPermissionService.disable();
      }
    } finally {
      _busy = false;
      await _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = _enabled ?? false;
    return SettingsTile(
      shape: widget.shape,
      leading: widget.leading,
      title: 'Notifications',
      titleStyle: widget.titleStyle,
      trailing: _enabled == null
          ? const SizedBox(width: 51)
          : Switch.adaptive(
              value: enabled,
              activeTrackColor: AppColors.primary,
              onChanged: _busy ? null : _toggle,
            ),
      onTap: () {
        if (_enabled != null && !_busy) _toggle(!enabled);
      },
    );
  }
}

/// Icône par défaut de la tuile.
const notificationToggleIcon = Iconsax.notification;
