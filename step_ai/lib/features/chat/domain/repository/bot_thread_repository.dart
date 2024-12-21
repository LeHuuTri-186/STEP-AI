import 'package:step_ai/features/chat/domain/entity/thread_dto.dart';
import 'package:step_ai/features/chat/domain/params/thread_chat_param.dart';

abstract class BotThreadRepository {
  Future<ThreadDto?> createThread(String? botId);
  Future<String> askBotInThread(ThreadChatParam params);

  Future<int> getMessageHistory(String threadId);
}