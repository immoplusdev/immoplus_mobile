import 'dart:async';

import 'package:flutter/material.dart';

/// Compte à rebours réutilisable jusqu'à [expireAt] (aligné sur
/// `selectionExpireAt`, relâché côté serveur par l'event socket
/// `reverse_search:selection_expiree`). Appelle [onExpired] une seule fois,
/// dès que le temps est écoulé côté client — filet de sécurité pour
/// revérifier l'état réel auprès du serveur si l'event socket n'arrive
/// jamais (ex : job serveur en retard ou down), plutôt que de rester bloqué
/// visuellement sur "Expiré" indéfiniment.
class SelectionCountdown extends StatefulWidget {
  final DateTime expireAt;
  final Widget Function(BuildContext context, Duration remaining, bool expired)
      builder;
  final VoidCallback? onExpired;

  const SelectionCountdown({
    super.key,
    required this.expireAt,
    required this.builder,
    this.onExpired,
  });

  @override
  State<SelectionCountdown> createState() => _SelectionCountdownState();
}

class _SelectionCountdownState extends State<SelectionCountdown> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _hasFiredExpired = false;

  @override
  void initState() {
    super.initState();
    // initState/didUpdateWidget tournent pendant la phase de build d'un
    // ancêtre : on ne peut pas y appeler setState/onExpired synchronement
    // (« setState called during build »). On fixe juste la valeur ici, et on
    // reporte la notification après la frame en cours si déjà expiré.
    _computeRemaining(duringBuildPhase: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _computeRemaining());
  }

  void _computeRemaining({bool duringBuildPhase = false}) {
    final diff = widget.expireAt.difference(DateTime.now());
    final remaining = diff.isNegative ? Duration.zero : diff;
    final justExpired = remaining == Duration.zero && !_hasFiredExpired;

    if (duringBuildPhase) {
      _remaining = remaining;
      if (justExpired) {
        _hasFiredExpired = true;
        WidgetsBinding.instance
            .addPostFrameCallback((_) => widget.onExpired?.call());
      }
      return;
    }

    if (!mounted) return;
    setState(() => _remaining = remaining);
    if (justExpired) {
      _hasFiredExpired = true;
      widget.onExpired?.call();
    }
  }

  @override
  void didUpdateWidget(covariant SelectionCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expireAt != widget.expireAt) {
      _hasFiredExpired = false;
      _computeRemaining(duringBuildPhase: true);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _remaining, _remaining == Duration.zero);
  }
}

/// Formatte une durée en `mm:ss`.
String formatCountdown(Duration d) {
  final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
