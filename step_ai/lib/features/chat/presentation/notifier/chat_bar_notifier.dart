import 'package:flutter/cupertino.dart';
import 'package:step_ai/features/authentication/domain/usecase/logout_usecase.dart';

class ChatBarNotifier extends ChangeNotifier{
  bool showIcons = false;
  bool showIconSend = false;
  bool showOverlay = false;
  bool triggeredPrompt = false;
  String contentToSet = '';
  bool isUnauthorized = false;

  final LogoutUseCase _logoutUseCase;

  ChatBarNotifier(this._logoutUseCase);


  //Notifier:-------------------------------------------------------------------
  void setShowIcons(bool value) {
    showIcons = value;
    notifyListeners();
  }

  void setShowIconSend(bool value) {
    showIconSend = value;
    notifyListeners();
  }

  void setShowOverlay(bool value){
    showOverlay = value;
    notifyListeners();
  }

  void setLogout(bool value) {
    isUnauthorized = value;
    notifyListeners();
  }

  void triggerPrompt(){
    triggeredPrompt = true;
    notifyListeners();
  }
  void cancelPrompt(){
    triggeredPrompt = false;
    notifyListeners();
  }
  String get content => contentToSet;
  //Basic:=---------------------------------------------------------------------
  void setContent(String value){
    contentToSet = value;
  }
  Future<void> callLogout()async{
    await _logoutUseCase.call(params: null);
  }

  void reset(){
    showIcons = false;
    showIconSend = false;
    showOverlay = false;
    triggeredPrompt = false;
    contentToSet = '';
    isUnauthorized = false;
    notifyListeners();
  }
}