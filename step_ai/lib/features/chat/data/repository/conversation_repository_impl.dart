import 'package:step_ai/features/chat/domain/entity/message.dart';
import 'package:step_ai/features/chat/domain/repository/conversation_repository.dart';

class ConversationRepositoryImpl extends ConversationRepository {
  @override
  Future<void> getMessagesByConversationId(String idConversation) {
    // TODO: implement getMessages
    throw UnimplementedError();
  }

  @override
  Future<Message> sendMessage(List<Message> historyMessages) async {
    await Future.delayed(Duration(seconds: 2));
    return Message(
        assistant: historyMessages.last.assistant,
        role: "model",
        content: "Hello");
  }
}
