import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/knowledge_base/domain/entity/knowledge_list.dart';
import 'package:step_ai/features/knowledge_base/domain/repository/knowledge_repository.dart';

class GetKnowledgeListUsecase extends UseCase<KnowledgeList, void> {
  KnowledgeRepository _knowledgeRepository;
  GetKnowledgeListUsecase(this._knowledgeRepository);
  @override
  Future<KnowledgeList> call({required void params}) {
    return _knowledgeRepository.getKnowledgeList();
  }
}
