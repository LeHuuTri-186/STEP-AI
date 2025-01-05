import 'package:flutter/widgets.dart';
import 'package:step_ai/features/authentication/domain/usecase/logout_usecase.dart';
import 'package:step_ai/features/chat/domain/entity/assistant.dart';
import 'package:step_ai/features/publish/domain/entity/published.dart';
import 'package:step_ai/features/publish/domain/params/disconnector_param.dart';
import 'package:step_ai/features/publish/domain/params/messenger_publish_param.dart';
import 'package:step_ai/features/publish/domain/params/messenger_validate_param.dart';
import 'package:step_ai/features/publish/domain/params/slack_publish_param.dart';
import 'package:step_ai/features/publish/domain/params/slack_validate_param.dart';
import 'package:step_ai/features/publish/domain/params/telegram_param.dart';
import 'package:step_ai/features/publish/domain/params/telegram_publish_param.dart';
import 'package:step_ai/features/publish/domain/usecase/get_published_usecase.dart';
import 'package:step_ai/features/publish/domain/usecase/messenger_publish_usecase.dart';
import 'package:step_ai/features/publish/domain/usecase/messenger_validate_usecase.dart';
import 'package:step_ai/features/publish/domain/usecase/slack_publish_usecase.dart';
import 'package:step_ai/features/publish/domain/usecase/slack_validate_usecase.dart';
import 'package:step_ai/features/publish/domain/usecase/disconnect_usecase.dart';
import 'package:step_ai/features/publish/domain/usecase/telegram_publish_usecase.dart';
import 'package:step_ai/features/publish/domain/usecase/telegram_validate_usecase.dart';

class PublishNotifier extends ChangeNotifier{
  bool isLoading = false;
  Assistant? currentAssistant;

  bool isConfiguredSlack = false;
  bool isConfiguredMessenger = false;
  bool isConfiguredTelegram = false;

  List<Published> publishedList = [];

  String? telegramUrl, messengerUrl, slackUrl;

  //UC:-------------------------------------------------------------------------
  final GetPublishedUseCase _getPublishedUseCase;

  final TelegramValidateUseCase _telegramValidateUseCase;
  final TelegramPublishUseCase _telegramPublishUseCase;

  final MessengerValidateUseCase _messengerValidateUseCase;
  final MessengerPublishUseCase _messengerPublishUseCase;

  final SlackValidateUseCase _slackValidateUseCase;
  final SlackPublishUseCase _slackPublishUseCase;

  final DisconnectUsecase _telegramDisconnectUseCase;

  final LogoutUseCase _logoutUseCase;

  PublishNotifier(
      this._getPublishedUseCase,
      this._logoutUseCase,
      this._telegramValidateUseCase,
      this._telegramPublishUseCase,
      this._telegramDisconnectUseCase,
      this._messengerValidateUseCase,
      this._messengerPublishUseCase,
      this._slackValidateUseCase,
      this._slackPublishUseCase);

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
            telegramUrl = published.metadata.redirect;
            notifyListeners();
          }
          if (published.type == 'messenger') {
            isConfiguredMessenger = true;
            messengerUrl = published.metadata.redirect;
            notifyListeners();
          }
          if (published.type == 'slack'){
            isConfiguredSlack = true;
            slackUrl = published.metadata.redirect;
            notifyListeners();
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
      telegramUrl = link;
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

  Future<bool> validateMessenger(MessengerValidateParam param) async{
    if (currentAssistant == null) {
      return false;
    }
    try {
      isLoading = true;
      notifyListeners();

      await _messengerValidateUseCase.call(params: param);
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


  Future<String?> publishMessenger(MessengerValidateParam param) async{
    isLoading=  true;
    notifyListeners();
    try {
      String? link = await _messengerPublishUseCase.call(
          params: MessengerPublishParam(
              botToken: param.botToken,
              pageId: param.pageId,
              appSecret: param.appSecret,
              assistant: currentAssistant!));
      messengerUrl = link;
      return link;
    } catch (e) {
      if (e == 401) {
        await _logoutUseCase.call(params: null);
        //reset?
      }
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> validateSlack(SlackValidateParam param) async{
    if (currentAssistant == null) {
      return false;
    }
    try {
      isLoading = true;
      notifyListeners();

      await _slackValidateUseCase.call(params: param);
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


  Future<String?> publishSlack(SlackValidateParam param) async{
    isLoading=  true;
    notifyListeners();
    try {
      String? link = await _slackPublishUseCase.call(
          params: SlackPublishParam(
              botToken: param.botToken,
              clientId: param.clientId,
              clientSecret: param.clientSecret,
              signingSecret: param.signingSecret,
              assistant: currentAssistant!));
      slackUrl = link;
      return link;
    } catch (e) {
      if (e == 401) {
        await _logoutUseCase.call(params: null);
        //reset?
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
      if (type == 'slack') {
        isConfiguredSlack = false;
      }
      if (type == 'telegram') {
        isConfiguredTelegram = false;
      }
      if (type == 'messenger'){
        isConfiguredMessenger = false;
      }
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