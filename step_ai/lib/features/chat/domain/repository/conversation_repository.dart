import 'package:step_ai/features/chat/domain/entity/message.dart';

abstract class ConversationRepository {
  Future<Message> sendMessage(List<Message> historyMessages);
  Future<void> getMessagesByConversationId(String idConversation);
}