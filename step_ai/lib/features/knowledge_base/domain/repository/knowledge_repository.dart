import 'package:step_ai/features/knowledge_base/domain/entity/knowledge_list.dart';

abstract class KnowledgeRepository {
  Future<KnowledgeList> getKnowledgeList();
}
