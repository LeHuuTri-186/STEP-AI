import 'package:step_ai/core/data/model/conversation_model.dart';
import 'package:step_ai/core/data/model/current_user_model.dart';
import 'package:step_ai/core/data/model/detailed_messages_model.dart';
import 'package:step_ai/core/data/model/usage_token_model.dart';
import 'package:step_ai/features/chat/domain/params/send_message_param.dart';

import '../../../../core/data/model/message_model.dart';

abstract class ConversationRepository {
  Future<MessageModel> sendMessage(SendMessageParam params);
  Future<DetailedMessagesModel> getMessagesByConversationId(String idConversation);
  Future<ConversationModel> getHistoryConversationList(int limit);
  Future<UsageTokenModel> getUsageToken();
  Future<CurrentUserModel> getCurrentUser();
}