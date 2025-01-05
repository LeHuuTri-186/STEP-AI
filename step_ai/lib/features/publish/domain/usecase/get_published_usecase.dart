import 'dart:async';
import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/chat/domain/entity/assistant.dart';
import 'package:step_ai/features/publish/domain/entity/published.dart';
import 'package:step_ai/features/publish/domain/repository/publisher_repository.dart';
import 'package:step_ai/shared/usecases/refresh_kb_token_usecase.dart';

class GetPublishedUseCase extends UseCase<List<Published>, Assistant> {
  final RefreshKbTokenUseCase _refresher;
  final PublisherRepository _publisherRepository;

  GetPublishedUseCase(this._refresher, this._publisherRepository);
  @override
  Future<List<Published>> call({required Assistant params}) async{
    try{
      return await _publisherRepository.getPublished(params);
    }
    catch (e){
      if (e is int) {
        if (e == 401) {
          try {
            int innerCode = await _refresher.call(params: null);
            if (innerCode == 200) return call(params: params);
          }
          catch (e){
            rethrow;
          }
        }
      }
      else {
        rethrow;
      }
    }
    throw -1;
  }

}