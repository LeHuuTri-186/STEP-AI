import 'package:step_ai/features/publish/domain/params/disconnector_param.dart';

class Constant{
  Constant._();
  //API:------------------------------------------------------------------------
  // static String apiBaseUrl = 'https://api.jarvis.cx';
  static String apiBaseUrl = 'https://api.dev.jarvis.cx';
  static String kbApiUrl = 'https://knowledge-api.dev.jarvis.cx';
  // static String kbApiUrl = 'https://knowledge-api.jarvis.cx';

  static String loginEndpoint = '/api/v1/auth/sign-in';
  static String registerEndpoint = '/api/v1/auth/sign-up';
  static String logoutEndpoint = '/api/v1/auth/sign-out';
  static String refreshTokenPartEndpoint = '/api/v1/auth/refresh?refreshToken=';
  static String usageEndpoint = '/api/v1/subscriptions/me';

  static String promptSearchBaseEndpoint = '/api/v1/prompts?';
  static String promptSearchQuery = 'query=';
  static String promptSearchOffset = 'offset=';
  static String promptSearchLimit = 'limit=';
  static String promptSearchIsFavorite = 'isFavorite=';
  static String promptSearchIsPublic = 'isPublic';
  //Tokens map key:-------------------------------------------------------------
  static String access = 'AccessToken';
  static String refresh = 'RefreshToken';

  //Bot/Assistant Endpoint:-----------------------------------------------------
  static String createBotEndpoint = '/kb-core/v1/ai-assistant';
  static String loginKbEndpoint = '/kb-core/v1/auth/external-sign-in';
  static String kbRefreshEndpointPart = '/kb-core/v1/auth/refresh?refreshToken=';
  static String deleteBotEndpoint = '/kb-core/v1/ai-assistant/';
  static String updateBotEndpoint = '/kb-core/v1/ai-assistant/';
  //----Bot get-----------------------------------------------------------------
  static String botGetEndpoint = '/kb-core/v1/ai-assistant?q';
  static String botGetOrderSet = '&order=DESC&order_field=createdAt';
  static String botOffset = '&offset=';
  static String botLimit = '&limit=10';
  static String botPublished = '&isPublished';
  static String createThreadEndpoint = '/kb-core/v1/ai-assistant/thread';
  static String askBotInThreadEndpoint = '/kb-core/v1/ai-assistant';
  static String botEndpoint = '/kb-core/v1/ai-assistant';
  static String kbInBotQuery = '/knowledges?q&order=DESC&order_field=createdAt&offset&limit=20';

  //Image File Source:----------------------------------------------------------
  static String localFileImagePath = 'lib/core/assets/source_unit_images/file.png';
  static String webImagePath = 'lib/core/assets/source_unit_images/web.png';
  static String driveImagePath = 'lib/core/assets/source_unit_images/drive.png';
  static String confluenceImagePath = 'lib/core/assets/source_unit_images/confluence.png';
  static String slackImagePath = 'lib/core/assets/source_unit_images/slack.png';

  //Publish:--------------------------------------------------------------------
  static String getPublishedEndpoint(String id) => '/kb-core/v1/bot-integration/$id/configurations';
  static String telegramValidateEndpoint = '/kb-core/v1/bot-integration/telegram/validation';
  static String telegramPublishEndpoint(String id) => '/kb-core/v1/bot-integration/telegram/publish/$id';
  static String disconnectBotEndpoint(String id, String type) => '/kb-core/v1/bot-integration/$id/$type';
}