import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:step_ai/features/authentication/domain/usecase/logout_usecase.dart';
import 'package:step_ai/features/chat/domain/entity/message.dart';
import 'package:step_ai/features/chat/domain/entity/thread_dto.dart';
import 'package:step_ai/features/chat/domain/params/send_message_param.dart';
import 'package:step_ai/features/chat/domain/params/thread_chat_param.dart';
import 'package:step_ai/features/chat/domain/usecase/ask_bot_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/create_thread_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/get_usage_token_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/send_message_usecase.dart';
import 'package:step_ai/features/chat/notifier/assistant_notifier.dart';
import 'package:step_ai/features/chat/notifier/history_conversation_list_notifier.dart';
import 'package:step_ai/features/chat/notifier/personal_assistant_notifier.dart';

import '../domain/usecase/get_messages_by_conversation_id_usecase.dart';

class ChatNotifier with ChangeNotifier {
  //number of rest token
  int _numberRestToken = 0;
  int get numberRestToken => _numberRestToken;
  set numberRestToken(int numberRestToken) {
    _numberRestToken = numberRestToken;
    notifyListeners();
  }

  //isLoading detailed conversation
  GetMessagesByConversationIdUsecase _getMessagesByConversationIdUsecase;
  bool _isLoadingDetailedConversation = false;
  bool get isLoadingDetailedConversation => _isLoadingDetailedConversation;

  Future<void> getMessagesByConversationId() async {
    _isLoadingDetailedConversation = true;
    notifyListeners();
    try {
      print("Get messages by conversation id in chat notifier");
      final detailMessagesModel = await _getMessagesByConversationIdUsecase
          .call(params: _idCurrentConversation!);
      clearHistoryMessages();
      detailMessagesModel.items.forEach((element) {
        addMessage(Message(
            assistant: _assistantNotifier.currentAssistant,
            role: "user",
            content: element.query));
        //Add message model to history with content null
        addMessage(Message(
            assistant: _assistantNotifier.currentAssistant,
            role: "model",
            content: element.answer));
      });
    } catch (e) {
      if (e is DioException) {
        print(
            "Error in getMessagesByConversationId in chat notifier with status code: ${e.response?.statusCode}");
      } else {
        print(
            "Error in getMessagesByConversationId in chat notifier with  error: $e");
      }
    } finally {
      _isLoadingDetailedConversation = false;
      notifyListeners();
    }
  }

  //current conversation id
  String? _idCurrentConversation;
  String? get idCurrentConversation => _idCurrentConversation;
  set idCurrentConversation(String? setIdConversation) {
    _idCurrentConversation = setIdConversation;
  }

  //run first time when open chat
  Future<void> getNumberRestToken() async {
    try {
      final usageTokenModel = await _getUsageTokenUsecase.call(params: null);
      numberRestToken = usageTokenModel.availableTokens;
    } catch (e) {
      if (e is DioException) {
        print(
            "Error in getNumberRestToken in chat notifier with status code: ${e.response?.statusCode}");
      } else {
        print("Error in getNumberRestToken in chat notifier with  error: $e");
      }
    }
  }

  //Thread for chatting with bot:
  ThreadDto? currentThread;

  //Notifier
  AssistantNotifier _assistantNotifier;
  final PersonalAssistantNotifier _personalAssistantNotifier;
  HistoryConversationListNotifier _historyConversationListNotifier;

  ///history messages
  List<Message> _historyMessages = [];
  List<Message> get historyMessages => _historyMessages;

  //usecase -----------------------------
  SendMessageUsecase _sendMessageUsecase;
  GetUsageTokenUsecase _getUsageTokenUsecase;
  CreateThreadUseCase _createThreadUseCase;
  AskBotUseCase _askBotUseCase;
  LogoutUseCase _logoutUseCase;

  ChatNotifier(
      this._sendMessageUsecase,
      this._assistantNotifier,
      this._historyConversationListNotifier,
      this._getUsageTokenUsecase,
      this._getMessagesByConversationIdUsecase,
      this._personalAssistantNotifier,
      this._createThreadUseCase,
      this._askBotUseCase,
      this._logoutUseCase
      );

  Future<void> sendMessage(String contentSend) async {
    //Add message send to history
    addMessage(Message(
        assistant: _assistantNotifier.currentAssistant,
        role: "user",
        content: contentSend));
    //Add message model to history with content null
    addMessage(Message(
        assistant: _assistantNotifier.currentAssistant,
        role: "model",
        content: null));
    notifyListeners();

    try {
      final messageModel = await _sendMessageUsecase.call(
          params: SendMessageParam(
              historyMessages: _historyMessages,
              conversationId: _idCurrentConversation));

      updateLastMessage(messageModel.message);
      _numberRestToken = messageModel.remainingUsage;
      if (_idCurrentConversation == null) {
        //if the first time send, add conversation title to historyConversationList
        _idCurrentConversation = messageModel.conversationId;
        await _historyConversationListNotifier
            .getNewestConversationWhenAfterSendMessage();
      } else {
        //update historyConversationList when send message at old conversation
        if (_idCurrentConversation !=
            _historyConversationListNotifier.historyConversationList.first.id) {
          await _historyConversationListNotifier.getHistoryConversationList();
        }
      }
    } catch (error) {
      if (error is DioException) {
        print(
            "Error in sendMessage in chat notifier with status code: ${error.response?.statusCode}");
        if (error.response?.statusCode == 401) {
          this._historyMessages.clear();
          this._idCurrentConversation=null;
          this._numberRestToken = 0;
          this._isLoadingDetailedConversation = false;
          throw 401;
        } else {
          updateLastMessage("Server not response. Try again!");
        }
      } else {
        print("Error in sendMessage in chat notifier with  error: $error");
      }
    } finally {
      notifyListeners();
    }
  }

  void addMessage(Message message) {
    _historyMessages.add(message);
  }

  void updateLastMessage(String content) {
    _historyMessages.last.content = content;
  }

  void clearHistoryMessages() {
    _historyMessages.clear();
  }

  Future<void> resetChatNotifier() async {
    this._idCurrentConversation = null;
    _isLoadingDetailedConversation = false;
    clearHistoryMessages();
    notifyListeners();
  }

  String getTitleCurrentConversation() {
    if (_idCurrentConversation == null) {
      return "New Chat";
    } else {
      return _historyConversationListNotifier.historyConversationList
          .firstWhere((element) => element.id == _idCurrentConversation)
          .title!;
    }
  }

  //Added:
  Future<void> sendMessageForPersonalBot(String contentSend) async {
    //Add message send to history
    addMessage(Message(
        assistant: _personalAssistantNotifier.currentAssistant!,
        role: "user",
        content: contentSend));
    //Add message model to history with content null
    addMessage(Message(
        assistant: _personalAssistantNotifier.currentAssistant!,
        role: "model",
        content: null));
    notifyListeners();

    try {
      print("Reach top");
      ThreadDto? thread = await _createThreadUseCase.call(
          params: _personalAssistantNotifier.currentAssistant!.id!);
      if (thread != null) {
        currentThread = thread;
        String response = await _askBotUseCase.call(
            params: ThreadChatParam(
                message: contentSend,
                openAiThreadId: currentThread!.openAiThreadId,
                assistantId: currentThread!.assistantId,
                additionalInstruction: "")
        );
        updateLastMessage(response);
        notifyListeners();
      }
    } catch (e) {
      if (e == 401) {
        clearPersonalAssistantData();
        await _logoutUseCase.call(params: null);
      } else {
        updateLastMessage("Server not response. Try again!");
      }
    }
  }

  void clearPersonalAssistantData(){
    _historyMessages.clear();
    _idCurrentConversation = null;
    _numberRestToken = 0;
    _isLoadingDetailedConversation = false;
    currentThread = null;

    _personalAssistantNotifier.reset();
  }

  void reset(){
    clearHistoryMessages();
    clearPersonalAssistantData();
    notifyListeners();
  }
}
