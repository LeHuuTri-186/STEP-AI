import 'package:step_ai/features/knowledge_base/data/model/knowledge_model.dart';

class Knowledge {
  DateTime createdAt;
  DateTime updatedAt;
  String createdBy;
  String updatedBy;
  String userId;
  String knowledgeName;
  String description; 
  String id;
  int numberUnits;
  int totalSize;
  Knowledge(
      {required this.createdAt,
      required this.updatedAt,
      required this.createdBy,
      required this.updatedBy,
      required this.userId,
      required this.knowledgeName,
      required this.description,
      required this.id,
      required this.numberUnits,
      required this.totalSize});
  factory Knowledge.fromModel(KnowledgeModel model) {
    return Knowledge(
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
        createdBy: model.createdBy,
        updatedBy: model.updatedBy,
        userId: model.userId,
        knowledgeName: model.knowledgeName,
        description: model.description,
        id: model.id,
        numberUnits: model.numberUnits,
        totalSize: model.totalSize);
  }
}
