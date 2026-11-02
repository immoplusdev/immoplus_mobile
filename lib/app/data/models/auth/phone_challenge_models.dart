import 'package:immoplus/app/data/models/auth/additional_data_model.dart';
import 'package:immoplus/app/data/models/auth/role_model.dart';
import 'package:immoplus/app/data/models/auth/user_model.dart';

enum PhoneAuthAudience {
  customer('CUSTOMER'),
  pro('PRO');

  const PhoneAuthAudience(this.value);
  final String value;
}

enum OtpChannelPreference {
  whatsapp('WHATSAPP'),
  sms('SMS'),
  auto('AUTO');

  const OtpChannelPreference(this.value);
  final String value;
}

enum PhoneChallengePurpose {
  signInOrSignUp('SIGN_IN_OR_SIGN_UP');

  const PhoneChallengePurpose(this.value);
  final String value;
}

enum PhoneVerifyOutcome {
  signedIn('SIGNED_IN'),
  signedUp('SIGNED_UP');

  const PhoneVerifyOutcome(this.value);
  final String value;
}

class CreatePhoneChallengeBody {
  final String phoneNumber;
  final String audience;
  final String channelPreference;
  final String locale;
  final String purpose;

  const CreatePhoneChallengeBody({
    required this.phoneNumber,
    this.audience = 'CUSTOMER',
    this.channelPreference = 'AUTO',
    this.locale = 'fr-CI',
    this.purpose = 'SIGN_IN_OR_SIGN_UP',
  });

  factory CreatePhoneChallengeBody.fromJson(Map<String, dynamic> json) {
    return CreatePhoneChallengeBody(
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      audience: json['audience']?.toString() ?? 'CUSTOMER',
      channelPreference: json['channelPreference']?.toString() ?? 'AUTO',
      locale: json['locale']?.toString() ?? 'fr-CI',
      purpose: json['purpose']?.toString() ?? 'SIGN_IN_OR_SIGN_UP',
    );
  }

  Map<String, dynamic> toJson() => {
        'phoneNumber': phoneNumber,
        'audience': audience,
        'channelPreference': channelPreference,
        'locale': locale,
        'purpose': purpose,
      };
}

class PhoneChallengeData {
  final String challengeId;
  final String deliveryChannel;
  final String maskedDestination;
  final DateTime? expiresAt;
  final DateTime? resendAvailableAt;
  final int attemptsRemaining;

  const PhoneChallengeData({
    required this.challengeId,
    required this.deliveryChannel,
    required this.maskedDestination,
    this.expiresAt,
    this.resendAvailableAt,
    this.attemptsRemaining = 5,
  });

  bool get isWhatsapp => deliveryChannel.toUpperCase() == 'WHATSAPP';

  factory PhoneChallengeData.fromJson(Map<String, dynamic> json) {
    return PhoneChallengeData(
      challengeId: json['challengeId']?.toString() ?? '',
      deliveryChannel: json['deliveryChannel']?.toString() ?? 'SMS',
      maskedDestination: json['maskedDestination']?.toString() ?? '',
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'].toString())
          : null,
      resendAvailableAt: json['resendAvailableAt'] != null
          ? DateTime.tryParse(json['resendAvailableAt'].toString())
          : null,
      attemptsRemaining: (json['attemptsRemaining'] as num?)?.toInt() ?? 5,
    );
  }

  Map<String, dynamic> toJson() => {
        'challengeId': challengeId,
        'deliveryChannel': deliveryChannel,
        'maskedDestination': maskedDestination,
        'expiresAt': expiresAt?.toIso8601String(),
        'resendAvailableAt': resendAvailableAt?.toIso8601String(),
        'attemptsRemaining': attemptsRemaining,
      };
}

class PhoneChallengeResponse {
  final PhoneChallengeData data;

  const PhoneChallengeResponse({required this.data});

  factory PhoneChallengeResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return PhoneChallengeResponse(
      data: PhoneChallengeData.fromJson(
        rawData is Map<String, dynamic> ? rawData : const {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data.toJson(),
      };
}

class PhoneChallengeProfileDto {
  final String firstName;
  final String lastName;
  final String birthDate;
  final String? proKind;

  const PhoneChallengeProfileDto({
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    this.proKind,
  });

  factory PhoneChallengeProfileDto.fromJson(Map<String, dynamic> json) {
    return PhoneChallengeProfileDto(
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      birthDate: json['birthDate']?.toString() ?? '',
      proKind: json['proKind']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'birthDate': birthDate,
        'proKind': proKind,
      };
}

class VerifyPhoneChallengeBody {
  final String otp;
  final PhoneChallengeProfileDto? profile;

  const VerifyPhoneChallengeBody({
    required this.otp,
    this.profile,
  });

  factory VerifyPhoneChallengeBody.fromJson(Map<String, dynamic> json) {
    final rawProfile = json['profile'];
    return VerifyPhoneChallengeBody(
      otp: json['otp']?.toString() ?? '',
      profile: rawProfile is Map<String, dynamic>
          ? PhoneChallengeProfileDto.fromJson(rawProfile)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'otp': otp,
        if (profile != null) 'profile': profile!.toJson(),
      };
}

class PhoneAuthOnboardingModel {
  final String status;
  final String? nextAction;

  const PhoneAuthOnboardingModel({
    required this.status,
    this.nextAction,
  });

  factory PhoneAuthOnboardingModel.fromJson(Map<String, dynamic> json) {
    return PhoneAuthOnboardingModel(
      status: json['status']?.toString() ?? 'NOT_REQUIRED',
      nextAction: json['nextAction']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'nextAction': nextAction,
      };
}

class VerifyPhoneChallengeData {
  final String outcome;
  final String? accessToken;
  final String? refreshToken;
  final UserModel user;
  final PhoneAuthOnboardingModel? onboarding;

  const VerifyPhoneChallengeData({
    required this.outcome,
    this.accessToken,
    this.refreshToken,
    required this.user,
    this.onboarding,
  });

  bool get isSignedUp => outcome.toUpperCase() == 'SIGNED_UP';

  factory VerifyPhoneChallengeData.fromJson(Map<String, dynamic> json) {
    final rawUser = json['user'];
    final userMap = rawUser is Map<String, dynamic>
        ? Map<String, dynamic>.from(rawUser)
        : <String, dynamic>{};

    // Tolère `role` sous forme de chaîne ("customer") ou d'objet ({"name": "customer"})
    final rawRole = userMap['role'];
    if (rawRole is String) {
      userMap['role'] = {'name': rawRole};
    } else if (rawRole is! Map<String, dynamic>) {
      userMap['role'] = const {'name': 'customer'};
    }

    // Tolère `additionalData` absent ou null
    if (userMap['additionalData'] is! Map<String, dynamic>) {
      userMap['additionalData'] = const <String, dynamic>{};
    }

    final rawOnboarding = json['onboarding'];

    return VerifyPhoneChallengeData(
      outcome: json['outcome']?.toString() ?? 'SIGNED_IN',
      accessToken: json['accessToken']?.toString(),
      refreshToken: json['refreshToken']?.toString(),
      user: UserModel.fromJson(userMap),
      onboarding: rawOnboarding is Map<String, dynamic>
          ? PhoneAuthOnboardingModel.fromJson(rawOnboarding)
          : const PhoneAuthOnboardingModel(status: 'NOT_REQUIRED'),
    );
  }

  Map<String, dynamic> toJson() => {
        'outcome': outcome,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'user': user.toJson(),
        if (onboarding != null) 'onboarding': onboarding!.toJson(),
      };
}

class VerifyPhoneChallengeResponse {
  final VerifyPhoneChallengeData data;

  const VerifyPhoneChallengeResponse({required this.data});

  factory VerifyPhoneChallengeResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return VerifyPhoneChallengeResponse(
      data: VerifyPhoneChallengeData.fromJson(
        rawData is Map<String, dynamic>
            ? rawData
            : <String, dynamic>{
                'user': const UserModel(
                  role: RoleModel(name: 'customer'),
                  additionalData: AdditionalDataModel(),
                ).toJson(),
              },
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data.toJson(),
      };
}

class ProfileRequiredException implements Exception {
  final String challengeId;
  final List<String> profileFieldsRequired;
  final String? message;

  const ProfileRequiredException({
    required this.challengeId,
    this.profileFieldsRequired = const ['firstName', 'lastName', 'birthDate'],
    this.message,
  });
}

