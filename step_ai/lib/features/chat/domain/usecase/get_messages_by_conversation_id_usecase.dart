import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/chat/domain/entity/message.dart';
import 'package:step_ai/features/chat/domain/repository/conversation_repository.dart';

class GetMessagesByConversationIdUsecase extends UseCase<List<Message>, String> {
  final ConversationRepository _conversationRepository;
  GetMessagesByConversationIdUsecase(this._conversationRepository);

  @override
  Future<List<Message>> call({required String params}) {
    // TODO: implement call
    throw UnimplementedError();
  }

}