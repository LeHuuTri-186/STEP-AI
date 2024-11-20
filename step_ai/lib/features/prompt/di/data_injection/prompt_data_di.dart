import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../data/repositories/prompt_repository_impl.dart';
import '../../domain/repositories/prompt_repository.dart';

final getIt = GetIt.instance;

Future<void> initPromptData() async {
  Dio dio = Dio(BaseOptions(
      baseUrl: 'https://api.dev.jarvis.cx'
  ),);
  PromptRepository promptRepository = PromptRepositoryImpl(dio: dio);


  getIt.registerSingleton<PromptRepository>(promptRepository);

}