import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/email_composer/domain/entity/ai_email.dart';
import 'package:step_ai/features/email_composer/domain/entity/compose_email.dart';
import 'package:step_ai/features/email_composer/domain/entity/email_style.dart';
import 'package:step_ai/features/email_composer/domain/entity/response_email.dart';
import 'package:step_ai/features/email_composer/domain/usecase/generate_email_response_usecase.dart';
import 'package:step_ai/features/email_composer/presentation/notifier/email_composer_notifier.dart';
import 'package:step_ai/features/email_composer/presentation/notifier/usage_token_notifier.dart';
import 'package:step_ai/features/email_composer/presentation/widgets/action_tile.dart';
import 'package:step_ai/features/prompt/presentation/widgets/language_custom_dropdown.dart';
import 'package:step_ai/shared/styles/horizontal_spacing.dart';
import 'package:step_ai/shared/styles/vertical_spacing.dart';
import 'package:step_ai/shared/widgets/category_chips_selector.dart';
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
import '../../domain/usecase/generate_idea_usecase.dart';
import '../notifier/ai_action_notifier.dart';

class EmailAction extends StatefulWidget {
  const EmailAction({super.key});

  @override
  State<EmailAction> createState() => _EmailActionState();
}

class _EmailActionState extends State<EmailAction> {
  final _formKey = GlobalKey<FormState>();

  var _isGeneratingEmail = false;

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _senderController = TextEditingController();
  final TextEditingController _receiverController = TextEditingController();
  final TextEditingController _yourEmailController = TextEditingController();
  final TextEditingController _mainIdeaController = TextEditingController();
  final _assistantList = Constant.baseModels.map(Assistant.fromJson).toList();
  final _languages = Constant.languages;
  late Assistant _selectedAssistant;
  late String _selectedLanguage;
  late AiActionNotifier _composerNotifier;
  late UsageTokenNotifier _notifier;
  List<String> ideas = [];

  @override
  void initState() {
    super.initState();
    _selectedAssistant = _assistantList.first;
    _selectedLanguage = _languages.keys.first;

    _mainIdeaController.addListener(_textChange);
    _yourEmailController.addListener(_textChange);
    final notifier = Provider.of<UsageTokenNotifier>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await notifier.loadUsageToken();
    });

    notifier.addListener(() {
      if (notifier.hasError) {
        Navigator.of(context).pushReplacementNamed(Routes.authenticate);
      }
    });
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
    _senderController.dispose();
    _receiverController.dispose();
    _yourEmailController.dispose();
    _mainIdeaController.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final notifier =
            Provider.of<UsageTokenNotifier>(context, listen: false);
        notifier.removeListener(() {});
      }
    });

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
    _composerNotifier = Provider.of<AiActionNotifier>(context, listen: true);
    _notifier = Provider.of<UsageTokenNotifier>(context, listen: true);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: HistoryDrawer(),
      onDrawerChanged: (isOpened) {
        if (isOpened) {
          FocusScope.of(context).unfocus();
        }
      },
      appBar: AppBar(
        title: const Text("Email Action"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildForm(),
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
                      _buildEmailFormField(
                          "Email:", _yourEmailController, _validateField),
                      CollapsibleChipListScreen(
                          actions: Constant.actionType,
                          onClick: (m, l) {
                            if (_yourEmailController.text.isEmpty) {
                              showErrorDialog(context, Constant.errorMessage['empty-email']!);
                              return;
                            }
                            String action = m.substring(3);
                            _composeEmail(_yourEmailController.text, action,
                                Constant.actionType[m]!,
                                language: l);
                            _notifier.loadUsageToken();
                          })
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            ],
                          ),
                        ),
                        _buildActionField(_mainIdeaController),
                        const SizedBox(
                          height: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
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
                  icon: _isGeneratingEmail
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
                      : _composerNotifier.isGeneratingEmail
                          ? LoadingAnimationWidget.discreteCircle(
                              color: TColor.doctorWhite, size: 14)
                          : Icon(Icons.send_rounded,
                              size: 20, color: TColor.tamarama),
                  onPressed: () async {
                    await _composeEmail(_yourEmailController.text,
                        _mainIdeaController.text, "ask");
                    _mainIdeaController.clear();
                    _notifier.loadUsageToken();
                  },
                )
              : IconButton(
                  padding: const EdgeInsets.all(2),
                  icon: _composerNotifier.isGeneratingEmail
                      ? LoadingAnimationWidget.discreteCircle(
                          color: TColor.doctorWhite, size: 14)
                      : Icon(Icons.send_rounded,
                          size: 20, color: TColor.petRock),
                  onPressed: () {
                    showErrorDialog(
                        context, Constant.errorMessage['empty-email']!);
                  },
                ),
          hintText: "Tell STEP what you wanna write...",
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

  Widget _buildEmailFormField(String label, TextEditingController controller,
      FormFieldValidator<String> validator) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: TColor.petRock,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
              ),
              IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () async {
                    if (_yourEmailController.text.isEmpty) {
                      showErrorDialog(context, Constant.errorMessage['empty-email']!);
                      return;
                    }
                    await Clipboard.setData(
                        ClipboardData(text: _yourEmailController.text));
                  }),
            ],
          ),
          VSpacing.sm,
          TextFormField(
            maxLines: 10,
            minLines: 10,
            controller: controller,
            validator: validator,
            enabled: !_composerNotifier.isGeneratingEmail,
            decoration: InputDecoration(
              hintText: "Your email",
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

  Future<void> _composeEmail(String text, String action, String type,
      {String? language}) async {
    ComposeEmail composeEmail = ComposeEmail(
        action: action,
        type: type,
        content: text,
        assistant: _selectedAssistant,
        language: language);

    await _composerNotifier.composeEmail(composeEmail);

    setState(() {
      _yourEmailController.text = _composerNotifier.currentEmail() != null
          ? _composerNotifier.currentEmail()!.email
          : "";
    });
  }


}

class CollapsibleChipListScreen extends StatefulWidget {
  final Map<String, String>
      actions; // Map for chip labels and their corresponding actions
  final void Function(String, String?) onClick;
  CollapsibleChipListScreen({
    required this.actions,
    required this.onClick,
  });

  @override
  State<CollapsibleChipListScreen> createState() =>
      _CollapsibleChipListScreenState();
}

class _CollapsibleChipListScreenState extends State<CollapsibleChipListScreen> {
  // Callback for chip click
  String _selectedLanguage = Constant.languages.values.first;

  final _languages = Constant.languages;

  bool _canceled = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0, // Horizontal spacing between chips
        runSpacing: 8.0, // Vertical spacing between rows of chips
        children: widget.actions.entries.map((entry) {
          return ActionChip(
            side: BorderSide.none,
            label: Text(entry.key),
            onPressed: () async {
              if (entry.key.contains("Translate to")) {
                await _showLanguageSelectorDialog(context);
                print(_selectedLanguage);
                if (!_canceled) {
                  _canceled = true;
                  return widget.onClick(entry.key, _selectedLanguage);
                }

                return;
              }
              widget.onClick(entry.key, null); // Trigger callback with action
            },
            backgroundColor: TColor.tamarama,
            labelStyle: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: TColor.doctorWhite),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _showLanguageSelectorDialog(BuildContext context) {
    setState(() {
      _selectedLanguage = _languages.values.first;
    });
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: StatefulBuilder(builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Language',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          _canceled = true;
                          Navigator.of(context).pop();
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  LanguageCustomDropdown(
                      value: _selectedLanguage,
                      items: _languages,
                      onChanged: (l) {
                        setState(() {
                          _selectedLanguage = l!;
                        });
                      },
                      hintText: "Select language"),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            _canceled = true;
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text('Cancel'),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            _canceled = false;
                            Navigator.of(context).pop();
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: TColor.tamarama,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text(
                                'OK',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
