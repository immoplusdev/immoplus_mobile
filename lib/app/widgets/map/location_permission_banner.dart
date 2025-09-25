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

    return GestureDetector(
      onTap: widget.showAction
          ? null
          : () {
              _openSettings();
            },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              blurRadius: 3,
              spreadRadius: 1,
              color: Colors.grey,
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              "Aucune permission de localisation accordée ! Allez dans paramètres et activer les permissions de localisation pour plus de précision",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            if (widget.showAction) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _closeBanner,
                    child: const Text("Fermer"),
                  ),
                  TextButton(
                    onPressed: _openSettings,
                    child: const Text("Paramètres"),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
