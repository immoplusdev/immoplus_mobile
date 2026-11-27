import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/enums/booking_mode.dart';
import 'package:immoplus/app/features/booking_mode/booking_mode_cubit.dart';

/// Reconstruit son contenu quand le mode de réservation change, sans
/// dépendre d'un `BlocProvider` : l'instance est le singleton de l'app.
///
/// Si [residenceBookingMode] est non-null (`INSTANT` ou `REQUEST`), il est
/// utilisé ; s'il est `null`, le mode global fourni par [BookingModeCubit]
/// s'applique.
///
/// ```dart
/// BookingModeBuilder(
///   residenceBookingMode: residence.bookingMode,
///   builder: (context, mode) => Text(mode.ctaLabel),
/// )
/// ```
class BookingModeBuilder extends StatelessWidget {
  const BookingModeBuilder({
    super.key,
    required this.builder,
    this.residenceBookingMode,
  });

  final Widget Function(BuildContext context, BookingMode mode) builder;
  final String? residenceBookingMode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingModeCubit, BookingMode>(
      bloc: getIt<BookingModeCubit>(),
      builder: (context, globalMode) {
        final effectiveMode = BookingMode.resolve(
          residenceBookingMode: residenceBookingMode,
          globalMode: globalMode,
        );
        return builder(context, effectiveMode);
      },
    );
  }
}
