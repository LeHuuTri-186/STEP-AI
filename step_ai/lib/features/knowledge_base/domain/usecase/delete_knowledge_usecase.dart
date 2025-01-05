import 'package:dio/dio.dart';
import 'package:step_ai/core/usecases/use_case.dart';
import 'package:step_ai/features/authentication/domain/usecase/logout_usecase.dart';
import 'package:step_ai/features/knowledge_base/domain/repository/knowledge_repository.dart';
import 'package:step_ai/shared/usecases/refresh_kb_token_usecase.dart';

class DeleteKnowledgeUsecase extends UseCase<void, String> {
  final KnowledgeRepository _knowledgeRepository;
  RefreshKbTokenUseCase refreshKbTokenUseCase;
  LogoutUseCase logoutUseCase;

  DeleteKnowledgeUsecase(this._knowledgeRepository, this.refreshKbTokenUseCase,
      this.logoutUseCase);

  @override
  Future<void> call({required String params}) async {
    try {
      return await _knowledgeRepository.deleteKnowledge(params);
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          int isKBRefreshSuccess =
              await refreshKbTokenUseCase.call(params: null);
          if (isKBRefreshSuccess == 200) {
            return await call(params: params);
          }
          await logoutUseCase.call(params: null);
          rethrow;
        }
        //if no internet connection example
        rethrow;
      }
      //print(e);
      rethrow;
    }
  }
}
