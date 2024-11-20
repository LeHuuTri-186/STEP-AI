import 'package:flutter/material.dart';
import 'package:step_ai/features/chat/domain/usecase/get_history_conversation_list_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/get_messages_by_conversation_id_usecase.dart';

import '../domain/entity/conversation.dart';

class HistoryConversationListNotifier extends ChangeNotifier {
  List<Conversation> _historyConversationList = [];

  List<Conversation> get historyConversationList => _historyConversationList;

  //usecase -----------------------------
  GetMessagesByConversationIdUsecase _getMessagesByConversationIdUsecase;
  GetHistoryConversationListUsecase _getHistoryConversationListUsecase;
  HistoryConversationListNotifier(this._getMessagesByConversationIdUsecase,
      this._getHistoryConversationListUsecase);

  Future<void> getHistoryConversationList(int limitConversation) async {
    try {
      final conversationModel = await _getHistoryConversationListUsecase.call(
          params: limitConversation);
      this._historyConversationList = conversationModel.items.map((item) {
        return Conversation(
          id: item.id!,
          title: item.title,
          createdAt: item.createdAt,
        );
      }).toList();
    } catch (e) {
      _historyConversationList = [];
      print(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> getNewestConversationWhenAfterSendMessage() async {
    try {
      final conversationModel = await _getHistoryConversationListUsecase.call(
          params: 1); //only return list 1 item

      this._historyConversationList.insert(
            0,
            Conversation(
              id: conversationModel.items.first.id!,
              title: conversationModel.items.first.title,
              createdAt: conversationModel.items.first.createdAt,
            ),
          );
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  // //conversation id
  // String? _idCurrentConversation;
  // String? get idCurrentConversation => _idCurrentConversation;
  // set idCurrentConversation(String? setIdConversation) {
  //   _idCurrentConversation = setIdConversation;
  // }
}
