import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/core/error/app_error.dart';
import 'package:immoplus/app/core/error/error_context.dart';
import 'package:immoplus/app/core/error/error_feedback.dart';

/// Présente automatiquement l'erreur portée par l'état d'un bloc/cubit.
///
/// Pour les écrans dont l'état contient une [AppError] : le cubit se contente
/// de l'émettre, l'écran déclare comment la lire.
///
/// ```dart
/// ErrorFeedbackListener<BookingCubit, BookingRequestState>(
///   errorOf: (state) => state is Error_BOOKINGS ? state.appError : null,
///   contextOf: (state) => state is Error_BOOKINGS ? state.context : null,
///   child: ...,
/// )
/// ```
class ErrorFeedbackListener<B extends StateStreamable<S>, S>
    extends StatelessWidget {
  const ErrorFeedbackListener({
    super.key,
    required this.errorOf,
    required this.child,
    this.contextOf,
    this.retry,
  });

  /// Extrait l'erreur de l'état (ou `null` s'il n'y en a pas).
  final AppError? Function(S state) errorOf;

  /// Contexte métier ; [ErrorContext.generic] par défaut.
  final ErrorContext? Function(S state)? contextOf;

  /// Action de relance, uniquement si l'opération est sûre à relancer.
  final FutureOr<void> Function()? retry;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listenWhen: (previous, current) => errorOf(current) != null,
      listener: (_, state) => ErrorFeedback.present(
        errorOf(state)!,
        context: contextOf?.call(state) ?? ErrorContext.generic,
        retry: retry,
      ),
      child: child,
    );
  }
}
