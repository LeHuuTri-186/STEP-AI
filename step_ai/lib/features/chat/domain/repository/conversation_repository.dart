import 'package:step_ai/features/chat/domain/entity/message.dart';
import 'package:step_ai/features/chat/domain/params/send_message_param.dart';

abstract class ConversationRepository {
  Future<Message> sendMessage(SendMessageParam params);
  Future<void> getMessagesByConversationId(String idConversation);
}