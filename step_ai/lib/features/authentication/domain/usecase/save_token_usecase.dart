import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/authentication/domain/param/save_token_param.dart';
import 'package:step_ai/features/authentication/domain/repository/auth_secure_storage_repository.dart';

class SaveTokenUseCase extends UseCase<void, SaveTokenParam>{
  final AuthSecureStorageRepository _secureStorageRepository;
  SaveTokenUseCase(this._secureStorageRepository);

  @override
  FutureOr<void> call({required SaveTokenParam params}) {
    return _secureStorageRepository.saveToken(params.key, params.value);
  }
}