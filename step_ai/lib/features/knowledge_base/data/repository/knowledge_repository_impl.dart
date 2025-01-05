import 'package:step_ai/config/constants.dart';
import 'package:step_ai/features/knowledge_base/data/model/knowledge_list_model.dart';
import 'package:step_ai/features/knowledge_base/data/network/knowledge_api.dart';
import 'package:step_ai/features/knowledge_base/domain/params/edit_knowledge_param.dart';
import 'package:step_ai/features/knowledge_base/domain/params/get_knowledges_param.dart';
import 'package:step_ai/features/knowledge_base/domain/params/knowledge_param.dart';
import 'package:step_ai/features/knowledge_base/domain/repository/knowledge_repository.dart';

class KnowledgeRepositoryImpl extends KnowledgeRepository {
  KnowledgeApi _knowledgeApi;
  KnowledgeRepositoryImpl(this._knowledgeApi);
  @override
  Future<KnowledgeListModel> getKnowledgeList(GetKnowledgesParam params) async {
    //get knowledge list from api
    try {
      Map<String, dynamic> queryParams = {
        "limit": params.limit,
      };

      // final response = await _knowledgeApi.get("/kb-core/v1/knowledge",
      //     queryParams: queryParams);

      final response = await _knowledgeApi.get(Constant.getKnowledgeList,
          queryParams: queryParams);
      KnowledgeListModel knowledgeListModel =
          KnowledgeListModel.fromJson(response.data);
      return knowledgeListModel;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<void> addKnowledge(KnowledgeParam params) {
    // return _knowledgeApi.post("/kb-core/v1/knowledge", data: params.toJson());
    return _knowledgeApi.post(Constant.addKnowledge, data: params.toJson());
  }

  @override
  Future<void> deleteKnowledge(String id) {
    // return _knowledgeApi.delete("/kb-core/v1/knowledge/$id");
    return _knowledgeApi.delete(Constant.deleteKnowledge.replaceAll(":id", id));
  }

  @override
  Future<void> editKnowledge(EditKnowledgeParam params) {
    // return _knowledgeApi.patch("/kb-core/v1/knowledge/${params.id}",
    //     data: params.knowledgeParam.toJson());
    return _knowledgeApi.patch(
        Constant.editKnowledge.replaceAll(":id", params.id),
        data: params.knowledgeParam.toJson());
  }
}
