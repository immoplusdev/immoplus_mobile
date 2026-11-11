import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/enums/booking_mode.dart';
import 'package:immoplus/app/features/booking_mode/booking_mode_cubit.dart';

/// Reconstruit son contenu quand le mode de réservation change, sans
/// dépendre d'un `BlocProvider` : l'instance est le singleton de l'app.
///
/// ```dart
/// BookingModeBuilder(builder: (context, mode) => Text(mode.ctaLabel))
/// ```
class BookingModeBuilder extends StatelessWidget {
  const BookingModeBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, BookingMode mode) builder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingModeCubit, BookingMode>(
      bloc: getIt<BookingModeCubit>(),
      builder: builder,
    );
  }
}
