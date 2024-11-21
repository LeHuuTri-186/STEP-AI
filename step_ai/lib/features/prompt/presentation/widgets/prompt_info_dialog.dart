import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:step_ai/features/prompt/data/models/prompt_model.dart';
import 'package:step_ai/features/prompt/presentation/widgets/copy_with_tooltip.dart';
import 'package:step_ai/shared/styles/horizontal_spacing.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/varela_round_style.dart';
import '../../../../shared/styles/vertical_spacing.dart';

class PromptDialog extends StatefulWidget {
  final PromptModel prompt;
  final VoidCallback onUsePrompt;
  final VoidCallback setFavorite;

  const PromptDialog({
    Key? key,
    required this.onUsePrompt,
    required this.prompt, required this.setFavorite,
  }) : super(key: key);

  @override
  State<PromptDialog> createState() => _PromptDialogState();
}

class _PromptDialogState extends State<PromptDialog> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.prompt.isFavorite;
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
                    widget.prompt.title,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 20,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    _isFavorite ? IconButton(
                      icon: Icon(Icons.star_rounded,
                      color: TColor.goldenState),
                      onPressed: () {
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });

                        widget.setFavorite();
                      },
                    ) : IconButton(
                      icon: Icon(Icons.star_border_rounded,
                          color: TColor.petRock),
                      onPressed: () {
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });

                        widget.setFavorite();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ],
            ),
            VSpacing.sm,
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
                        text: widget.prompt.category,
                      ),
                      const TextSpan(text: ' · '),
                      TextSpan(
                        text: widget.prompt.userName,
                      ),
                    ]),
              ),
            ),
            VSpacing.md,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.prompt.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: TColor.petRock,
                    ),
              ),
            ),
            VSpacing.md,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Prompt',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 18,
                      ),
                ),

                CopyWithTooltip(textToCopy: widget.prompt.content),
              ],
            ),
            VSpacing.sm,
            Container(
              width: 400,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: TColor.northEastSnow,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.prompt.content,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: TColor.squidInk,
                          fontSize: 14,
                        ),
                  ),
                ),
              ),
            ),
            VSpacing.sm,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
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
                      )
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Cancel',
                      style: VarelaRoundStyle.basicW600.copyWith(
                        color: TColor.squidInk,
                      ),
                    ),
                  ),
                ),
                HSpacing.sm,
                GestureDetector(
                  onTap: widget.onUsePrompt,
                  child: AnimatedContainer(
                    curve: Curves.decelerate,
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                        color: TColor.tamarama,
                        borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Use this prompt',
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
    );
  }
}
