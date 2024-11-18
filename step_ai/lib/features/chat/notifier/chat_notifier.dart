import 'package:flutter/material.dart';
import 'package:step_ai/features/chat/domain/entity/message.dart';
import 'package:step_ai/features/chat/domain/params/send_message_param.dart';
import 'package:step_ai/features/chat/domain/usecase/send_message_usecase.dart';
import 'package:step_ai/features/chat/notifier/assistant_notifier.dart';
import 'package:step_ai/features/chat/notifier/history_conversation_list_notifier.dart';

class ChatNotifier with ChangeNotifier {
  //number of rest token
  int _numberRestToken = 50;
  int get numberRestToken => _numberRestToken;
  set numberRestToken(int numberRestToken) {
    _numberRestToken = numberRestToken;
    notifyListeners();
  }

  //Notifier
  AssistantNotifier _assistantNotifier;
  HistoryConversationListNotifier _historyConversationListNotifier;

  ///history messages
  List<Message> _historyMessages = [];
  List<Message> get historyMessages => _historyMessages;

  //usecase -----------------------------
  SendMessageUsecase _sendMessageUsecase;
  ChatNotifier(this._sendMessageUsecase, this._assistantNotifier,
      this._historyConversationListNotifier);

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
      final response = await _sendMessageUsecase.call(
          params: SendMessageParam(
              historyMessages: _historyMessages,
              conversationId:
                  _historyConversationListNotifier.idCurrentConversation));
      updateLastMessage(response.content!);
    } catch (error) {
      updateLastMessage(error.toString());
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
}
