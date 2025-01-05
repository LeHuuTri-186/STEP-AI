import 'dart:async';

import 'package:step_ai/core/usecases/use_case.dart';
import 'package:step_ai/features/authentication/domain/usecase/logout_usecase.dart';
import 'package:step_ai/features/chat/domain/entity/slash_prompt.dart';
import 'package:step_ai/features/chat/domain/entity/slash_prompt_list.dart';
import 'package:step_ai/features/chat/domain/repository/slash_prompt_repository.dart';
import 'package:step_ai/shared/usecases/refresh_token_usecase.dart';

class GetFeaturedPromptUseCase extends UseCase<List<SlashPrompt>?, int>{
  final SlashPromptRepository _slashPromptRepository;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final LogoutUseCase _logoutUseCase;

  GetFeaturedPromptUseCase(
      this._slashPromptRepository,
      this._refreshTokenUseCase,
      this._logoutUseCase);

  @override
  FutureOr<List<SlashPrompt>> call({int params = 3}) async {
    try {
      List<SlashPrompt>? list = await
      _slashPromptRepository.getFeaturedPrompt(offset: params);

      if (list == null) {
        return [];
      }
      if (list.isEmpty) {
        return [];
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
        }
      }
      else {
        await _logoutUseCase.call(params: null);
      }
    }
    return [];
  }
}