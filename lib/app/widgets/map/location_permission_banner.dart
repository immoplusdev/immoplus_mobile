import 'package:flutter/material.dart';
import 'package:immoplus/app/services/location_service.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionBanner extends StatefulWidget {
  final bool showAction;
  const LocationPermissionBanner({super.key, this.showAction = true});

  @override
  State<LocationPermissionBanner> createState() =>
      _LocationPermissionBannerState();
}

class _LocationPermissionBannerState extends State<LocationPermissionBanner>
    with WidgetsBindingObserver {
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkPermissionAndUpdateVisibility();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Quand l'app revient au premier plan
    if (state == AppLifecycleState.resumed) {
      _checkPermissionAndUpdateVisibility();
    }
  }

  Future<void> _checkPermissionAndUpdateVisibility() async {
    final hasPermission = await LocationService.hasLocationPermission();
    if (mounted) {
      setState(() {
        isVisible = !hasPermission;
      });
    }
  }

  void _closeBanner() {
    setState(() {
      isVisible = false;
    });
  }

  void _openSettings() async {
    await openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.location_off_rounded,
                  size: 16, color: Colors.orange.shade700),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Activez la localisation pour plus de précision',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            if (widget.showAction) ...[
              GestureDetector(
                onTap: _openSettings,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'Activer',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: _closeBanner,
                child: Icon(Icons.close_rounded,
                    size: 18, color: Colors.grey.shade400),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
