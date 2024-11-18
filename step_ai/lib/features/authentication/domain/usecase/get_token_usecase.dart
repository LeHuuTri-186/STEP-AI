import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/authentication/domain/repository/auth_secure_storage_repository.dart';

class GetTokenUseCase extends UseCase<String?, String>{
  final AuthSecureStorageRepository _authSecureStorageRepository;
  GetTokenUseCase(this._authSecureStorageRepository);

  @override
  FutureOr<String?> call({required String params}) async {
    String? value = await _authSecureStorageRepository.getToken(params);
    return value;
  }
}