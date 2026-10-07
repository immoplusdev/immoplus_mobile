class ClientGuidanceResponse {
  const ClientGuidanceResponse({required this.version, required this.rules});

  final int version;
  final List<ClientGuidanceRule> rules;

  factory ClientGuidanceResponse.fromJson(Map<String, dynamic> json) {
    final rules = (json['rules'] as List? ?? const [])
        .whereType<Map>()
        .map((item) => ClientGuidanceRule.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .where((rule) => rule.isValid)
        .toList(growable: true);
    final sourceOrder = <ClientGuidanceRule, int>{
      for (var index = 0; index < rules.length; index++) rules[index]: index,
    };
    rules.sort((a, b) {
      final priorityOrder = b.priority.compareTo(a.priority);
      return priorityOrder != 0
          ? priorityOrder
          : sourceOrder[a]!.compareTo(sourceOrder[b]!);
    });
    return ClientGuidanceResponse(
      version: (json['version'] as num?)?.toInt() ?? 0,
      rules: rules,
    );
  }

  Map<String, dynamic> toJson() => {
        'version': version,
        'rules': rules.map((rule) => rule.toJson()).toList(growable: false),
      };
}

class ClientGuidanceRule {
  const ClientGuidanceRule({
    required this.id,
    required this.enabled,
    required this.priority,
    required this.phrases,
    required this.conversationTypes,
    required this.requiresAnyAction,
    required this.presentation,
    required this.title,
    required this.body,
    required this.ctaLabel,
    required this.intent,
    required this.maxShowsPerConversation,
  });

  static const allowedIntents = {
    'pick_dates',
    'book_now',
    'pay_reservation',
    'cancel_reservation',
    'open_checkin_qr',
    'rate_stay',
    'open_support',
  };

  final String id;
  final bool enabled;
  final int priority;
  final List<String> phrases;
  final List<String> conversationTypes;
  final List<String> requiresAnyAction;
  final String presentation;
  final String title;
  final String body;
  final String ctaLabel;
  final String intent;
  final int maxShowsPerConversation;

  bool get isValid =>
      id.isNotEmpty &&
      enabled &&
      phrases.isNotEmpty &&
      presentation == 'suggestion' &&
      allowedIntents.contains(intent) &&
      title.isNotEmpty &&
      body.isNotEmpty &&
      ctaLabel.isNotEmpty &&
      maxShowsPerConversation > 0;

  factory ClientGuidanceRule.fromJson(Map<String, dynamic> json) =>
      ClientGuidanceRule(
        id: json['id']?.toString() ?? '',
        enabled: json['enabled'] != false,
        priority: (json['priority'] as num?)?.toInt() ?? 0,
        phrases: _strings(json['phrases']),
        conversationTypes: _strings(json['conversationTypes']),
        requiresAnyAction:
            _strings(json['requiresAnyAction'] ?? json['requiresAnyActions']),
        presentation: json['presentation']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        body: json['body']?.toString() ?? '',
        ctaLabel: json['ctaLabel']?.toString() ?? '',
        intent: json['intent']?.toString() ?? '',
        maxShowsPerConversation:
            (json['maxShowsPerConversation'] as num?)?.toInt() ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'enabled': enabled,
        'priority': priority,
        'phrases': phrases,
        'conversationTypes': conversationTypes,
        'requiresAnyAction': requiresAnyAction,
        'presentation': presentation,
        'title': title,
        'body': body,
        'ctaLabel': ctaLabel,
        'intent': intent,
        'maxShowsPerConversation': maxShowsPerConversation,
      };
}

List<String> _strings(dynamic value) => value is List
    ? value
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false)
    : const [];
