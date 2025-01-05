import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/horizontal_spacing.dart';
import '../../../../shared/styles/varela_round_style.dart';
import '../../../../shared/styles/vertical_spacing.dart';

class RemoveKbDialog extends StatefulWidget {
  const RemoveKbDialog({
    super.key, required this.deleteIndex, required this.index,
  });

  final Function(int) deleteIndex;
  final int index;

  @override
  State<RemoveKbDialog> createState() => _RemoveKbDialogState();
}

class _RemoveKbDialogState extends State<RemoveKbDialog> {
  var _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TColor.doctorWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Delete", style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: TColor.poppySurprise,
                    fontSize: 25
                ),
                ),

                CloseButton(
                  onPressed: Navigator.of(context).pop,
                )
              ],
            ),
            VSpacing.md,
            Text("Are you sure you want to remove this knowledge bases from current assistant?",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: TColor.squidInk,
              fontSize: 14,
            ),
            ),
            VSpacing.md,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    splashColor: TColor.tamarama.withOpacity(0.2),
                    onTap: () => Navigator.of(context).pop(),
                    child: AnimatedContainer(
                      curve: Curves.decelerate,
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: TColor.petRock,
                            width: 2,
                          )),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        'Cancel',
                        style: VarelaRoundStyle.basicW600.copyWith(
                          color: TColor.petRock,
                        ),
                      ),
                    ),
                  ),
                ),
                HSpacing.sm,
                Material(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: TColor.tamarama.withOpacity(0.2),
                    onTap: _isDeleting ? () {} : ()  async {
                      setState(() {
                        _isDeleting = true;
                      });
                      await widget.deleteIndex(widget.index);
                      setState(() {
                        _isDeleting = false;
                      });
                      Navigator.of(context).pop();
                    },
                    child: AnimatedContainer(
                      curve: Curves.decelerate,
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                          color: TColor.poppySurprise,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: TColor.poppySurprise,
                            width: 2,
                          )),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: _isDeleting ? Row(
                        children: [
                          LoadingAnimationWidget.discreteCircle(color: TColor.doctorWhite, size: 12),
                          HSpacing.sm,
                          Text(
                            'Delete',
                            style: VarelaRoundStyle.basicW600.copyWith(
                              color: TColor.doctorWhite,
                            ),
                          )
                        ],
                      ) : Text(
                        'Delete',
                        style: VarelaRoundStyle.basicW600.copyWith(
                          color: TColor.doctorWhite,
                        ),
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
