import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/chat/domain/entity/message.dart';
import 'package:step_ai/features/chat/domain/params/send_message_param.dart';
import 'package:step_ai/features/chat/domain/repository/conversation_repository.dart';

class SendMessageUsecase extends UseCase<Message, SendMessageParam> {
  ConversationRepository _conversationRepository;
  SendMessageUsecase(this._conversationRepository);
  @override
  Future<Message> call({required SendMessageParam params}) {
    return _conversationRepository.sendMessage(params);
  }
}
