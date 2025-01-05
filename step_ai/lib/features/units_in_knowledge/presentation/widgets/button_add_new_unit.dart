import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/core/di/service_locator.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/unit_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/widgets/add_option_unit_dialog.dart';

import '../../../../shared/styles/colors.dart';

class ButtonAddNewUnit extends StatelessWidget {
  late UnitNotifier _unitNotifier;
  ButtonAddNewUnit({super.key});
  void showAddUnitOptions(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AddOptionUnitDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    _unitNotifier = Provider.of<UnitNotifier>(context, listen: true);
    return Container(
      margin: const EdgeInsets.only(right: 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: TColor.tamarama,
      ),
      child: TextButton(
        onPressed: _unitNotifier.numberLoadingItemSwitchCounter != 0
            ? null
            : () => showAddUnitOptions(context),
        child: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FittedBox(
                child: Text(
                  "+ Add unit",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: TColor.doctorWhite
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
