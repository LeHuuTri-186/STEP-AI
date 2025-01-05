import 'dart:async';

import 'package:step_ai/core/data/model/detailed_messages_model.dart';
import 'package:step_ai/core/usecases/use_case.dart';
import 'package:step_ai/features/chat/domain/entity/message.dart';
import 'package:step_ai/features/chat/domain/repository/conversation_repository.dart';

class GetMessagesByConversationIdUsecase
    extends UseCase<DetailedMessagesModel, String> {
  final ConversationRepository _conversationRepository;
  GetMessagesByConversationIdUsecase(this._conversationRepository);

  @override
  Future<DetailedMessagesModel> call({required String params}) {
    return _conversationRepository.getMessagesByConversationId(params);
  }
}
