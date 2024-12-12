import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:step_ai/features/chat/domain/usecase/get_history_conversation_list_usecase.dart';

import '../domain/entity/conversation.dart';

class HistoryConversationListNotifier extends ChangeNotifier {
  bool isLoading = false;
  int _limitConversation = 0;
  bool _hasMore = false;
  get hasMore => _hasMore;
  get limitConversation => _limitConversation;
  List<Conversation> _historyConversationList = [];

  List<Conversation> get historyConversationList => _historyConversationList;

  //usecase -----------------------------
  GetHistoryConversationListUsecase _getHistoryConversationListUsecase;
  HistoryConversationListNotifier(this._getHistoryConversationListUsecase);

  Future<void> getHistoryConversationList() async {
    isLoading = true;
    notifyListeners();
    try {
      print("=============getHistoryConversationList");
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
      print("=============getHistoryConversationList success");
    } catch (e) {
      _historyConversationList = [];
      _limitConversation = 0;
      _hasMore = false;
      if (e is DioException) {
        print(
            "Error in getHistoryConversationList in history conversation list notifier with status code: ${e.response?.statusCode}");
      } else {
        print("Error in getHistoryConversationList in history conversation list notifier");
      }
    } finally {
      isLoading = false;
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
      if (e is DioException) {
        print(
            "Error in getNewestConversationWhenAfterSendMessage in history conversation list notifier with status code: ${e.response?.statusCode}");
      } else {
        print(
            "Error in getNewestConversationWhenAfterSendMessage in history conversation list notifier with  error: $e");
      }
    } finally {
      notifyListeners();
    }
  }
}
