import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:step_ai/features/prompt/data/models/prompt_model.dart';
import 'package:step_ai/features/prompt/di/data_injection/prompt_data_di.dart';
import 'package:step_ai/features/prompt/presentation/widgets/buttons_pair.dart';
import 'package:step_ai/features/prompt/presentation/widgets/copy_with_tooltip.dart';
import 'package:step_ai/features/prompt/presentation/widgets/private_form.dart';
import 'package:step_ai/features/prompt/presentation/widgets/private_update_form.dart';
import 'package:step_ai/features/prompt/presentation/widgets/public_form.dart';
import 'package:step_ai/features/prompt/presentation/widgets/public_update_form.dart';
import 'package:step_ai/shared/styles/horizontal_spacing.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/varela_round_style.dart';
import '../../../../shared/styles/vertical_spacing.dart';

class PromptUpdateDialog extends StatefulWidget {
  final Function(PromptModel) onCreatePrompt;
  final PromptModel prompt;

  PromptUpdateDialog({
    super.key,
    required this.onCreatePrompt, required this.prompt,
  });

  @override
  State<PromptUpdateDialog> createState() => _PromptUpdateDialogState();
}

class _PromptUpdateDialogState extends State<PromptUpdateDialog> {
  late bool _isPublic;
  late PromptModel _prompt;
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _isPublic = false;
    _prompt = widget.prompt;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TColor.doctorWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Update Prompt",
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            VSpacing.sm,
            SizedBox(
              height: 400,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: ButtonsPair(
                          isFirstSelected: !_isPublic,
                          firstOnTap: () {
                            setState(() {
                              _isPublic = false;
                            });
                            _prompt = _prompt.copyWith(isPublic: _isPublic);
                          },
                          secondOnTap: () {
                            setState(() {
                              _isPublic = true;
                            });
                            _prompt = _prompt.copyWith(isPublic: _isPublic);
                          },
                          firstButtonText: 'Private Prompt',
                          secondButtonText: 'Public Prompt',
                          borderRadius: 10,
                        )),
                    VSpacing.sm,
                    _isPublic ? PublicUpdateForm( onTitleChanged: (String value) {
                      setState(() {
                        _prompt = _prompt.copyWith(title: value);
                      });
                    }, onContentChanged: (String value) {
                      setState(() {
                        _prompt = _prompt.copyWith(content: value);
                      });
                    }, onCategoryChanged: (String value) {
                      setState(() {
                        _prompt = _prompt.copyWith(category: value.toLowerCase());
                      });
                    }, onLanguageChanged: (String value) {
                      setState(() {
                        _prompt = _prompt.copyWith(language: value.toLowerCase());
                      });
                    }, onDescriptionChanged: (String value) {
                      setState(() {
                        _prompt = _prompt.copyWith(description: value.toLowerCase());
                      });
                    }, prompt: _prompt,) : PrivateUpdateForm(
                      onTitleChanged: (value) {
                        setState(() {
                          _prompt = _prompt.copyWith(title: value);
                        });
                      },
                      onContentChanged: (value) {
                        setState(() {
                          _prompt = _prompt.copyWith(content: value);
                        });
                      },
                      prompt: _prompt,
                    ),
                    VSpacing.md,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          splashColor: TColor.tamarama.withOpacity(0.2),
                          onTap: () => Navigator.of(context).pop(),
                          child: AnimatedContainer(
                            curve: Curves.decelerate,
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: TColor.tamarama,
                                  width: 2,
                                )),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              'Cancel',
                              style: VarelaRoundStyle.basicW600.copyWith(
                                color: TColor.squidInk,
                              ),
                            ),
                          ),
                        ),
                        HSpacing.sm,
                        InkWell(
                          splashColor: TColor.finePine.withOpacity(0.2),
                          onTap: _isAdding ? () {} : () async {
                            setState(() {
                              _isAdding = true;
                            });
                            try {
                              await widget.onCreatePrompt(_prompt);
                              await Future.delayed(const Duration(milliseconds: 500));
                              Navigator.of(context).pop();
                            } finally {
                              setState(() {
                                _isAdding = true;
                              });
                            }
                          },
                          child: AnimatedContainer(
                            curve: Curves.decelerate,
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: TColor.tamarama,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: _isAdding
                                ? Row(
                              children: [
                                LoadingAnimationWidget.discreteCircle(color: TColor.doctorWhite, size: 12),
                                HSpacing.sm,
                                Text(
                                  'Update',
                                  style: VarelaRoundStyle.basicW600.copyWith(
                                    color: TColor.doctorWhite,
                                  ),
                                )
                              ],
                            )
                                : Text(
                              'Update',
                              style: VarelaRoundStyle.basicW600.copyWith(
                                color: TColor.doctorWhite,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
