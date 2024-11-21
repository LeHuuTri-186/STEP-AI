import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:step_ai/features/prompt/data/network/prompt_api.dart';

import '../../data/repositories/prompt_repository_impl.dart';
import '../../domain/repositories/prompt_repository.dart';

final getIt = GetIt.instance;

Future<void> initPromptData() async {
  PromptApi promptApi = PromptApi();
  PromptRepository promptRepository = PromptRepositoryImpl(promptApi);


  getIt.registerSingleton<PromptRepository>(promptRepository);
}