import 'package:step_ai/core/data/model/conversation_model.dart';
import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/chat/domain/repository/conversation_repository.dart';

class GetHistoryConversationListUsecase
    extends UseCase<ConversationModel, int> {
  ConversationRepository _conversationRepository;
  GetHistoryConversationListUsecase(this._conversationRepository);
  @override
  Future<ConversationModel> call({required int params}) async {
    //print("-------------------------><<<<<<<<<");
    final a = await _conversationRepository.getHistoryConversationList(params);
    //print("-------------------------><<<<<<<<<1c"); 
    print(a);
    return a;
  }
}
