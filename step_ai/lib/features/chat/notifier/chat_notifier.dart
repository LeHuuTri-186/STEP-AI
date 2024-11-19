import 'package:flutter/material.dart';
import 'package:step_ai/features/chat/domain/entity/message.dart';
import 'package:step_ai/features/chat/domain/params/send_message_param.dart';
import 'package:step_ai/features/chat/domain/usecase/get_usage_token_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/send_message_usecase.dart';
import 'package:step_ai/features/chat/notifier/assistant_notifier.dart';
import 'package:step_ai/features/chat/notifier/history_conversation_list_notifier.dart';

class ChatNotifier with ChangeNotifier {
  //number of rest token
  int _numberRestToken = 0;
  int get numberRestToken => _numberRestToken;
  set numberRestToken(int numberRestToken) {
    _numberRestToken = numberRestToken;
    notifyListeners();
  }

  //run first time when open chat
  Future<void> getNumberRestToken() async {
    try {
      final usageTokenModel = await _getUsageTokenUsecase.call(params: null);
      numberRestToken = usageTokenModel.availableTokens;
    } catch (e) {
      print(e);
    }
  }

  //Notifier
  AssistantNotifier _assistantNotifier;
  HistoryConversationListNotifier _historyConversationListNotifier;

  ///history messages
  List<Message> _historyMessages = [];
  List<Message> get historyMessages => _historyMessages;

  //usecase -----------------------------
  SendMessageUsecase _sendMessageUsecase;
  GetUsageTokenUsecase _getUsageTokenUsecase;
  ChatNotifier(this._sendMessageUsecase, this._assistantNotifier,
      this._historyConversationListNotifier, this._getUsageTokenUsecase);

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
              conversationId:
                  _historyConversationListNotifier.idCurrentConversation));

      updateLastMessage(messageModel.message);
      _numberRestToken = messageModel.remainingUsage;
      if (_historyConversationListNotifier.idCurrentConversation == null) {
        _historyConversationListNotifier.idCurrentConversation =
            messageModel.conversationId;
        _historyConversationListNotifier.getHistoryConversationList();
      }
    } catch (error) {
      updateLastMessage("Server not response. Try again!");
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

  void resetChatNotifier() {
    clearHistoryMessages();
    _historyConversationListNotifier.idCurrentConversation = null;
    notifyListeners();
  }
}
