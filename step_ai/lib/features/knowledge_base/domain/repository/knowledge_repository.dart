import 'package:step_ai/features/knowledge_base/domain/entity/knowledge_list.dart';
import 'package:step_ai/features/knowledge_base/domain/params/edit_knowledge_param.dart';
import 'package:step_ai/features/knowledge_base/domain/params/knowledge_param.dart';

abstract class KnowledgeRepository {
  Future<KnowledgeList> getKnowledgeList();
  Future<void> addKnowledge(KnowledgeParam params);
  Future<void> deleteKnowledge(String id);
  Future<void> editKnowledge(EditKnowledgeParam params);
}
