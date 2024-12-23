import 'dart:async';

abstract class UseCase<T, P> {
  FutureOr<T> call({ required P params});
}

abstract class NoParamUseCase<T> {
  FutureOr<T> call();
}