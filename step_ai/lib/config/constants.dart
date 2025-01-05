import 'package:step_ai/features/publish/domain/params/disconnector_param.dart';

class Constant {
  Constant._();
  static String apiBaseUrl = 'https://api.jarvis.cx';
  static String kbApiUrl = 'https://knowledge-api.jarvis.cx';
  // static String apiBaseUrl = 'https://api.jarvis.cx';
  // static String kbApiUrl = 'https://knowledge-api.jarvis.cx';
  static String devPricing = 'https://admin.jarvis.cx/dashboard/subscription';
  static String pricing = 'https://admin.jarvis.cx/dashboard/subscription';

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
  static String promptSearchIsPublic = 'isPublic=';
  //Tokens map key:-------------------------------------------------------------
  static String access = 'AccessToken';
  static String refresh = 'RefreshToken';

  //Bot/Assistant Endpoint:-----------------------------------------------------
  static String createBotEndpoint = '/kb-core/v1/ai-assistant';
  static String loginKbEndpoint = '/kb-core/v1/auth/external-sign-in';
  static String kbRefreshEndpointPart =
      '/kb-core/v1/auth/refresh?refreshToken=';
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
  static String kbInBotQuery =
      '/knowledges?q&order=DESC&order_field=createdAt&offset&limit=20';

  //Image File Source:----------------------------------------------------------
  static String localFileImagePath =
      'lib/core/assets/source_unit_images/file.png';
  static String webImagePath = 'lib/core/assets/source_unit_images/web.png';
  static String driveImagePath = 'lib/core/assets/source_unit_images/drive.png';
  static String confluenceImagePath =
      'lib/core/assets/source_unit_images/confluence.png';
  static String slackImagePath = 'lib/core/assets/source_unit_images/slack.png';

  //Publish:--------------------------------------------------------------------
  static String getPublishedEndpoint(String id) =>
      '/kb-core/v1/bot-integration/$id/configurations';

  static String telegramValidateEndpoint =
      '/kb-core/v1/bot-integration/telegram/validation';
  static String messengerValidateEndpoint =
      '/kb-core/v1/bot-integration/messenger/validation';
  static String slackValidateEndpoint =
      '/kb-core/v1/bot-integration/slack/validation';

  static String telegramPublishEndpoint(String id) =>
      '/kb-core/v1/bot-integration/telegram/publish/$id';
  static String messengerPublishEndpoint(String id) =>
      '/kb-core/v1/bot-integration/messenger/publish/$id';
  static String slackPublishEndpoint(String id) =>
      '/kb-core/v1/bot-integration/slack/publish/$id';

  static String disconnectBotEndpoint(String id, String type) =>
      '/kb-core/v1/bot-integration/$id/$type';

  static final Map<String, String> lengthOptions = {
    "Short": "short",
    "Medium": "medium",
    "Long": "long"
  };

  static final Map<String, String> formalityOptions = {
    "🤙 Casual": "casual",
    "😐 Neutral": "neutral",
    "🎩 Formal": "formal"
  };

  static final Map<String, String> toneOptions = {
    "😜 Witty": "witty",
    "😲 Direct": 'direct',
    "🧐 Personable": 'personable',
    "🤓 Informational": 'informative',
    "😃 Friendly": 'friendly',
    "😎 Confident": 'confident',
    "😌 Sincere": 'sincere',
    "🤩 Enthusiastic": 'enthusiastic',
    "😇 Optimistic": 'optimistic',
    "🥶 Concerned": 'concerned',
    "🥺 Empathetic": 'empathetic',
  };

  static List<Map<String, dynamic>> baseModels = [
    {
      'name': 'Claude 3 Haiku',
      'id': 'claude-3-haiku-20240307',
      'model': "dify",
      'logoPath': "lib/core/assets/imgs/claude-ai.png",
    },
    {
      'name': 'Claude 3 Sonnet',
      'id': 'claude-3-sonnet-20240229',
      'model': "dify",
      'logoPath': "lib/core/assets/imgs/claude.png"
    },
    {
      'name': 'Gemini',
      'id': 'gemini-1.5-flash-latest',
      'model': "dify",
      'logoPath': "lib/core/assets/imgs/gemini.png"
    },
    {
      'name': 'Gemini 1.5 pro',
      'id': 'gemini-1.5-pro-latest',
      'model': "dify",
      'logoPath': "lib/core/assets/imgs/gemini-1.png"
    },
    {
      'name': 'GPT 4o',
      'id': 'gpt-4o',
      'model': "dify",
      'logoPath': "lib/core/assets/imgs/gpt-4.png"
    },
    {
      'name': 'GPT 4o Mini',
      'id': 'gpt-4o-mini',
      'model': "dify",
      'logoPath': "lib/core/assets/imgs/gpt.png",
    }
  ];

  static final Map<String, String> languages = {
    "Auto": "Let AI choose the language",
    "Afrikaans": "Afrikaans",
    "Albanian": "Shqip",
    "Amharic": "አማርኛ",
    "Arabic": "العربية",
    "Aragonese": "Aragonés",
    "Assamese": "অসমীয়া",
    "Asturian": "Asturianu",
    "Azerbaijani": "Azərbaycan dili",
    "Basque": "Euskara",
    "Belarusian": "Беларуская",
    "Bengali": "বাংলা",
    "Bosnian": "Bosanski",
    "Breton": "Brezhoneg",
    "Bulgarian": "Български",
    "Catalan": "Català",
    "Chinese (Simplified)": "中文 (Simplified)",
    "Chinese (Traditional)": "繁體中文",
    "Cornish": "Kernewek",
    "Croatian": "Hrvatski",
    "Czech": "Čeština",
    "Danish": "Dansk",
    "Dutch": "Nederlands",
    "English (Australia)": "English (Australia)",
    "English (Canada)": "English (Canada)",
    "English (India)": "English (India)",
    "English (New Zealand)": "English (New Zealand)",
    "English (UK)": "English (UK)",
    "English (US)": "English (US)",
    "Esperanto": "Esperanto",
    "Estonian": "Eesti",
    "Finnish": "Suomi",
    "French": "Français",
    "Frisian": "Frysk",
    "Galician": "Galego",
    "Georgian": "ქართული",
    "German": "Deutsch",
    "Greek": "Ελληνικά",
    "Gujarati": "ગુજરાતી",
    "Hausa": "Hausa",
    "Hebrew": "עברית",
    "Hindi": "हिन्दी",
    "Hungarian": "Magyar",
    "Icelandic": "Íslenska",
    "Igbo": "Igbo",
    "Indonesian": "Bahasa Indonesia",
    "Interlingua": "Interlingua",
    "Irish Gaelic": "Gaeilge",
    "Italian": "Italiano",
    "Japanese": "日本語",
    "Kannada": "ಕನ್ನಡ",
    "Kazakh": "Қазақша",
    "Korean": "한국어",
    "Kyrgyz": "Кыргызча",
    "Lao": "ພາສາລາວ",
    "Latvian": "Latviešu",
    "Lithuanian": "Lietuvių",
    "Lojban": "Lojban",
    "Luxembourgish": "Lëtzebuergesch",
    "Macedonian": "Македонски",
    "Maithili": "मैथिली",
    "Malay": "Bahasa Melayu",
    "Malayalam": "മലയാളം",
    "Maltese": "Malti",
    "Marathi": "मराठी",
    "Mongolian": "Монгол",
    "Nepali": "नेपाली",
    "Norwegian": "Norsk",
    "Occitan": "Occitan",
    "Oriya": "ଓଡ଼ିଆ",
    "Oromo": "Afaan Oromoo",
    "Pashto": "پښتو",
    "Persian": "فارسی",
    "Polish": "Polski",
    "Portuguese": "Português",
    "Punjabi": "ਪੰਜਾਬੀ",
    "Romanian": "Română",
    "Russian": "Русский",
    "Sanskrit": "संस्कृतम्",
    "Serbian": "Српски",
    "Shona": "ChiShona",
    "Sindhi": "سنڌي",
    "Sinhala": "සිංහල",
    "Slovak": "Slovenčina",
    "Slovenian": "Slovenščina",
    "Somali": "Af Soomaali",
    "Sotho": "Sesotho",
    "Spanish": "Español",
    "Swahili": "Kiswahili",
    "Swedish": "Svenska",
    "Tagalog": "Tagalog",
    "Tajik": "Тоҷикӣ",
    "Tamil": "தமிழ்",
    "Telugu": "తెలుగు",
    "Thai": "ไทย",
    "Tigrinya": "ትግርኛ",
    "Turkish": "Türkçe",
    "Turkmen": "Türkmençe",
    "Ukrainian": "Українська",
    "Urdu": "اردو",
    "Uzbek": "Oʻzbekcha",
    "Vietnamese": "Tiếng Việt",
    "Welsh": "Cymraeg",
    "Xhosa": "IsiXhosa",
    "Yoruba": "Yorùbá",
    "Zulu": "IsiZulu",
  };

  static final Map<String, String> errorMessage = {
    'empty-email':
        "Your email's a blank canvas! 🎨 Add some words to spark a reply idea.",
    'empty-idea':
        "Even the best ideas need a little nudge. Type something, and let's get brainstorming!"
  };

  static final Map<String, String> actionType = {
    '✍️ Translate to': 'translate',
    '💬 Revise it': 'revise',
    '🔎 Extract the main Information': 'custom',
    '👨‍🏫 Make it Constructive': 'custom',
    '📝 Make it more Detailed': 'custom',
    '🗣 Make it more Persuasive': 'custom',
    '🖋️ Paraphrase it': 'custom',
    '📋 Summarize it': 'custom',
    '🪶 Simplify it': 'custom',
  };
}
