import 'package:flutter/cupertino.dart';
import 'package:step_ai/config/enum/request_response.dart';
import 'package:step_ai/features/authentication/domain/usecase/logout_usecase.dart';
import 'package:step_ai/features/personal/data/models/bot_list_res_dto.dart';
import 'package:step_ai/features/personal/data/models/bot_model.dart';
import 'package:step_ai/features/personal/data/models/bot_res_dto.dart';
import 'package:step_ai/features/personal/domain/usecase/create_bot_usecase.dart';
import 'package:step_ai/features/personal/domain/usecase/delete_bot_usecase.dart';
import 'package:step_ai/features/personal/domain/usecase/get_bot_list_usecase.dart';
import 'package:step_ai/features/personal/domain/usecase/update_bot_usecase.dart';

class BotListNotifier extends ChangeNotifier{
  //Observing value
  BotListResDto bots = BotListResDto(data: [], meta: null);

  //Loading
  bool isLoading = false;

  //Usecase
  final CreateBotUseCase _createBotUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetBotListUseCase _getBotListUseCase;
  final DeleteBotUseCase _deleteBotUseCase;
  final UpdateBotUseCase _updateBotUseCase;

  BotListNotifier(
      this._createBotUseCase, this._logoutUseCase, this._getBotListUseCase, this._deleteBotUseCase, this._updateBotUseCase);

  Future<RequestResponse> createBot(BotModel bot) async{
    isLoading = true;
    notifyListeners();

    int responseCode = await _createBotUseCase.call(params: bot);

    isLoading = false;
    notifyListeners();

    if (responseCode == 201) {
      return RequestResponse.success;
    }
    if (responseCode == 401) {
      _logoutUseCase.call(params: null);
      return RequestResponse.unauthorized;
    }

    return RequestResponse.failed;
  }

  Future<RequestResponse> getBots(String? query) async {
    isLoading = true;
    notifyListeners();

    try {
      BotListResDto? temp = await _getBotListUseCase.call(params: query);
      if (temp != null) bots = temp;

      isLoading = false;
      notifyListeners();

    } catch (e) {
      if (e == 401) {
        _logoutUseCase.call(params: null);
        return RequestResponse.unauthorized;
      }
      else {
        return RequestResponse.failed;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return RequestResponse.success;

  }

  Future<RequestResponse> deleteBot(BotResDto bot) async{
    isLoading = true;
    notifyListeners();

    try {
      await _deleteBotUseCase.call(params: bot);
    } catch (e){
      if (e == 401) {
        await _logoutUseCase.call(params: null);
        return RequestResponse.unauthorized;
      }
      else {
        return RequestResponse.failed;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return RequestResponse.success;
  }
  //

  Future<RequestResponse> updateBot(BotResDto bot) async{
    isLoading = true;
    notifyListeners();

    try {
      int code = await _updateBotUseCase.call(params: bot);
      print(code);
    } catch (e) {
      if (e == 401) {
        await _logoutUseCase.call(params: null);
        return RequestResponse.unauthorized;
      }
      else {
        return RequestResponse.failed;
      }
    }finally {
      isLoading = false;
      notifyListeners();
    }
    return RequestResponse.success;
  }
}