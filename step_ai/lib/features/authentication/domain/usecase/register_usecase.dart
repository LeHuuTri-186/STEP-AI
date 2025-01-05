import 'dart:async';

import 'package:step_ai/core/usecases/use_case.dart';
import 'package:step_ai/features/authentication/domain/param/login_param.dart';
import 'package:step_ai/features/authentication/domain/repository/register_repository.dart';
import 'package:step_ai/features/authentication/domain/usecase/login_usecase.dart';

import '../param/register_param.dart';

class RegisterUseCase extends UseCase<int, RegisterParam>{
  final RegisterRepository _registerRepository;
  final LoginUseCase _loginUseCase;

  RegisterUseCase(this._registerRepository, this._loginUseCase);
  @override
  FutureOr<int> call({required RegisterParam params}) async{
     int registerStatus = await _registerRepository.register(
         params.email, params.password, params.username);

     //Call login
     if (registerStatus == 201) {
       print('Register done');
       try{
         await _loginUseCase.call(
             params: LoginParam(email: params.email, password: params.password));
         return 200;
       } catch (e){
         if (e == '422') return 422;
       }
     }
     return registerStatus;
  }
}