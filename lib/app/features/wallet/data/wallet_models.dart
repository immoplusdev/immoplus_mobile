/// Modèles du coffre client (`/wallet/...`). Parsing tolérant : un champ
/// absent ou inattendu ne casse jamais l'écran.

double _toDouble(Object? value) =>
    value is num ? value.toDouble() : double.tryParse('$value') ?? 0;

DateTime? _toDate(Object? value) =>
    value == null ? null : DateTime.tryParse(value.toString())?.toLocal();

/// Solde du coffre.
class WalletModel {
  const WalletModel({
    required this.availableBalance,
    required this.pendingBalance,
    required this.currency,
  });

  /// Montant retirable.
  final double availableBalance;

  /// Montant en cours de libération.
  final double pendingBalance;
  final String currency;

  bool get canWithdraw => availableBalance > 0;

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map ? json['data'] as Map : json;
    return WalletModel(
      availableBalance: _toDouble(data['availableBalance']),
      pendingBalance: _toDouble(data['pendingBalance']),
      currency: data['currency']?.toString() ?? 'XOF',
    );
  }
}

enum WalletTransactionType {
  credit('CREDIT'),
  debit('DEBIT'),
  block('BLOCK'),
  unblock('UNBLOCK'),
  withdrawal('WITHDRAWAL'),
  unknown('');

  const WalletTransactionType(this.value);

  final String value;

  static WalletTransactionType fromValue(String? value) =>
      WalletTransactionType.values.firstWhere(
        (type) => type.value == value,
        orElse: () => WalletTransactionType.unknown,
      );

  /// Le mouvement augmente le solde disponible.
  bool get isIncoming => this == credit || this == unblock;

  String get label => switch (this) {
        credit => 'Crédit',
        debit => 'Débit',
        block => 'Montant bloqué',
        unblock => 'Montant libéré',
        withdrawal => 'Retrait',
        unknown => 'Mouvement',
      };
}

/// Un mouvement du coffre.
class WalletTransactionModel {
  const WalletTransactionModel({
    required this.id,
    required this.amount,
    required this.currency,
    required this.type,
    this.reference,
    this.note,
    this.createdAt,
  });

  final String id;
  final double amount;
  final String currency;
  final WalletTransactionType type;
  final String? reference;
  final String? note;
  final DateTime? createdAt;

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) =>
      WalletTransactionModel(
        id: json['id']?.toString() ?? '',
        amount: _toDouble(json['amount']),
        currency: json['currency']?.toString() ?? 'XOF',
        type: WalletTransactionType.fromValue(json['type']?.toString()),
        reference: json['reference']?.toString(),
        note: json['note']?.toString(),
        createdAt: _toDate(json['createdAt']),
      );
}

enum WithdrawalStatus {
  pending('PENDING'),
  approved('APPROVED'),
  rejected('REJECTED'),
  completed('COMPLETED'),
  failed('FAILED'),
  unknown('');

  const WithdrawalStatus(this.value);

  final String value;

  static WithdrawalStatus fromValue(String? value) =>
      WithdrawalStatus.values.firstWhere(
        (status) => status.value == value?.toUpperCase(),
        orElse: () => WithdrawalStatus.unknown,
      );

  String get label => switch (this) {
        pending => 'En attente',
        approved => 'Approuvé',
        rejected => 'Refusé',
        completed => 'Effectué',
        failed => 'Échoué',
        unknown => 'En cours',
      };
}

/// Une demande de retrait du solde.
class WithdrawalRequestModel {
  const WithdrawalRequestModel({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    this.note,
    this.createdAt,
  });

  final String id;
  final double amount;
  final String currency;
  final WithdrawalStatus status;
  final String? note;
  final DateTime? createdAt;

  factory WithdrawalRequestModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map ? json['data'] as Map : json;
    return WithdrawalRequestModel(
      id: data['id']?.toString() ?? '',
      amount: _toDouble(data['amount']),
      currency: data['currency']?.toString() ?? 'XOF',
      status: WithdrawalStatus.fromValue(data['status']?.toString()),
      note: data['note']?.toString(),
      createdAt: _toDate(data['createdAt']),
    );
  }
}

/// Une page de résultats paginés.
class PagedResult<T> {
  const PagedResult({required this.items, required this.hasNext});

  final List<T> items;
  final bool hasNext;

  factory PagedResult.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson,
  ) {
    final raw = json['data'];
    return PagedResult(
      items: raw is List
          ? raw
              .whereType<Map>()
              .map((e) => itemFromJson(Map<String, dynamic>.from(e)))
              .toList()
          : <T>[],
      hasNext: json['hasNext'] == true,
    );
  }
}

/// Corps de `POST /wallet/withdrawal-request/create`.
class WithdrawalRequestBody {
  const WithdrawalRequestBody({
    required this.amount,
    required this.phoneNumber,
    required this.operator,
    this.currency = 'XOF',
    this.note,
  });

  final num amount;
  final String phoneNumber;

  /// Valeur d'opérateur de l'API (`wave`, `orange`, `mtn`, `moov`…).
  final String operator;
  final String currency;
  final String? note;

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'currency': currency,
        'phoneNumber': phoneNumber,
        'operator': operator,
        if (note != null && note!.trim().isNotEmpty) 'note': note!.trim(),
      };
}
