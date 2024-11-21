import 'package:flutter/material.dart';
import 'package:step_ai/features/prompt/data/models/prompt_model.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/horizontal_spacing.dart';
import '../../../../shared/styles/vertical_spacing.dart';

class PrivatePromptTile extends StatelessWidget {
  const PrivatePromptTile({
    super.key,
    required this.prompt,
    required this.index,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final PromptModel prompt;
  final int index;
  final Function() onTap;
  final Function() onEdit;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onHover: (_) {},
        borderRadius: BorderRadius.circular(10),
        hoverColor: TColor.grahamHair,
        child: Ink(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: _buildDataColumn(context),
                ),
                Flexible(
                  flex: 1,
                  child: _buildActionRow(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataColumn(BuildContext context) {
    return Text(
      prompt.title,
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
        fontSize: 14,
      ),
    );
  }

  Row _buildActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [

        InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(5.0),
          hoverColor: TColor.northEastSnow,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Icon(Icons.mode_edit_outlined, color: TColor.petRock.withOpacity(0.8),),
          ),
        ),
        HSpacing.sm,
        InkWell(
          onTap: onDelete,
          borderRadius: BorderRadius.circular(5.0),
          hoverColor: TColor.northEastSnow,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Icon(Icons.delete_outline_rounded, color: TColor.petRock.withOpacity(0.8)),
          ),
        ),
      ],
    );
  }
}
