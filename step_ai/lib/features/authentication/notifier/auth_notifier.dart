import 'package:flutter/material.dart';
import 'package:step_ai/config/constants.dart';
import 'package:step_ai/shared/business_logic/token_logic/domain/param/save_token_param.dart';

import '../../../shared/business_logic/token_logic/domain/usecase/save_token_usecase.dart';

class AuthNotifier extends ChangeNotifier{
  //Use cases:------------------------------------------------------------------
  final SaveTokenUseCase _saveTokenUseCase;

  //Others:---------------------------------------------------------------------
  bool _isLoading = false;
  String? _errorMessage;

  //Methods:--------------------------------------------------------------------
  AuthNotifier(this._saveTokenUseCase);

  Future<void> saveToken(String accessToken, String refreshToken) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _saveTokenUseCase.call(
          params: SaveTokenParam
            (key: Constant.access, value: accessToken));

      await _saveTokenUseCase.call(
          params: SaveTokenParam
            (key: Constant.refresh, value: refreshToken));

    } catch (e) {
      _errorMessage = 'Failed to save token: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}