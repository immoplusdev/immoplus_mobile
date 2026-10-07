/// Modèle agnostique d'un message / notification push.
/// Découple la couche métier et UI des structures propres à chaque SDK (Firebase, OneSignal, etc.).
class PushMessage {
  final String? messageId;
  final String? title;
  final String? body;
  final Map<String, dynamic> data;

  const PushMessage({
    this.messageId,
    this.title,
    this.body,
    this.data = const {},
  });

  @override
  String toString() =>
      'PushMessage(messageId: $messageId, title: $title, body: $body, data: $data)';
}
