

import '../../../knowledge_base/data/model/knowledge_model.dart';

class BotModel{
  final String name;
  final String description;
  final List<KnowledgeModel> kbList;

  BotModel({required this.name, required this.description, required this.kbList});

  BotModel copyWith({ String? name, String? description, List<KnowledgeModel>? kbList}) {
    return BotModel(
        name: name?? this.name,
        description: description?? this.description,
        kbList: kbList ?? this.kbList
    );
  }
}