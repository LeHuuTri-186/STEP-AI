import 'package:flutter/material.dart';
import 'package:step_ai/features/authentication/domain/usecase/logout_usecase.dart';
import 'package:step_ai/features/chat/domain/entity/assistant.dart';
import 'package:step_ai/features/chat/domain/entity/message.dart';
import 'package:step_ai/features/chat/domain/entity/thread_dto.dart';
import 'package:step_ai/features/chat/domain/params/thread_chat_param.dart';
import 'package:step_ai/features/chat/domain/usecase/ask_bot_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/create_thread_usecase.dart';
import 'package:step_ai/features/chat/notifier/personal_assistant_notifier.dart';

class PreviewChatNotifier extends ChangeNotifier{
  ThreadDto? currentThread;
  Assistant? currentAssistant;

  final PersonalAssistantNotifier _assistantNotifier;

  final List<Message> _historyMessages = [];
  bool isCreatingThread = false;
  get historyMessages => _historyMessages;

  //UseCases:-------------------------------------------------------------------
  final CreateThreadUseCase _createThreadUseCase;
  final AskBotUseCase _askBotUseCase;
  final LogoutUseCase _logoutUseCase;

  //
  PreviewChatNotifier(
      this._assistantNotifier,
      this._askBotUseCase,
      this._createThreadUseCase,
      this._logoutUseCase
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
