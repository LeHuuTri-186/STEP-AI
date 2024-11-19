import 'package:step_ai/features/chat/domain/entity/message.dart';
import 'package:step_ai/features/chat/domain/params/send_message_param.dart';

import '../../../../core/data/model/message_model.dart';

abstract class ConversationRepository {
  Future<MessageModel> sendMessage(SendMessageParam params);
  Future<void> getMessagesByConversationId(String idConversation);
}