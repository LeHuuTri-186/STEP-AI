import 'package:step_ai/features/knowledge_base/data/model/knowledge_list_model.dart';
import 'package:step_ai/features/knowledge_base/data/network/knowledge_api.dart';
import 'package:step_ai/features/knowledge_base/domain/entity/knowledge.dart';
import 'package:step_ai/features/knowledge_base/domain/entity/knowledge_list.dart';
import 'package:step_ai/features/knowledge_base/domain/params/add_knowledge_param.dart';
import 'package:step_ai/features/knowledge_base/domain/repository/knowledge_repository.dart';

class KnowledgeRepositoryImpl extends KnowledgeRepository {
  KnowledgeApi _knowledgeApi;
  KnowledgeRepositoryImpl(this._knowledgeApi);
  @override
  Future<KnowledgeList> getKnowledgeList() async {
    //get knowledge list from api
    try {
      Map<String, dynamic> queryParams = {
        "limit": 10,
      };

      final response = await _knowledgeApi.get("/kb-core/v1/knowledge",
          queryParams: queryParams);
      KnowledgeListModel knowledgeListModel =
          KnowledgeListModel.fromJson(response.data);
      return KnowledgeList.fromModel(knowledgeListModel);
    } catch (e) {
      print(e);
      rethrow;
    }

    // final knowledgeList = [
    //   Knowledge(
    //     createdAt: DateTime.parse("2024-12-07T04:07:32.378Z"),
    //     updatedAt: DateTime.parse("2024-12-07T04:07:32.378Z"),
    //     createdBy: "",
    //     updatedBy: "",
    //     userId: "bef81008-8819-4c95-b76c-d0807c5413b5",
    //     knowledgeName: "HCMUS Knowledge",
    //     description: "HCMUS Knowledge to ask about HCMUS",
    //     id: "025c39a0-e0b7-457c-8982-23c115e9c215",
    //     numberUnits: 0,
    //     totalSize: 0.0,
    //   ),
    //   Knowledge(
    //     createdAt: DateTime.parse("2024-11-24T09:56:48.432Z"),
    //     updatedAt: DateTime.parse("2024-11-24T09:56:48.432Z"),
    //     createdBy: "",
    //     updatedBy: "",
    //     userId: "bef81008-8819-4c95-b76c-d0807c5413b5",
    //     knowledgeName: "English",
    //     description: "",
    //     id: "901424f0-6c65-4b3b-a431-37091a7255dc",
    //     numberUnits: 2,
    //     totalSize: 308680.0,
    //   ),
    //   Knowledge(
    //     createdAt: DateTime.parse("2024-11-24T09:49:53.008Z"),
    //     updatedAt: DateTime.parse("2024-11-24T09:49:53.008Z"),
    //     createdBy: "",
    //     updatedBy: "",
    //     userId: "bef81008-8819-4c95-b76c-d0807c5413b5",
    //     knowledgeName: "Math",
    //     description: "",
    //     id: "d41a1853-788c-4d22-b821-0576be156c9e",
    //     numberUnits: 1,
    //     totalSize: 9578671.0,
    //   ),
    // ];
    // await Future.delayed(const Duration(seconds: 3));
    // return KnowledgeList(knowledgeList: knowledgeList);
  }

  @override
  Future<void> addKnowledge(AddKnowledgeParam params) {
    return _knowledgeApi.post("/kb-core/v1/knowledge", data: params.toJson());
  }

  @override
  Future<void> deleteKnowledge(String id) {
    return _knowledgeApi.delete("/kb-core/v1/knowledge/$id");
  }
}
