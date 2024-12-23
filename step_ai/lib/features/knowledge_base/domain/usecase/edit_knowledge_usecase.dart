import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/knowledge_base/domain/params/edit_knowledge_param.dart';
import 'package:step_ai/features/knowledge_base/domain/repository/knowledge_repository.dart';

class EditKnowledgeUsecase extends UseCase<void,EditKnowledgeParam>{
  KnowledgeRepository _knowledgeRepository;
  EditKnowledgeUsecase(this._knowledgeRepository);
  @override
  Future<void> call({required EditKnowledgeParam params}) {
    return _knowledgeRepository.editKnowledge(params);
  }
}