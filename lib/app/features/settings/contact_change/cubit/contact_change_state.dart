import 'package:flutter/foundation.dart';
import 'package:immoplus/app/data/enums/contact_change_type.dart';

@immutable
abstract class ContactChangeState {}

class ContactChangeInitial extends ContactChangeState {}

class ContactChangeRequestLoading extends ContactChangeState {}

class ContactChangeRequestSuccess extends ContactChangeState {
  final ContactChangeType type;
  ContactChangeRequestSuccess(this.type);
}

class ContactChangeRequestError extends ContactChangeState {
  final String message;
  ContactChangeRequestError(this.message);
}

class ContactChangeConfirmLoading extends ContactChangeState {}

class ContactChangeConfirmSuccess extends ContactChangeState {
  final String message;
  ContactChangeConfirmSuccess(this.message);
}

class ContactChangeConfirmError extends ContactChangeState {
  final String message;
  ContactChangeConfirmError(this.message);
}
