import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/core/di/service_locator.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/unit_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/widgets/add_option_unit_dialog.dart';

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
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.only(right: 6),
      padding: EdgeInsets.zero,
      child: Container(
        margin: const EdgeInsets.only(right: 2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blueAccent,
        ),
        child: TextButton(
          onPressed: _unitNotifier.numberLoadingItemSwitchCounter != 0
              ? null
              : () => showAddUnitOptions(context),
          child: SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.add_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                Text(
                  "Add unit",
                  style: GoogleFonts.jetBrainsMono(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
