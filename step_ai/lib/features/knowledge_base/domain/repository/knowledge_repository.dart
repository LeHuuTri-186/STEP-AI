import 'package:step_ai/features/knowledge_base/data/model/knowledge_list_model.dart';
import 'package:step_ai/features/knowledge_base/domain/params/edit_knowledge_param.dart';
import 'package:step_ai/features/knowledge_base/domain/params/get_knowledges_param.dart';
import 'package:step_ai/features/knowledge_base/domain/params/knowledge_param.dart';

abstract class KnowledgeRepository {
  Future<KnowledgeListModel> getKnowledgeList(GetKnowledgesParam params);
  Future<void> addKnowledge(KnowledgeParam params);
  Future<void> deleteKnowledge(String id);
  Future<void> editKnowledge(EditKnowledgeParam params);
}
