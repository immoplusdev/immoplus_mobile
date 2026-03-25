import 'package:flutter/foundation.dart';

@immutable
abstract class BecomeProState {}

class BecomeProInitial extends BecomeProState {}

class BecomeProLoading extends BecomeProState {}

class BecomeProSuccess extends BecomeProState {}

class BecomeProFailure extends BecomeProState {
  final String message;
  BecomeProFailure(this.message);
}
