import 'package:flutter/material.dart';
import 'package:step_ai/features/prompt/presentation/widgets/category_custom_dropdown.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/horizontal_spacing.dart';
import '../../../../shared/styles/vertical_spacing.dart';
import 'language_custom_dropdown.dart';

class PublicForm extends StatefulWidget {
  const PublicForm({super.key, required this.formKey, required this.onTitleChanged, required this.onContentChanged, required this.onCategoryChanged, required this.onLanguageChanged, required this.onDescriptionChanged});
  final GlobalKey<FormState> formKey;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onContentChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<String> onDescriptionChanged;

  @override
  State<PublicForm> createState() => _PublicFormState();
}

class _PublicFormState extends State<PublicForm> {
  String _selectedLanguage = "Auto";
  String _selectedCategory = "Other";

  final List<String> _categories = [
    "Marketing",
    "Business",
    "SEO",
    "Writing",
    "Coding",
    "Career",
    "Chatbot",
    "Education",
    "Fun",
    "Productivity",
    "Other",
  ];

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
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
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
                  children: [
                    const TextSpan(text: 'Language'),
                    TextSpan(
                        text: ' *',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: TColor.poppySurprise,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            )),
                  ]),
            ),
          ),
          VSpacing.sm,
          LanguageCustomDropdown(
            value: _selectedLanguage,
            hintText: "Select Language",
            items: _languages,
            onChanged: (value) {
              widget.onLanguageChanged(value??"auto");
              setState(() {
                _selectedLanguage = value??"Auto";
              });
            },
          ),
          VSpacing.sm,
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
                  children: [
                    const TextSpan(text: 'Title'),
                    TextSpan(
                        text: ' *',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: TColor.poppySurprise,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            )),
                  ]),
            ),
          ),
          VSpacing.sm,
          TextFormField(
            onChanged: widget.onTitleChanged,
            cursorColor: TColor.tamarama,
            decoration: InputDecoration(
              filled: true,
              fillColor: TColor.northEastSnow,
              focusColor: TColor.grahamHair,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
                gapPadding: 4.0,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: TColor.tamarama),
                borderRadius: BorderRadius.circular(15),
                gapPadding: 4.0,
              ),
              hintText: "Title of the prompt",
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: TColor.petRock.withOpacity(0.5),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    wordSpacing: 1,
                  ),
            ),
          ),
          VSpacing.sm,
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
                  children: [
                    const TextSpan(text: 'Category'),
                    TextSpan(
                        text: ' *',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: TColor.poppySurprise,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        )),
                  ]),
            ),
          ),
          VSpacing.sm,
          CategoryCustomDropdown(
              value: _selectedCategory,
              items: _categories,
              onChanged: (value) {
                widget.onCategoryChanged(value??"other");
                setState(() {
                  _selectedCategory = value!;
                });
              },
              hintText: "Select category"),
          VSpacing.sm,
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
                    TextSpan(text: 'Description'),
                  ]),
            ),
          ),
          VSpacing.sm,
          TextFormField(
            onChanged: widget.onDescriptionChanged,
            maxLines: 4,
            cursorColor: TColor.tamarama,
            decoration: InputDecoration(
              filled: true,
              fillColor: TColor.northEastSnow,
              focusColor: TColor.grahamHair,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
                gapPadding: 4.0,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: TColor.tamarama),
                borderRadius: BorderRadius.circular(15),
                gapPadding: 4.0,
              ),
              hintText:
              "Describe your prompt so that other can have a better understanding.",
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TColor.petRock.withOpacity(0.5),
                fontSize: 15,
                fontWeight: FontWeight.w500,
                wordSpacing: 1,
              ),
            ),
          ),
          VSpacing.sm,
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
                  children: [
                    const TextSpan(text: 'Prompt'),
                    TextSpan(
                        text: ' *',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: TColor.poppySurprise,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            )),
                  ]),
            ),
          ),
          VSpacing.sm,
          Container(
            decoration: BoxDecoration(
              color: TColor.tamarama.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Icon(
                    Icons.info_rounded,
                    color: TColor.tamarama,
                  ),
                  HSpacing.sm,
                  Text(
                    "Use square brackets [ ] to specify user input.",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: TColor.squidInk),
                  ),
                ],
              ),
            ),
          ),
          VSpacing.sm,
          TextFormField(
            onChanged: widget.onContentChanged,
            maxLines: 4,
            cursorColor: TColor.tamarama,
            decoration: InputDecoration(
              filled: true,
              fillColor: TColor.northEastSnow,
              focusColor: TColor.grahamHair,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
                gapPadding: 4.0,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: TColor.tamarama),
                borderRadius: BorderRadius.circular(15),
                gapPadding: 4.0,
              ),
              hintText:
                  "e.g: Write a [cover letter/resume/thank you note] for a [Job Title] position at [Company Name].",
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: TColor.petRock.withOpacity(0.5),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    wordSpacing: 1,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
