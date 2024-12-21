import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/knowledge_base/data/model/knowledge_list_model.dart';
import 'package:step_ai/features/knowledge_base/domain/params/get_knowledges_param.dart';
import 'package:step_ai/features/knowledge_base/domain/repository/knowledge_repository.dart';

class GetKnowledgeListUsecase
    extends UseCase<KnowledgeListModel, GetKnowledgesParam> {
  KnowledgeRepository _knowledgeRepository;
  GetKnowledgeListUsecase(this._knowledgeRepository);
  @override
  Future<KnowledgeListModel> call({required GetKnowledgesParam params}) {
    return _knowledgeRepository.getKnowledgeList(params);
  }
}
