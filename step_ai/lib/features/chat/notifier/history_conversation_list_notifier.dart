import 'package:flutter/material.dart';
import 'package:step_ai/features/chat/domain/usecase/get_messages_by_conversation_id_usecase.dart';

import '../domain/entity/conversation.dart';

class HistoryConversationListNotifier extends ChangeNotifier {
  List<Conversation> _historyConversationList = [];

  List<Conversation> get historyConversationList => _historyConversationList;

  //usecase -----------------------------
  GetMessagesByConversationIdUsecase _getMessagesByConversationIdUsecase;
  HistoryConversationListNotifier(this._getMessagesByConversationIdUsecase);

  void addHistoryConservation(Conversation newConservation) {
    _historyConversationList.add(newConservation);
    notifyListeners();
  }

  void updateHistoryConservation(List<Conversation> newHistoryConversations) {
    _historyConversationList = newHistoryConversations;
    notifyListeners();
  }

  void getHistoryConversationList(){
    
  }


  //conversation id
  String? _idCurrentConversation;
  String? get idCurrentConversation => _idCurrentConversation;
  set idCurrentConversation(String? setIdConversation) {
    _idCurrentConversation = setIdConversation;
  }
}
