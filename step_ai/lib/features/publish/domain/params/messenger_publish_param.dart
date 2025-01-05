import 'package:step_ai/features/chat/domain/entity/assistant.dart';

class MessengerPublishParam{
  final String botToken;
  final String pageId;
  final String appSecret;
  final Assistant assistant;

  MessengerPublishParam({required this.botToken, required this.pageId, required this.appSecret, required this.assistant});
}