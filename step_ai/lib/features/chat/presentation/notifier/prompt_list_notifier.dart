import 'package:flutter/widgets.dart';
import 'package:step_ai/config/enum/task_status.dart';
import 'package:step_ai/features/chat/domain/entity/slash_prompt_list.dart';
import 'package:step_ai/features/chat/domain/usecase/get_prompt_list_usecase.dart';

class PromptListNotifier extends ChangeNotifier{
  final GetPromptListUseCase _getPromptListUseCase;
  String key = '';
  SlashPromptList list = SlashPromptList(prompts: []);
  bool isFetching = false;
  int needRebuildCounter = 0;
  PromptListNotifier(this._getPromptListUseCase);

  bool isChangingKey(String value){
    if (value.isEmpty) return false;
    if (value == '/$key') return false;
    if (value == '/') {
      key = '';
    }
    else {
      key = value.substring(1);
    }
    return true;
  }

  void setRebuild(){
    increaseRebuildCounter();
    notifyListeners();
  }

  void setList(value){
    list = value;
    notifyListeners();
  }


  Future<TaskStatus> getPrompts(String value) async{

    if (!isChangingKey(value)) return TaskStatus.SIMILAR;
    list =SlashPromptList(prompts: []);
    isFetching = true;
    notifyListeners();

    try {
      final prompts = await _getPromptListUseCase.call(params: key);
      prompts != null?
      list.setList(prompts.prompts) : list =SlashPromptList(prompts: []);
      isFetching = false;

      increaseRebuildCounter();
      notifyListeners();
      return TaskStatus.OK;

    } catch (e){
      if (e == 'Exit') {
        print('Throw exit');
        isFetching = false;

        increaseRebuildCounter();
        notifyListeners();

        return TaskStatus.UNAUTHORIZED;
      }
      else {
        print('Error: $e');
        isFetching = false;

        increaseRebuildCounter();
        notifyListeners();
        return TaskStatus.ERROR;
      }
    }
  }

  void increaseRebuildCounter(){
    needRebuildCounter++;
    if (needRebuildCounter > 5000) needRebuildCounter = 1;
  }
  void reset(){
    key = '';
    list = SlashPromptList(prompts: []);
    isFetching = false;
    needRebuildCounter = 0;

    notifyListeners();
  }
}