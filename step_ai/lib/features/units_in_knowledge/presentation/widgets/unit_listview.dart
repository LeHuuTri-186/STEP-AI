import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/unit_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/widgets/unit_item.dart';
import 'package:step_ai/shared/styles/colors.dart';
import 'package:step_ai/shared/widgets/no_data_panel.dart';

class UnitListview extends StatefulWidget {
  UnitListview({super.key});

  @override
  State<UnitListview> createState() => _UnitListviewState();
}

class _UnitListviewState extends State<UnitListview> {
  late UnitNotifier _unitNotifier;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _unitNotifier = Provider.of<UnitNotifier>(context, listen: false);
      if (_unitNotifier.isLoading == false) {
        _unitNotifier.getUnitList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _unitNotifier = Provider.of<UnitNotifier>(context, listen: false);

    //Loading
    if (_unitNotifier.isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: LoadingAnimationWidget.twistingDots(
            size: 50,
            leftDotColor: TColor.tamarama,
            rightDotColor: TColor.daJuice,
          ),
        ),
      );
    }
    if (_unitNotifier.errorString.isNotEmpty ||
        _unitNotifier.unitList == null) {
      return const Center(child: Text("Have error. Try again later"));
    }
    if (_unitNotifier.unitList!.units.isEmpty) {
      return const NoDataPannel(
        contentNoData: "Create a unit in your knowledge",
      );
    }
    return ListView.separated(
      itemCount: _unitNotifier.unitList!.units.length,
      separatorBuilder: (context, index) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Divider(),
      ),
      itemBuilder: (context, index) {
        return UnitItem(unit: _unitNotifier.unitList!.units[index]);
      },
    );
  }
}
