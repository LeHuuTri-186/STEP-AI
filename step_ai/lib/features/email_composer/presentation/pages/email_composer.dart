import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/email_composer/domain/entity/ai_email.dart';
import 'package:step_ai/features/email_composer/domain/entity/email_style.dart';
import 'package:step_ai/features/email_composer/domain/entity/response_email.dart';
import 'package:step_ai/features/email_composer/presentation/notifier/email_composer_notifier.dart';
import 'package:step_ai/features/email_composer/presentation/notifier/usage_token_notifier.dart';
import 'package:step_ai/features/email_composer/presentation/widgets/action_tile.dart';
import 'package:step_ai/features/prompt/presentation/widgets/language_custom_dropdown.dart';
import 'package:step_ai/shared/styles/horizontal_spacing.dart';
import 'package:step_ai/shared/styles/vertical_spacing.dart';
import 'package:step_ai/shared/widgets/history_drawer.dart';
import '../../../../config/routes/routes.dart';
import '../../../../shared/usecases/pricing_redirect_service.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/image_by_text_widget.dart';
import '../../../email_composer/domain/entity/assistant.dart';
import 'package:step_ai/features/email_composer/presentation/widgets/ai_selector.dart';
import 'package:step_ai/shared/widgets/category_selector.dart';

import '../../../../config/constants.dart';
import '../../../../shared/styles/colors.dart';

class EmailComposer extends StatefulWidget {
  const EmailComposer({super.key});

  @override
  State<EmailComposer> createState() => _EmailComposerState();
}

class _EmailComposerState extends State<EmailComposer> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _focusNode = FocusNode();

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _senderController = TextEditingController();
  final TextEditingController _receiverController = TextEditingController();
  final TextEditingController _yourEmailController = TextEditingController();
  final TextEditingController _mainIdeaController = TextEditingController();
  final _formalityOptions = Constant.formalityOptions.keys.toList();
  final _toneOptions = Constant.toneOptions.keys.toList();
  final _lengthOptions = Constant.lengthOptions.keys.toList();
  final _assistantList = Constant.baseModels.map(Assistant.fromJson).toList();
  final _languages = Constant.languages;
  late String _selectedFormality;
  late String _selectedTone;
  late String _selectedLength;
  late Assistant _selectedAssistant;
  late String _selectedLanguage;
  late EmailComposerNotifier _composerNotifier;
  late UsageTokenNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _selectedFormality = _formalityOptions.first;
    _selectedTone = _toneOptions.first;
    _selectedLength = _lengthOptions.first;
    _selectedAssistant = _assistantList.first;
    _selectedLanguage = _languages.keys.first;

    _mainIdeaController.addListener(_textChange);
    _yourEmailController.addListener(_textChange);
    final notifier = Provider.of<UsageTokenNotifier>(context, listen: false);
    notifier.loadUsageToken();
    Provider.of<EmailComposerNotifier>(context, listen: false).ideas = [];

  }

  void _textChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _mainIdeaController.removeListener(_textChange);
    _yourEmailController.removeListener(_textChange);
    // Dispose controllers to free resources
    _subjectController.dispose();
    _focusNode.dispose();
    _senderController.dispose();
    _receiverController.dispose();
    _yourEmailController.dispose();
    _mainIdeaController.dispose();
    super.dispose();
  }

  String? _validateField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Put a few words into it';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    _composerNotifier =
        Provider.of<EmailComposerNotifier>(context, listen: true);
    _notifier = Provider.of<UsageTokenNotifier>(context, listen: true);

    if (_notifier.hasError) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Email Composer"),
        ),
        resizeToAvoidBottomInset: true,
        drawer: HistoryDrawer(),
        onDrawerChanged: (isOpened) {
          if (isOpened) {
            FocusScope.of(context).unfocus();
          }
        },
        body: Center(
          child: Text(
            "An error has occurred, please try again later!",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: HistoryDrawer(),
      onDrawerChanged: (isOpened) {
        if (isOpened) {
          FocusScope.of(context).unfocus();
        }
      },
      appBar: AppBar(
        title: const Text("Email Composer"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildResult(String email) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Word count: ${email.trim().split(RegExp(r'\s+')).length}',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: TColor.tamarama,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Implement copying logic
                      Clipboard.setData(ClipboardData(text: email));
                    },
                    tooltip: 'Copy',
                    icon: const Icon(Icons.copy_rounded),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 300,
              child: SingleChildScrollView(child: Text(email, style: Theme.of(context).textTheme.bodyLarge))),
          VSpacing.sm,
          Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(TColor.tamarama),
                  ),
                  onPressed: Navigator.of(context).pop,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Ok",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: TColor.doctorWhite,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                    ),
                  ))),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildEmailFormField("Email to reply to:",
                          _yourEmailController, _validateField),
                      if (_composerNotifier.ideas.isNotEmpty)
                        ..._composerNotifier.ideas.map(
                          (idea) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ActionTile(
                                action: idea,
                                onTap: _composerNotifier.isGeneratingEmail
                                    ? () {}
                                    : () async {
                                        await _replyEmail(idea);
                                      }),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SafeArea(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AiSelector(
                                    assistants: _assistantList,
                                    onAssistantSelected: (a) {
                                      setState(() {
                                        _selectedAssistant = a;
                                      });
                                    },
                                    selectedAssistant: _selectedAssistant,
                                  ),
                                  IconButton(
                                    tooltip: "Generate ideas",
                                    onPressed:
                                        _composerNotifier.isGeneratingIdea
                                            ? () {}
                                            : () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  await _generateIdeas();
                                                } else {
                                                  showErrorDialog(
                                                      context,
                                                      Constant.errorMessage[
                                                          'empty-email']!);
                                                }
                                              },
                                    icon: _composerNotifier.isGeneratingIdea
                                        ? Row(
                                            children: [
                                              LoadingAnimationWidget
                                                  .discreteCircle(
                                                      color: TColor.doctorWhite,
                                                      size: 12),
                                              HSpacing.sm,
                                              Text(
                                                "Generating...",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .copyWith(
                                                      fontSize: 13,
                                                      color: TColor.doctorWhite,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                              ),
                                            ],
                                          )
                                        : Icon(
                                            Icons.lightbulb_outline_rounded,
                                            color: TColor.doctorWhite,
                                          ),
                                    color: TColor.goldenState,
                                    highlightColor: TColor.goldenState,
                                    style: ButtonStyle(
                                        backgroundColor:
                                            _composerNotifier.isGeneratingIdea
                                                ? WidgetStatePropertyAll(
                                                    TColor.goldenState)
                                                : WidgetStatePropertyAll(
                                                    TColor.tamarama)),
                                  )
                                ])),
                        _buildActionField(_mainIdeaController),
                        const SizedBox(
                          height: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              if (_notifier.isLoading)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child:
                                          LoadingAnimationWidget.discreteCircle(
                                              color: TColor.doctorWhite,
                                              size: 9)),
                                ),
                              ImageByText(
                                imagePath: "lib/core/assets/imgs/flame.png",
                                text: _notifier.model != null
                                    ? _notifier.model!.availableTokens
                                        .toString()
                                    : "",
                              ),
                              HSpacing.sm,
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () async =>
                                      await PricingRedirectService.call(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.rocket_launch_rounded,
                                          color: TColor.tamarama,
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        GradientText(
                                          'Upgrade',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: TColor.tamarama,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight,
                                            tileMode: TileMode.decal,
                                            colors: [
                                              TColor.tamarama,
                                              TColor.goldenState,
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Future<void> _generateIdeas(
      {String suggestion = "Suggest 3 ideas for this email"}) async {
    EmailStyle style = EmailStyle(
        formality: _selectedFormality,
        length: _selectedLength,
        tone: _selectedTone);
    AiEmail email = _buildAiEmail(style, suggestion, _mainIdeaController.text);
    await _composerNotifier.generateIdeas(email);
    await _notifier.loadUsageToken();
  }

  AiEmail _buildAiEmail(EmailStyle style, String action, String mainIdea) {
    return AiEmail(
      subject: _subjectController.text,
      sender: _senderController.text,
      receiver: _receiverController.text,
      action: action,
      email: _yourEmailController.text,
      mainIdea: mainIdea,
      language: _languages[_selectedLanguage] ?? "English",
      style: style,
    );
  }

  Widget _buildAdvancedOptionsButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        focusColor: Colors.transparent,
        splashColor: TColor.northEastSnow,
        hoverColor: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          showDialog(
              context: context,
              builder: (_) {
                return _buildStyleAndLength();
              });
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            "Advanced Options",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 13,
                color: TColor.tamarama,
                fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }

  Widget _buildStyleAndLength() {
    return Dialog(
      backgroundColor: TColor.doctorWhite,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: min(450, MediaQuery.of(context).size.width * 0.8),
              height: 600,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Advanced Options",
                          style: Theme.of(context).textTheme.bodyLarge),
                      CloseButton(
                        onPressed: Navigator.of(context).pop,
                      )
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRowFormField("Subject:", _subjectController),
                          _buildRowFormField("From:", _senderController),
                          _buildRowFormField("To:", _receiverController),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Language:",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: TColor.petRock.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LanguageCustomDropdown(
                                value: _selectedLanguage,
                                items: _languages,
                                onChanged: (e) {
                                  setState(() {
                                    _selectedLanguage = e ?? "Auto";
                                  });
                                },
                                hintText: "Select a language"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Length:",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: TColor.petRock.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CategoryChips(
                                categories: _lengthOptions,
                                selectedCategory: _selectedLength,
                                onCategorySelected: (e) {
                                  setState(() {
                                    _selectedLength = e;
                                  });
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Formality:",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: TColor.petRock.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CategoryChips(
                                categories: _formalityOptions,
                                selectedCategory: _selectedFormality,
                                onCategorySelected: (e) {
                                  setState(() {
                                    _selectedFormality = e;
                                  });
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Tone:",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: TColor.petRock.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CategoryChips(
                                categories: _toneOptions,
                                selectedCategory: _selectedTone,
                                onCategorySelected: (e) {
                                  setState(() {
                                    _selectedTone = e;
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionField(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        enabled: !_composerNotifier.isGeneratingEmail,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: TColor.petRock,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: _mainIdeaController.text.isNotEmpty
              ? IconButton(
                  padding: const EdgeInsets.all(2),
                  icon: _composerNotifier.isGeneratingEmail
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: TColor.tamarama,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: LoadingAnimationWidget.discreteCircle(
                                color: TColor.doctorWhite, size: 12),
                          ))
                      : Icon(Icons.send_rounded,
                          size: 20, color: TColor.tamarama),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _replyEmail(_mainIdeaController.text);
                      _mainIdeaController.clear();
                    } else {
                      showErrorDialog(
                          context, Constant.errorMessage['empty-email']!);
                    }
                  },
                )
              : IconButton(
                  padding: const EdgeInsets.all(2),
                  icon: _composerNotifier.isGeneratingEmail
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: TColor.tamarama,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: LoadingAnimationWidget.discreteCircle(
                                color: TColor.doctorWhite, size: 12),
                          ))
                      : Icon(Icons.send_rounded,
                          size: 20, color: TColor.petRock),
                  onPressed: () {
                    showErrorDialog(
                        context, Constant.errorMessage['empty-email']!);
                  },
                ),
          hintText: "Tell STEP how you would like to reply...",
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: TColor.petRock.withOpacity(0.7),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
          labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: TColor.petRock.withOpacity(0.7),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
          filled: true,
          fillColor: TColor.northEastSnow,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(
              color: TColor.tamarama,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Future<void> _replyEmail(String mainIdea) async {
    EmailStyle style = EmailStyle(
        formality: _selectedFormality,
        length: _selectedLength,
        tone: _selectedTone);
    AiEmail email = _buildAiEmail(style, "Reply to this email", mainIdea);

    await _composerNotifier.generateEmail(email);

    ResponseEmail result =
        _composerNotifier.emailList[_composerNotifier.currentEmailIndex];

    _notifier.loadUsageToken();

    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return AlertDialog(
            backgroundColor: TColor.doctorWhite,
            contentPadding: const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(children: [
                Column(
                  children: [
                    _buildResult(result.email),
                  ],
                ),
              ]),
            ),
          );
        },
      );
    }
  }

  Widget _buildRowFormField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: TColor.petRock.withOpacity(0.8),
                  fontSize: 14,
                ),
          ),
          TextFormField(
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: TColor.petRock,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
            controller: controller,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: TColor.petRock.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
              labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: TColor.petRock.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
              filled: true,
              fillColor: TColor.northEastSnow,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: TColor.tamarama,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailFormField(String label, TextEditingController controller,
      FormFieldValidator<String> validator) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: TColor.petRock,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
              ),
              _buildAdvancedOptionsButton(),
            ],
          ),
          VSpacing.sm,
          TextFormField(
            maxLines: 10,
            minLines: 10,
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              hintText: "Parse the email you would like to reply",
              hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: TColor.petRock.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
              labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: TColor.petRock.withOpacity(0.7),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
              filled: true,
              fillColor: TColor.northEastSnow,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: TColor.tamarama,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: TColor.doctorWhite,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Oops!",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              CloseButton(
                onPressed: Navigator.of(context).pop,
              )
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(error,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: TColor.petRock,
                      fontWeight: FontWeight.w700,
                    )),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Got it",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: TColor.poppySurprise,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}
