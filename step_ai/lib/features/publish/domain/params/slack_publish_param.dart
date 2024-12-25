import 'package:step_ai/features/chat/domain/entity/assistant.dart';

class SlackPublishParam{
  final String botToken;
  final String clientId;
  final String clientSecret;
  final String signingSecret;
  final Assistant assistant;

  SlackPublishParam({
    required this.botToken,
    required this.clientId,
    required this.clientSecret,
    required this.signingSecret, 
    required this.assistant});
}