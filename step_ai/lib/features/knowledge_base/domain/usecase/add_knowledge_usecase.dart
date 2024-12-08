import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/knowledge_base/domain/entity/knowledge.dart';
import 'package:step_ai/features/knowledge_base/domain/params/add_knowledge_param.dart';
import 'package:step_ai/features/knowledge_base/domain/repository/knowledge_repository.dart';

class AddKnowledgeUsecase extends UseCase<void, AddKnowledgeParam> {
  KnowledgeRepository _knowledgeRepository;
  AddKnowledgeUsecase(this._knowledgeRepository);
  @override
  Future<void> call({required AddKnowledgeParam params}) {
    return _knowledgeRepository.addKnowledge(params);
  }
}
