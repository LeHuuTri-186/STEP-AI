import 'package:step_ai/features/chat/domain/entity/assistant.dart';

class TelegramPublishParam{
  final String botToken;
  final Assistant assistant;

  TelegramPublishParam(this.botToken, this.assistant);
}