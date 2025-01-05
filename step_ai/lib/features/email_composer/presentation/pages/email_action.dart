import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/email_composer/domain/entity/compose_email.dart';
import 'package:step_ai/features/email_composer/presentation/notifier/usage_token_notifier.dart';
import 'package:step_ai/shared/styles/horizontal_spacing.dart';
import 'package:step_ai/shared/styles/vertical_spacing.dart';
import 'package:step_ai/shared/widgets/history_drawer.dart';
import '../../../../config/routes/routes.dart';
import '../../../../shared/usecases/pricing_redirect_service.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/image_by_text_widget.dart';
import '../../../email_composer/domain/entity/assistant.dart';
import 'package:step_ai/features/email_composer/presentation/widgets/ai_selector.dart';

import '../../../../config/constants.dart';
import '../../../../shared/styles/colors.dart';
import '../notifier/ai_action_notifier.dart';
import '../widgets/collapsible_button_chips.dart';

class EmailAction extends StatefulWidget {
  const EmailAction({super.key});

  @override
  State<EmailAction> createState() => _EmailActionState();
}

class _EmailActionState extends State<EmailAction> {
  final _formKey = GlobalKey<FormState>();


  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _senderController = TextEditingController();
  final TextEditingController _receiverController = TextEditingController();
  final TextEditingController _yourEmailController = TextEditingController();
  final TextEditingController _mainIdeaController = TextEditingController();
  final _assistantList = Constant.baseModels.map(Assistant.fromJson).toList();
  late Assistant _selectedAssistant;
  late AiActionNotifier _composerNotifier;
  late UsageTokenNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _selectedAssistant = _assistantList.first;

    _mainIdeaController.addListener(_textChange);
    _yourEmailController.addListener(_textChange);
    final notifier = Provider.of<UsageTokenNotifier>(context, listen: false);

    notifier.loadUsageToken();
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CollapsibleChipListScreen(
                              actions: Constant.actionType,
                              onClick: (m, l) {
                                if (_yourEmailController.text.isEmpty) {
                                  showErrorDialog(context, Constant.errorMessage['empty-email']!);
                                  return;
                                }
                                String action = m.replaceAll(Constant.emojiRegex, '').trim();
                                _composeEmail(_yourEmailController.text, action,
                                    Constant.actionType[m]!,
                                    language: l);
                                _notifier.loadUsageToken();
                              }),
                        ),
                      )
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
              hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
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