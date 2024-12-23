import 'package:flutter/material.dart';
import 'package:step_ai/features/personal/data/models/bot_res_dto.dart';
import 'package:step_ai/shared/styles/horizontal_spacing.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/vertical_spacing.dart';

class BotTile extends StatelessWidget {
  const BotTile({
    super.key,
    required this.bot,
    required this.index,
    required this.onTap,
    required this.onToggleDelete,
    required this.onToggleUpdate,
    required this.onToggleAddBot,
  });

  final BotResDto bot;
  final int index;
  final Function() onTap;
  final Function() onToggleDelete;
  final Function() onToggleUpdate;
  final Function() onToggleAddBot;


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onHover: (_) {

        },
        borderRadius: BorderRadius.circular(10),
        hoverColor: TColor.grahamHair,
        child: Ink(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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

  Column _buildDataColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          bot.assistantName,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: 16,
          ),
        ),
        VSpacing.md,
        Text(
          "Description: ${bot.description!}",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
      ],
    );
  }

  Row _buildActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: onToggleDelete,
          borderRadius: BorderRadius.circular(5.0),
          hoverColor: TColor.northEastSnow,
          child: const Padding(
            padding: EdgeInsets.all(3.0),
            child: Icon(Icons.delete_rounded),
          ),
        ),
        HSpacing.sm,
        InkWell(
          onTap: onToggleUpdate,
          borderRadius: BorderRadius.circular(5.0),
          hoverColor: TColor.northEastSnow,
          child: const Padding(
            padding: EdgeInsets.all(3.0),
            child: Icon(Icons.update_outlined),
          ),
        ),
        HSpacing.sm,
        InkWell(
          onTap: onToggleAddBot,
          borderRadius: BorderRadius.circular(5.0),
          hoverColor: TColor.northEastSnow,
          child: const Padding(
            padding: EdgeInsets.all(3.0),
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
