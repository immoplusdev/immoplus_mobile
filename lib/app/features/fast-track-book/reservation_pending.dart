// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';


// class ReservationPendingBanner extends StatefulWidget {
//   final String propertyType;
//   final String propertyLocation;
//   final int totalSeconds;
//   final int remainingSeconds;
//   final VoidCallback onTap;

//   const ReservationPendingBanner({
//     super.key,
//     required this.propertyType,
//     required this.propertyLocation,
//     required this.totalSeconds,
//     required this.remainingSeconds,
//     required this.onTap,
//   });

//   @override
//   State<ReservationPendingBanner> createState() =>
//       _ReservationPendingBannerState();
// }

// class _ReservationPendingBannerState extends State<ReservationPendingBanner>
//     with TickerProviderStateMixin {

//   late int _secondsLeft;
//   Timer? _countdownTimer;

//   final List<String> _rotatingMessages = [
//     'Il consulte les dates de votre séjour…',
//     'Votre logement est toujours disponible.',
//     'Plus qu\'un instant…',
//     'La confirmation arrive vite.',
//   ];
//   int _messageIndex = 0;
//   Timer? _messageTimer;

//   late AnimationController _pulseController;
//   late Animation<double> _pulseAnimation;
//   late AnimationController _messageController;
//   late Animation<double> _messageOpacity;

//   static const Color _bgColor     = Color(0xFFFFFFFF);
//   static const Color _iconBg      = Color(0xFFAB8DFF);
//   static const Color _accentLight = Color(0xFFEEE8FF);
//   static const Color _textPrimary = Color(0xFF1A1A1A);
//   static const Color _textMuted   = Color(0xFF888888);

//   @override
//   void initState() {
//     super.initState();
//     _secondsLeft = widget.remainingSeconds;

//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     )..repeat(reverse: true);

//     _pulseAnimation = Tween<double>(begin: 0.88, end: 1.12).animate(
//       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
//     );

//     _messageController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 400),
//       value: 1.0,
//     );
//     _messageOpacity = CurvedAnimation(
//       parent: _messageController,
//       curve: Curves.easeInOut,
//     );

//     _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (!mounted) return;
//       if (_secondsLeft > 0) {
//         setState(() => _secondsLeft--);
//       } else {
//         _countdownTimer?.cancel();
//       }
//     });

//     _messageTimer = Timer.periodic(const Duration(seconds: 8), (_) {
//       if (mounted) _rotateMessage();
//     });
//   }

//   void _rotateMessage() async {
//     await _messageController.reverse();
//     if (!mounted) return;
//     setState(() {
//       _messageIndex = (_messageIndex + 1) % _rotatingMessages.length;
//     });
//     await _messageController.forward();
//   }

//   @override
//   void dispose() {
//     _countdownTimer?.cancel();
//     _messageTimer?.cancel();
//     _pulseController.dispose();
//     _messageController.dispose();
//     super.dispose();
//   }

//   String get _formattedTime {
//     final m = _secondsLeft ~/ 60;
//     final s = _secondsLeft % 60;
//     return '$m:${s.toString().padLeft(2, '0')}';
//   }

//   double get _progressRatio =>
//       (_secondsLeft / widget.totalSeconds).clamp(0.0, 1.0);

//   IconData get _propertyIcon {
//     switch (widget.propertyType.toLowerCase()) {
//       case 'villa':  return Icons.villa_outlined;
//       case 'studio': return Icons.single_bed_outlined;
//       case 'bureau': return Icons.business_outlined;
//       default:       return Icons.apartment_outlined;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onTap,
//       child: Container(
//         width: 375,
//         decoration: BoxDecoration(
//           color: _bgColor,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFFAB8DFF).withOpacity(0.12),
//               blurRadius: 16,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         clipBehavior: Clip.hardEdge,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // ✅ IntrinsicHeight — résout le parentDataDirty avec stretch
//             IntrinsicHeight(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [

//                   // Bloc coloré gauche
//                   Container(
//                     width: 64,
//                     color: _iconBg,
//                     child: Center(
//                       child: ScaleTransition(
//                         scale: _pulseAnimation,
//                         child: Container(
//                           width: 38,
//                           height: 38,
//                           decoration: BoxDecoration(
//                             color: _accentLight.withOpacity(0.25),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: const Icon(
//                             Iconsax.timer_1,
//                             color:Color(0xFFEEE8FF),
//                             size: 20,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),

//                   // Textes centre
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           // _PropertyPill(
//                           //   icon: _propertyIcon,
//                           //   label:
//                           //       '${widget.propertyType} · ${widget.propertyLocation}',
//                           // ),
//                           // const SizedBox(height: 4),
//                           const Text(
//                             'Le propriétaire regarde votre demande',
//                             style: TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w700,
//                               color: _textPrimary,
//                               height: 1.25,
//                             ),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: 3),
//                           FadeTransition(
//                             opacity: _messageOpacity,
//                             child: Text(
//                               _rotatingMessages[_messageIndex],
//                               style: const TextStyle(
//                                 fontSize: 11,
//                                 color: _textMuted,
//                                 height: 1.3,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   // Timer + chevron
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           _formattedTime,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: -0.5,
//                             color: _iconBg,
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         const Icon(
//                           Icons.chevron_right_rounded,
//                           color: _textMuted,
//                           size: 18,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // // Barre de progression
//             // _ProgressBar(ratio: _progressRatio),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // // ── Pill type de bien ─────────────────────────────────────────────────────────
// // class _PropertyPill extends StatelessWidget {
// //   final IconData icon;
// //   final String label;
// //   const _PropertyPill({required this.icon, required this.label});
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFFEEE8FF),
// //         borderRadius: BorderRadius.circular(6),
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Icon(icon, size: 10, color: const Color(0xFFAB8DFF)),
// //           const SizedBox(width: 4),
// //           Text(
// //             label,
// //             style: const TextStyle(
// //               fontSize: 10,
// //               fontWeight: FontWeight.w600,
// //               color: Color(0xFFAB8DFF),
// //               letterSpacing: 0.2,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// // ── Barre de progression ──────────────────────────────────────────────────────
// class _ProgressBar extends StatelessWidget {
//   final double ratio;
//   const _ProgressBar({required this.ratio});

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       return Stack(
//         children: [
//           Container(
//             height: 3,
//             width: double.infinity,
//             color: const Color(0xFFF0ECFF),
//           ),
//           AnimatedContainer(
//             duration: const Duration(seconds: 1),
//             curve: Curves.linear,
//             height: 3,
//             width: constraints.maxWidth * ratio,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: ratio > 0.25
//                     ? [const Color(0xFFAB8DFF), const Color(0xFFD4BCFF)]
//                     : [const Color(0xFFFF4444), const Color(0xFFFF8080)],
//               ),
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }