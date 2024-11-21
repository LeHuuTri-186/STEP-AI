import 'package:get_it/get_it.dart';
import 'package:step_ai/features/prompt/presentation/state/form_model/form_provider.dart';
import 'package:step_ai/features/prompt/presentation/state/private_prompt/private_filter_provider.dart';
import 'package:step_ai/features/prompt/presentation/state/private_prompt/private_view_provider.dart';
import 'package:step_ai/features/prompt/presentation/state/prompt_view_provider.dart';
import 'package:step_ai/features/prompt/presentation/state/public_prompt/public_filter_provider.dart';
import 'package:step_ai/features/prompt/presentation/state/public_prompt/public_view_provider.dart';

import '../../domain/repositories/prompt_repository.dart';

final getIt = GetIt.instance;

Future<void> initPromptPresentation() async {
  PrivateFilterState privateFilterState = PrivateFilterState();
  PublicFilterState publicFilterState = PublicFilterState();
  FormModel formModel = FormModel();
  PrivateViewState privateViewState = PrivateViewState(repository: getIt<PromptRepository>(), filterState: privateFilterState);
  PublicViewState publicViewState = PublicViewState(repository: getIt<PromptRepository>(), filterState: publicFilterState);
  PromptViewState promptViewState = PromptViewState(publicViewState: publicViewState, privateViewState: privateViewState);

  getIt.registerSingleton<PublicViewState>(publicViewState);
  getIt.registerSingleton<PrivateViewState>(privateViewState);
  getIt.registerSingleton<PublicFilterState>(publicFilterState);
  getIt.registerSingleton<PrivateFilterState>(privateFilterState);
  getIt.registerSingleton<FormModel>(formModel);
  getIt.registerSingleton<PromptViewState>(promptViewState);
}