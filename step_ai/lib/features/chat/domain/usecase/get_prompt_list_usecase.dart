import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/authentication/domain/usecase/logout_usecase.dart';
import 'package:step_ai/features/chat/domain/entity/slash_prompt_list.dart';
import 'package:step_ai/features/chat/domain/repository/slash_prompt_repository.dart';
import 'package:step_ai/shared/usecases/refresh_token_usecase.dart';

class GetPromptListUseCase extends UseCase<SlashPromptList?, String>{
  final SlashPromptRepository _slashPromptRepository;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final LogoutUseCase _logoutUseCase;

  GetPromptListUseCase(
      this._slashPromptRepository,
      this._refreshTokenUseCase,
      this._logoutUseCase);

  @override
  FutureOr<SlashPromptList?> call({required String params}) async {
    try {
      SlashPromptList? list = await
      _slashPromptRepository.getPromptList(params);

      if (list == null) {
        return null;
      }
      if (list.prompts.isEmpty) {
        return null;
      }

      return list;
    } catch (e){
      if (e == 401) {
        int statusCode = await _refreshTokenUseCase.call(params: null);
        if (statusCode == 200) {
          call(params: params);
        }
        //Even 401 or not
        else {
          await _logoutUseCase.call(params: null);
          throw ('Exit');
        }
      }
      else {
        throw('Status $e from API SearchPrompt');
      }
    }
    return null;
  }
}