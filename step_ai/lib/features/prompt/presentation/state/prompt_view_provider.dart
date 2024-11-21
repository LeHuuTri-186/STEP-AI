import 'package:flutter/foundation.dart';
import 'package:step_ai/features/prompt/data/models/prompt_model.dart';
import 'package:step_ai/features/prompt/presentation/state/private_prompt/private_view_provider.dart';
import 'package:step_ai/features/prompt/presentation/state/public_prompt/public_view_provider.dart';

class PromptViewState extends ChangeNotifier {
  bool _isPrivate = true;
  bool get isPrivate => _isPrivate;
  PublicViewState publicViewState;
  PrivateViewState privateViewState;

  PromptViewState({required this.publicViewState, required this.privateViewState});

  Future<void> togglePrivate(bool value) async {
    _isPrivate = value;
    if (_isPrivate) {
      await privateViewState.refreshView();
    } else {
      await publicViewState.refreshView();
    }

    notifyListeners();
  }

  Future<void> onPromptCreate(PromptModel prompt) async {
    if (prompt.isPublic) {
      publicViewState.onPromptAdded(prompt);
      privateViewState.refreshView();
    } else {
      privateViewState.onPromptAdded(prompt);
    }
  }
}
