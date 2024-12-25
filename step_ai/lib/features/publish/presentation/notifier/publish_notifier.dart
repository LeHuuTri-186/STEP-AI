import 'package:flutter/widgets.dart';
import 'package:step_ai/features/authentication/domain/usecase/logout_usecase.dart';
import 'package:step_ai/features/chat/domain/entity/assistant.dart';
import 'package:step_ai/features/publish/domain/entity/telegram_publish.dart';
import 'package:step_ai/features/publish/domain/params/disconnector_param.dart';
import 'package:step_ai/features/publish/domain/params/telegram_param.dart';
import 'package:step_ai/features/publish/domain/params/telegram_publish_param.dart';
import 'package:step_ai/features/publish/domain/usecase/get_published_usecase.dart';
import 'package:step_ai/features/publish/domain/usecase/telegram_disconnect_usecase.dart';
import 'package:step_ai/features/publish/domain/usecase/telegram_publish_usecase.dart';
import 'package:step_ai/features/publish/domain/usecase/telegram_validate_usecase.dart';

class PublishNotifier extends ChangeNotifier{
  bool isLoading = false;
  Assistant? currentAssistant;

  bool isConfiguredSlack = false;
  bool isConfiguredMessenger = false;
  bool isConfiguredTelegram = false;

  List<TelegramPublish> publishedList = [];

  //UC:-------------------------------------------------------------------------
  final GetPublishedUseCase _getPublishedUseCase;
  final TelegramValidateUseCase _telegramValidateUseCase;
  final TelegramPublishUseCase _telegramPublishUseCase;
  final TelegramDisconnectUseCase _telegramDisconnectUseCase;

  final LogoutUseCase _logoutUseCase;

  PublishNotifier(
      this._getPublishedUseCase,
      this._logoutUseCase,
      this._telegramValidateUseCase,
      this._telegramPublishUseCase,
      this._telegramDisconnectUseCase);

  //Methods:--------------------------------------------------------------------
  Future<void> getPublishedList() async{
    if (currentAssistant == null) {
      return;
    }
    try {
      isLoading = true;
      notifyListeners();

      publishedList = await _getPublishedUseCase.call(params: currentAssistant!);

      if (publishedList.isEmpty) {
        isConfiguredSlack = false;
        isConfiguredMessenger = false;
        isConfiguredTelegram = false;
      }

      else {
        for (var published in publishedList) {
          if (published.type == 'telegram') {
            isConfiguredTelegram = true;
            continue;
          }
          if (published.type == 'messenger') {
            isConfiguredMessenger = true;
            continue;
          }
          if (published.type == 'slack'){
            isConfiguredTelegram = true;
            continue;
          }
        }
      }
    } catch (e) {
      if (e == 401) {
        await _logoutUseCase.call(params: null);
      }
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<bool> validateTelegram(TelegramParam param) async{
    if (currentAssistant == null) {
      return false;
    }
    try {
      isLoading = true;
      notifyListeners();

      await _telegramValidateUseCase.call(params: param);
      return true;
    } catch (e) {
      if (e == 401) {
        await _logoutUseCase.call(params: null);
        //Reset here
      }
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> publishTelegram(String botToken) async{
    isLoading=  true;
    notifyListeners();
    try {
      String? link = await _telegramPublishUseCase.call(params: TelegramPublishParam(botToken, currentAssistant!));
      return link;
    } catch (e) {
      if (e == 401) {
        await _logoutUseCase.call(params: null);
      }
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> disconnect(String type) async {
    isLoading = true;
    notifyListeners();

    try {
      await _telegramDisconnectUseCase.call(
          params: DisconnectorParam(type: type, assistant: currentAssistant!));
    } catch (e) {
      if (e == 401) {
        await _logoutUseCase.call(params: null);
        //reset
      }
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //Setter:
  void setAssistant(Assistant a){
    currentAssistant = a;
    notifyListeners();
  }


}