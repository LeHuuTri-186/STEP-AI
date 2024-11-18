import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/shared/business_logic/token_logic/domain/repository/auth_secure_storage_repository.dart';

class DeleteTokenUseCase extends UseCase<void, String>{
  final AuthSecureStorageRepository _authSecureStorageRepository;
  DeleteTokenUseCase(this._authSecureStorageRepository);

  @override
  FutureOr<void> call({required String params}) {
    _authSecureStorageRepository.deleteToken(params);
  }
}