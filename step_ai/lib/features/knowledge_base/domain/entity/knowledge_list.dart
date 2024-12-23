import 'package:step_ai/features/knowledge_base/data/model/knowledge_list_model.dart';
import 'package:step_ai/features/knowledge_base/domain/entity/knowledge.dart';

class KnowledgeList {
  List<Knowledge> knowledgeList;
  KnowledgeList({required this.knowledgeList});
  factory KnowledgeList.fromModel(KnowledgeListModel model) {
    List<Knowledge> knowledgeList = [];
    for (var knowledge in model.knowledgeListModel) {
      knowledgeList.add(Knowledge.fromModel(knowledge));
    }
    return KnowledgeList(knowledgeList: knowledgeList);
  }
}
