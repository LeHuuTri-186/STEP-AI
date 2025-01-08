import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:step_ai/features/preview/domain/entity/kb_in_bot.dart';
import 'package:step_ai/features/prompt/data/models/prompt_model.dart';
import 'package:step_ai/shared/styles/horizontal_spacing.dart';

import '../../../../shared/styles/colors.dart';

class KbTile extends StatelessWidget {
  const KbTile({
    super.key,
    required this.kb,
    required this.index,
    required this.onDelete,
  });

  final KbInBot kb;
  final int index;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
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
    return Row(
      children: [
        const Icon(FontAwesomeIcons.server),
        HSpacing.lg,
        Text(
          kb.knowledgeName,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Row _buildActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: onDelete,
          borderRadius: BorderRadius.circular(5.0),
          hoverColor: TColor.northEastSnow,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Icon(Icons.delete, color: TColor.petRock.withOpacity(0.8)),
          ),
        ),
      ],
    );
  }
}
