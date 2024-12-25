import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/core/di/service_locator.dart';
import 'package:step_ai/features/knowledge_base/notifier/knowledge_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/cupertino_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/unit_notifier.dart';

import '../../domain/entity/unit.dart';

class CustomCupertino extends StatelessWidget {
  final Unit unit;
  late UnitNotifier unitNotifier;
  late KnowledgeNotifier knowledgeNotifier;
  CustomCupertino({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    unitNotifier = Provider.of<UnitNotifier>(context, listen: false);
    knowledgeNotifier = Provider.of<KnowledgeNotifier>(context, listen: false);
    return ChangeNotifierProvider(
      create: (context) {
        final notifier = getIt<CupertinoNotifier>();
        notifier.initialize(unit.status);
        return notifier;
      },
      child: Consumer<CupertinoNotifier>(
        builder: (context, cupertinoNotifier, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: cupertinoNotifier.isLoading ? 0.5 : 1.0,
                child: CupertinoSwitch(
                  activeColor: Colors.blue,
                  value: cupertinoNotifier.switchValue,
                  onChanged: cupertinoNotifier.isLoading
                      ? null
                      : (value) async {
                          try {
                            cupertinoNotifier.changeIsLoading(true);
                            unitNotifier.incrementCupertinoSwitch();

                            await unitNotifier.updateStatusUnit(unit.id, value);
                            await knowledgeNotifier.getKnowledgeList();

                            cupertinoNotifier.changeSwitchValue(value);
                            cupertinoNotifier.changeIsLoading(false);
                            unitNotifier.decrementCupertinoSwitch();
                          } catch (e) {
                            cupertinoNotifier.changeIsLoading(false);
                            unitNotifier.decrementCupertinoSwitch();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.toString(),
                                ),
                              ),
                            );
                          }
                        },
                ),
              ),
              if (cupertinoNotifier.isLoading)
                const Positioned(
                  child: CupertinoActivityIndicator(
                    radius: 10,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
