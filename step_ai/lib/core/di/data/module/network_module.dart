import 'package:step_ai/core/di/service_locator.dart';
import 'package:step_ai/features/chat/data/network/api_client_chat.dart';
import 'package:step_ai/features/knowledge_base/data/network/knowledge_api.dart';
import 'package:step_ai/features/units_in_knowledge/data/network/unit_api.dart';

import 'package:step_ai/features/plan/data/network/api_subscription.dart';

class NetworkModule {
  static Future<void> configureNetworkModuleInjection() async {
    getIt.registerSingleton<ApiClientChat>(
      ApiClientChat(),
    );

    getIt.registerSingleton<KnowledgeApi>(
      KnowledgeApi(),
    );
    getIt.registerSingleton<UnitApi>(
      UnitApi(),
    );

    getIt.registerSingleton<ApiSubscription>(
      ApiSubscription(),
    );
  }
}
