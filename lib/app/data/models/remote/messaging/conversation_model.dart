import 'package:freezed_annotation/freezed_annotation.dart';
import 'message_model.dart';

part 'conversation_model.freezed.dart';
part 'conversation_model.g.dart';

enum ConversationStatus {
  active('active'),
  blocked('blocked');

  final String value;
  const ConversationStatus(this.value);

  static ConversationStatus fromString(String? value) {
    return ConversationStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ConversationStatus.active,
    );
  }
}

enum ConversationType {
  reservation('reservation'),
  visite('visite'),
  support('support'),
  relais('relais');

  final String value;
  const ConversationType(this.value);

  static ConversationType fromString(String? value) {
    return ConversationType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ConversationType.reservation,
    );
  }
}

final _actionsByConversationId = <String, List<MessagingAction>>{};
final _readOnlyConversationIds = <String>{};
final _contextByConversationId = <String, Map<String, dynamic>>{};
final _stageByConversationId = <String, String?>{};
final _pendingActionForByConversationId = <String, String?>{};
final _pendingActionDueAtByConversationId = <String, DateTime?>{};

@freezed
class ConversationModel with _$ConversationModel {
  const ConversationModel._();

  const factory ConversationModel({
    required String id,
    @Default('reservation') String type,

    /// Non-null seulement pour `type == reservation`.
    String? residenceId,

    /// Non-null seulement pour `type == visite`.
    String? visiteId,

    /// Non-null seulement pour `type == relais`.
    String? relaisId,

    /// Toujours `null` pour `type == support` (boîte partagée, pas
    /// d'interlocuteur fixe).
    String? proId,
    required String clientId,
    @Default('active') String status,
    @Default(0) int unreadCountClient,
    @Default(0) int unreadCountPro,
    String? lastMessagePreview,
    DateTime? lastMessageAt,
    DateTime? createdAt,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(_processJson(json));

  static Map<String, dynamic> _processJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';
    if (json['readOnly'] == true) {
      _readOnlyConversationIds.add(id);
    } else {
      _readOnlyConversationIds.remove(id);
    }
    _actionsByConversationId[id] = (json['actions'] as List? ?? const [])
        .whereType<Map>()
        .map((action) =>
            MessagingAction.fromJson(Map<String, dynamic>.from(action)))
        .toList(growable: false);
    _contextByConversationId[id] = json['context'] is Map
        ? Map<String, dynamic>.from(json['context'] as Map)
        : const {};
    _stageByConversationId[id] = json['stage']?.toString();
    _pendingActionForByConversationId[id] =
        json['pendingActionFor']?.toString();
    _pendingActionDueAtByConversationId[id] = json['pendingActionDueAt'] == null
        ? null
        : DateTime.tryParse(json['pendingActionDueAt'].toString());
    return json;
  }

  List<MessagingAction> get actions =>
      _actionsByConversationId[id] ?? const <MessagingAction>[];
  Map<String, dynamic> get context =>
      _contextByConversationId[id] ?? const <String, dynamic>{};
  String? get stage => _stageByConversationId[id];
  String? get pendingActionFor => _pendingActionForByConversationId[id];
  DateTime? get pendingActionDueAt => _pendingActionDueAtByConversationId[id];

  /// Le contrat peut verrouiller un fil sans nécessairement changer son
  /// statut. Dans les deux cas, l'historique reste visible mais aucune action
  /// ni aucun envoi ne doit être proposé.
  bool get isReadOnly =>
      statusEnum == ConversationStatus.blocked ||
      _readOnlyConversationIds.contains(id);

  ConversationStatus get statusEnum => ConversationStatus.fromString(status);
  ConversationType get typeEnum => ConversationType.fromString(type);
}
