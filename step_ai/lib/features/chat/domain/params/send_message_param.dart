import 'package:step_ai/features/chat/domain/entity/message.dart';

class SendMessageParam {
  final List<Message> historyMessages;
  String? conversationId;
  SendMessageParam({
    required this.historyMessages,
    this.conversationId,
  });
}