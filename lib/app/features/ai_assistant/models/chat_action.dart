class ChatActionModel {
  const ChatActionModel({
    required this.id,
    required this.label,
    this.variant,
  });

  final String id;
  final String label;
  final String? variant;

  bool get isPrimary => variant == 'primary';
  bool get isSecondary => variant == 'secondary';
  bool get isTertiary => variant == 'tertiary';

  static ChatActionModel? tryParse(dynamic raw) {
    if (raw is! Map) return null;
    final map = Map<String, dynamic>.from(raw);
    final id = _string(map['id']);
    final label = _string(map['label']);
    if (id == null || label == null) return null;

    return ChatActionModel(
      id: id,
      label: label,
      variant: _string(map['variant']),
    );
  }

  static List<ChatActionModel> parseList(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .map(ChatActionModel.tryParse)
        .whereType<ChatActionModel>()
        .toList(growable: false);
  }

  static String? _string(dynamic value) {
    if (value == null) return null;
    final stringValue = value.toString().trim();
    return stringValue.isEmpty ? null : stringValue;
  }
}

List<String> parseQuickReplies(dynamic raw) {
  if (raw is! List) return const [];
  return raw
      .map((item) => item?.toString().trim())
      .whereType<String>()
      .where((item) => item.isNotEmpty)
      .toList(growable: false);
}
