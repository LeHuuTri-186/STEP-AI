import 'package:step_ai/core/di/service_locator.dart';
import 'package:step_ai/features/chat/data/network/api_client_chat.dart';
import 'package:step_ai/features/knowledge_base/data/network/knowledge_api.dart';

class NetworkModule {
  static Future<void> configureNetworkModuleInjection() async {
    getIt.registerSingleton<ApiClientChat>(
      ApiClientChat(),
    );
    getIt.registerSingleton<KnowledgeApi>(
      KnowledgeApi(),
    );
  }
}
