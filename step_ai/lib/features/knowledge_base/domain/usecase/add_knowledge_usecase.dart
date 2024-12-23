import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/knowledge_base/domain/params/knowledge_param.dart';
import 'package:step_ai/features/knowledge_base/domain/repository/knowledge_repository.dart';

class AddKnowledgeUsecase extends UseCase<void, KnowledgeParam> {
  KnowledgeRepository _knowledgeRepository;
  AddKnowledgeUsecase(this._knowledgeRepository);
  @override
  Future<void> call({required KnowledgeParam params}) {
    return _knowledgeRepository.addKnowledge(params);
  }
}
