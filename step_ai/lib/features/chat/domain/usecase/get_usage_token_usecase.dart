import 'package:step_ai/core/data/model/usage_token_model.dart';
import 'package:step_ai/core/usecases/use_case.dart';
import 'package:step_ai/features/chat/domain/repository/conversation_repository.dart';

class GetUsageTokenUsecase extends UseCase<UsageTokenModel, void> {
  ConversationRepository _conversationRepository;
  GetUsageTokenUsecase(this._conversationRepository);
  @override
  Future<UsageTokenModel> call({required void params}) {
    return _conversationRepository.getUsageToken();
  }
}

