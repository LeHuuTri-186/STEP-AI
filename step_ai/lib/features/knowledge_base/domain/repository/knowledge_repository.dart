import 'package:step_ai/features/knowledge_base/domain/entity/knowledge_list.dart';
import 'package:step_ai/features/knowledge_base/domain/params/add_knowledge_param.dart';

abstract class KnowledgeRepository {
  Future<KnowledgeList> getKnowledgeList();
  Future<void> addKnowledge(AddKnowledgeParam params);
  Future<void> deleteKnowledge(String id);
}
