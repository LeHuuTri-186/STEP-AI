import 'package:step_ai/core/data/model/current_user_model.dart';
import 'package:step_ai/core/usecases/use_case.dart';
import 'package:step_ai/features/chat/domain/repository/conversation_repository.dart';

class GetCurrentUserUsecase extends UseCase<CurrentUserModel, void> {
  ConversationRepository _conversationRepository;
  GetCurrentUserUsecase(this._conversationRepository);
  @override
  Future<CurrentUserModel> call({required void params}) {
    return _conversationRepository.getCurrentUser();
  }
}

