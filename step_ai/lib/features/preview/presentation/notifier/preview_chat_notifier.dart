import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:step_ai/features/authentication/domain/usecase/logout_usecase.dart';
import 'package:step_ai/features/chat/domain/entity/assistant.dart';
import 'package:step_ai/features/chat/domain/entity/message.dart';
import 'package:step_ai/features/chat/domain/entity/thread_dto.dart';
import 'package:step_ai/features/chat/domain/params/thread_chat_param.dart';
import 'package:step_ai/features/chat/domain/usecase/ask_bot_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/create_thread_usecase.dart';
import 'package:step_ai/features/chat/notifier/personal_assistant_notifier.dart';
import 'package:step_ai/features/knowledge_base/domain/entity/knowledge_list.dart';
import 'package:step_ai/features/knowledge_base/domain/params/get_knowledges_param.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/get_knowledge_list_usecase.dart';
import 'package:step_ai/features/preview/domain/entity/kb_in_bot.dart';
import 'package:step_ai/features/preview/domain/usecase/get_kb_in_bot_usecase.dart';

class PreviewChatNotifier extends ChangeNotifier{
  ThreadDto? currentThread;
  Assistant? currentAssistant;

  final PersonalAssistantNotifier _assistantNotifier;
  final List<Message> _historyMessages = [];
  bool isCreatingThread = false;
  get historyMessages => _historyMessages;

  List<KbInBot> kbList = [];
  bool isLoadingKnowledgeList = false;
  KnowledgeList? knowledgeList;
  int limit = 0;
  bool hasNext = false;

  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = false;

  String errorString = "";

  void resetPageMark() {
    limit = 0;
    hasNext = false;
  }

  //UseCases:-------------------------------------------------------------------
  final CreateThreadUseCase _createThreadUseCase;
  final AskBotUseCase _askBotUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetKbInBotUseCase _getKbInBotUseCase;
  final GetKnowledgeListUsecase _getKnowledgeListUsecase;
  //
  PreviewChatNotifier(
      this._assistantNotifier,
      this._askBotUseCase,
      this._createThreadUseCase,
      this._logoutUseCase,
      this._getKbInBotUseCase,
      this._getKnowledgeListUsecase
      );

  //Setter:
  void updateCurrentThread(ThreadDto thread) {
    currentThread = thread;
    notifyListeners();
  }

  void updateCurrentAssistant(Assistant assistant){
    currentAssistant = assistant;
    notifyListeners();
  }
  //Methods:--------------------------------------------------------------------
//Added:
  Future<void> sendMessageInPreviewMode(String contentSend) async {
    if (currentThread == null) {
      print("null here");
      return;
    }
    //Add message send to history
    addMessage(Message(
        assistant: currentAssistant!,
        role: "user",
        content: contentSend));
    //Add message model to history with content null
    addMessage(Message(
        assistant: currentAssistant!,
        role: "model",
        content: null));
    notifyListeners();

    try {
      String response = await _askBotUseCase.call(
          params: ThreadChatParam(
              message: contentSend,
              openAiThreadId: currentThread!.openAiThreadId,
              assistantId: currentAssistant!.id!,
              additionalInstruction: "")
      );
      updateLastMessage(response);
      notifyListeners();
    } catch (e) {
      if (e == 401) {
        clearPersonalAssistantData();
        await _logoutUseCase.call(params: null);
      } else {
        print(e);
        updateLastMessage("Server not response. Try again!");
      }
      rethrow; //Rethrowing e
    }
  }

  //Create chat thread:
  Future<void> createThread(String assistantId) async{
    isCreatingThread = true;
    notifyListeners();

    try {
      ThreadDto? thread = await _createThreadUseCase.call(params: assistantId);
      if (thread != null) updateCurrentThread(thread);
    } catch (e) {
      if (e == 401) {
        clearPersonalAssistantData();
        await _logoutUseCase.call(params: null);
      }
      else {
        updateLastMessage("Server not response. Try again!");
      }
      rethrow; //Rethrowing e
    } finally {
      isCreatingThread = false;
      notifyListeners();
    }

  }

  //Kb in bot:
  Future<KbListInBot?> getKbInBot() async{
    try {
      isLoading = true;
      notifyListeners();
      KbListInBot? kb = await _getKbInBotUseCase.call(params: currentAssistant!.id!);
      if (kb!=null) {
        kbList = kb.data;
      }
      return kb;
    } catch (e) {
      if (e == 401) {
        await _logoutUseCase.call(params: null);
      }
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeKbInList(KbInBot? kb) async{
    return;
  }

  Future<KnowledgeList?> getKnowledgeList() async {
    isLoadingKnowledgeList = true;
    notifyListeners();
    try {
      // limit += 5;
      final knowledgeListModel = await _getKnowledgeListUsecase.call(
          params: GetKnowledgesParam(limit: 50));

      if (knowledgeListModel == null) return null;

      knowledgeList = KnowledgeList.fromModel(knowledgeListModel);
      knowledgeList!.knowledgeList.sort((a, b) => a.knowledgeName
          .toLowerCase()
          .compareTo(b.knowledgeName.toLowerCase()));

      hasNext = knowledgeListModel.meta.hasNext;
      errorString = "";

      return knowledgeList;

    } catch (e) {
      knowledgeList = null;
      limit = 0;
      hasNext = false;
      errorString = "Have error. Try again Get Knowledge";
      print("Error in getKnowledgeList in knowledge notifier with error: $e");
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError) {
          errorString = "Please check your internet connection";
        }
      }
      else {
        if (e == 401) {
          await _logoutUseCase.call(params: null);
        }
      }
      return null;
    } finally {
      isLoadingKnowledgeList = false;
      notifyListeners();
    }
  }
  //Messages display handler:---------------------------------------------------
  void addMessage(Message message) {
    _historyMessages.add(message);
  }

  void updateLastMessage(String content) {
    _historyMessages.last.content = content;
  }

  void clearHistoryMessages() {
    _historyMessages.clear();
  }

  //Stuff:----------------------------------------------------------------------
  void clearPersonalAssistantData(){
    _historyMessages.clear();
    currentThread = null;
    currentThread = null;

    _assistantNotifier.reset();
  }

  void reset(){
    clearHistoryMessages();
    clearPersonalAssistantData();
    notifyListeners();
  }

}
