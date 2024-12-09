import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/knowledge_base/domain/repository/knowledge_repository.dart';

class DeleteKnowledgeUsecase extends UseCase<void, String> {
  final KnowledgeRepository _knowledgeRepository;

  DeleteKnowledgeUsecase(this._knowledgeRepository);

  @override
  Future<void> call({required String params}) async {
    return _knowledgeRepository.deleteKnowledge(params);
  }
}
