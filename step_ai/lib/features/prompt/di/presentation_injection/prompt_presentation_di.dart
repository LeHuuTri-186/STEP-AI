import 'package:get_it/get_it.dart';

import '../../domain/repositories/prompt_repository.dart';
import '../../presentation/notifier/form_model/form_provider.dart';
import '../../presentation/notifier/private_prompt/private_filter_provider.dart';
import '../../presentation/notifier/private_prompt/private_view_provider.dart';
import '../../presentation/notifier/prompt_view_provider.dart';
import '../../presentation/notifier/public_prompt/public_filter_provider.dart';
import '../../presentation/notifier/public_prompt/public_view_provider.dart';

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