import 'package:flutter/material.dart';
import 'package:step_ai/features/prompt/data/models/prompt_model.dart';
import 'package:step_ai/features/prompt/presentation/widgets/language_custom_dropdown.dart';
import 'package:step_ai/shared/styles/vertical_spacing.dart';

import '../styles/colors.dart';

class PromptEditor extends StatefulWidget {
  final PromptModel promptModel;
  final Function(String) returnPrompt;

  const PromptEditor({Key? key, required this.promptModel, required this.returnPrompt}) : super(key: key);

  @override
  State<PromptEditor> createState() => _PromptEditorState();
}

class _PromptEditorState extends State<PromptEditor> {
  final TextEditingController _promptController = TextEditingController();
  List<TextEditingController> _controllers = [];
  List<String> _placeholders = [];
  bool _expanded = false;
  String _language = 'Auto';
  final Map<String, String> _languages = {
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

  @override
  void initState() {
    super.initState();
    _promptController.text = widget.promptModel.content;
    _initializeControllers();
  }

  @override
  void dispose() {
    _promptController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeControllers() {
    // Extract placeholders, e.g., [public], [keyword]
    final regExp = RegExp(r'\[(.+?)\]');
    _placeholders = regExp
        .allMatches(_promptController.text)
        .map((e) => e.group(1)!)
        .toList();

    // Create a TextEditingController for each placeholder
    _controllers = List.generate(
      _placeholders.length,
      (index) => TextEditingController(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            widget.promptModel.title,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 20,
                ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: TColor.petRock,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: widget.promptModel.category,
                        ),
                        const TextSpan(text: ' · '),
                        TextSpan(
                          text: widget.promptModel.userName,
                        ),
                      ]),
                ),
              ),
              VSpacing.md,
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    }, child:  Text(!_expanded ? "View prompt" : "Hide prompt", style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: TColor.tamarama,
                    fontSize: 13,
                  ),),
                  )
                ],
              ),
              VSpacing.sm,
              if (_expanded) TextField(
                autocorrect: false,
                controller: _promptController,
                cursorColor: TColor.squidInk,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  color: TColor.squidInk,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        width: 1.0,
                        color: TColor.tamarama,
                      )),
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 15,
                    color: TColor.petRock.withOpacity(0.5),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        width: 1.0,
                        color: TColor.petRock.withOpacity(0.5),
                      )),
                ),
                onChanged: (value) {
                  setState(() {
                    _initializeControllers(); // Dynamically update controllers
                  });
                },
              ),
              VSpacing.md,
              Align(
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: TColor.petRock,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        wordSpacing: 1,
                      ),
                      children: const [
                        TextSpan(text: 'Language'),
                      ]),
                ),
              ),
              VSpacing.sm,
              LanguageCustomDropdown(
                  value: _language,
                  items: _languages,
                  onChanged: (value) {
                    setState(() {
                      _language = value ?? "Auto";
                    });
                  },
                  hintText: 'Language'),
              VSpacing.md,
      
              // Placeholder input fields
              for (int i = 0; i < _placeholders.length; i++) ...[
                TextField(
                  controller: _controllers[i],
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          width: 1.0,
                          color: TColor.tamarama,
                        )),
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15,
                          color: TColor.petRock.withOpacity(0.5),
                        ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          width: 1.0,
                          color: TColor.petRock.withOpacity(0.5),
                        )),
      
                    hintText: _placeholders[i], // Use placeholder name as hint
                  ),
                ),
                const SizedBox(height: 10),
              ],
              VSpacing.md,
              // Submit button to show the filled prompt
              Center(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      final values = _controllers.map((c) => c.text).toList();
                      final filledPrompt =
                          _fillPrompt(_promptController.text, values);
                      widget.returnPrompt(filledPrompt);
                      Navigator.of(context).pop();
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: TColor.tamarama,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 50.0, right: 50.0, top: 10.0, bottom: 10.0),
                        child: Text(
                          'Use this Prompt',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: TColor.doctorWhite,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fillPrompt(String template, List<String> values) {
    String result = template;
    for (final value in values) {
      result = result.replaceFirst(RegExp(r'\[.+?\]'), value);
    }
    if (!_language.toLowerCase().contains("auto")) {
      result += "\nRespond in $_language";
    }

    return result;
  }
}
