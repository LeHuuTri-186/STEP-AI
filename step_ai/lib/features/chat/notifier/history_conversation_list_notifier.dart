import 'package:flutter/material.dart';
import 'package:step_ai/features/chat/domain/usecase/get_history_conversation_list_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/get_messages_by_conversation_id_usecase.dart';

import '../domain/entity/conversation.dart';

class HistoryConversationListNotifier extends ChangeNotifier {
  int _limitConversation = 0;
  bool _hasMore = false;
  get hasMore => _hasMore;
  get limitConversation => _limitConversation;
  List<Conversation> _historyConversationList = [];

  List<Conversation> get historyConversationList => _historyConversationList;

  //usecase -----------------------------
  GetMessagesByConversationIdUsecase _getMessagesByConversationIdUsecase;
  GetHistoryConversationListUsecase _getHistoryConversationListUsecase;
  HistoryConversationListNotifier(this._getMessagesByConversationIdUsecase,
      this._getHistoryConversationListUsecase);

  Future<void> getHistoryConversationList() async {
    try {
      _limitConversation = _limitConversation + 10;
      final conversationModel = await _getHistoryConversationListUsecase.call(
          params: _limitConversation);
      this._historyConversationList.clear();
      this._historyConversationList = conversationModel.items.map((item) {
        return Conversation(
          id: item.id!,
          title: item.title,
          createdAt: item.createdAt,
        );
      }).toList();
      _hasMore = conversationModel.hasMore;
    } catch (e) {
      _historyConversationList = [];
      _limitConversation = 0;
      _hasMore = false;
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
