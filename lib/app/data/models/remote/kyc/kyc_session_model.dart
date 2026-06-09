import 'package:freezed_annotation/freezed_annotation.dart';

part 'kyc_session_model.freezed.dart';
part 'kyc_session_model.g.dart';

@freezed
class KycSessionModel with _$KycSessionModel {
  const factory KycSessionModel({
    @Default('') String id,
    @Default('') String diditSessionId,
    @Default('')
    String status, // e.g. APPROVED, PENDING, FAILED, NONE, Not Started, etc.
    @Default('') String vendorData,
    @Default('') String lastEventId,
    @Default('') String diditUrl,
    @Default('') String documentType,
    @Default('') String frontUrl,
    @Default('') String backUrl,
    @Default('') String createdAt,
    @Default('') String updatedAt,
  }) = _KycSessionModel;

  factory KycSessionModel.fromJson(Map<String, dynamic> json) =>
      _$KycSessionModelFromJson(json);
}

enum KycStatus {
  notStarted,
  inProgress,
  approved,
  declined,
  inReview,
  awaitingUser,
  resubmitted,
  expired,
  abandoned,
  kycExpired,
  unknown;

  static KycStatus fromString(String statusStr) {
    switch (statusStr.trim()) {
      case 'Not Started':
        return KycStatus.notStarted;
      case 'In Progress':
        return KycStatus.inProgress;
      case 'Approved':
        return KycStatus.approved;
      case 'Declined':
        return KycStatus.declined;
      case 'In Review':
        return KycStatus.inReview;
      case 'Awaiting User':
        return KycStatus.awaitingUser;
      case 'Resubmitted':
        return KycStatus.resubmitted;
      case 'Expired':
        return KycStatus.expired;
      case 'Abandoned':
        return KycStatus.abandoned;
      case 'Kyc Expired':
        return KycStatus.kycExpired;
      default:
        return KycStatus.unknown;
    }
  }
}

extension KycSessionModelX on KycSessionModel {
  String get token {
    if (diditUrl.isEmpty) return '';
    return diditUrl.split('/').last;
  }

  KycStatus get kycStatus => KycStatus.fromString(status);
}
