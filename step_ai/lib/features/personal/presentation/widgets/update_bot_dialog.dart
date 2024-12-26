import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:step_ai/features/personal/data/models/bot_res_dto.dart';
import 'package:step_ai/features/personal/presentation/widgets/update_bot_form.dart';
import 'package:step_ai/shared/styles/horizontal_spacing.dart';
import 'package:step_ai/shared/styles/varela_round_style.dart';
import 'package:step_ai/shared/styles/vertical_spacing.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../shared/styles/colors.dart';
import '../../../prompt/presentation/notifier/form_model/form_provider.dart';

class BotUpdateDialog extends StatefulWidget {
  final BotResDto oldBot;
  final Function(BotResDto) onUpdateBot;

  BotUpdateDialog({
    super.key,
    required this.onUpdateBot,
    required this.oldBot,
  });

  @override
  State<BotUpdateDialog> createState() => _BotUpdateDialogState();
}

class _BotUpdateDialogState extends State<BotUpdateDialog> {
  late BotResDto _botData;
  late bool _isAdding;
  @override
  void initState() {
    super.initState();
    _isAdding = false;
    _botData = widget.oldBot;
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
                    "Update Bot",
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
                    VSpacing.sm,
                    UpdateBotForm(formKey: getIt<FormModel>().publicFormKey, onNameChanged: (String value) {
                      setState(() {
                        _botData = _botData.copyWith(assistantName: value);
                      });
                    }, onDescriptionChanged: (String value) {
                      setState(() {
                        _botData = _botData.copyWith(description: value.toLowerCase());
                      });
                    }, onInstructionChanged: (String value) {
                      _botData = _botData.copyWith(instructions: value.toLowerCase());
                    },
                      bot: widget.oldBot,
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
                            if (_botData.assistantName.isEmpty
                                || _botData.description!.isEmpty
                                || _botData.instructions!.isEmpty
                            ) return;
                            setState(() {
                              _isAdding = true;
                            });
                            try {

                              await widget.onUpdateBot(_botData);
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
