import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/routes/routes.dart';
import 'package:step_ai/features/chat/domain/entity/assistant.dart';
import 'package:step_ai/features/chat/notifier/assistant_notifier.dart';
import 'package:step_ai/features/chat/notifier/personal_assistant_notifier.dart';
import 'package:step_ai/features/personal/presentation/pages/playground_page.dart';
import 'package:step_ai/shared/styles/horizontal_spacing.dart';

import '../styles/colors.dart';

class DropdownAI extends StatefulWidget {
  const DropdownAI({super.key});

  @override
  State<DropdownAI> createState() => _DropdownAIState();
}

class _DropdownAIState extends State<DropdownAI> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final _assistantNotifier = Provider.of<AssistantNotifier>(context, listen: true);
    final personalAssistantNotifier = context.watch<PersonalAssistantNotifier>();
    return Center(
      child: PopupMenuButton(
        onOpened: () => setState(() {
          FocusScope.of(context).unfocus();
          _isExpanded = true;
        }),
        onCanceled: () => setState(() {
          FocusScope.of(context).unfocus();
          _isExpanded = false;
        }),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        popUpAnimationStyle: AnimationStyle(duration: const Duration()),
        color: TColor.doctorWhite,
        position: PopupMenuPosition.over,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        itemBuilder: (context) {
          return [
            // Custom header with a button
            PopupMenuItem(
              enabled: false, // Disable selection for the header
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.of(context).pushNamed(Routes.personal);
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: TColor.tamarama,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: TColor.doctorWhite,
                                  ),
                                  HSpacing.sm,
                                  Text(
                                    "Create Assistant",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: TColor.doctorWhite,
                                          fontSize: 12,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //Add personal assistants picked.
                  Consumer<PersonalAssistantNotifier>(
                    builder: (context, personalAssistantNotifier, child) {
                      return Wrap(
                        children: personalAssistantNotifier.personalAssistants
                            .map((model) {
                          return PopupMenuItem(
                            value: model,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Text và IconButton
                                Text(
                                  model!.name!,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: TColor.petRock,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                HSpacing.md,
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    personalAssistantNotifier.removeAssistant(
                                        model);
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const Divider(),
                  Text(
                    "Base model",
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: TColor.petRock.withOpacity(0.6),
                      fontSize: 15,
                    ),
                  ), // Add a divider to separate the header
                ],
              ),
            ),
            ..._assistantNotifier.assistants.map((model) {
              return PopupMenuItem(
                value: model,
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: TColor.slate.withOpacity(0.9),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(model.logoPath!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    HSpacing.md,
                    Text(
                      model.name!,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TColor.petRock,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ];
        },
        onSelected: (value) {
          if ((value as Assistant).model == 'personal') {
            personalAssistantNotifier.setCurrentAssistantId(value.id!);
            personalAssistantNotifier.changePersonalCheck(true);
          }
          else {
            _assistantNotifier.setCurrentAssistantId(value.id!);
            personalAssistantNotifier.changePersonalCheck(false);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: TColor.northEastSnow,
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 0.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Selector<PersonalAssistantNotifier, bool>(
                selector: (context, notifier) => notifier.isPersonal,
                  builder: (context, isPersonal, child) {
                    return isPersonal ? const SizedBox.shrink() : Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: TColor.slate.withOpacity(0.9),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(_assistantNotifier.currentAssistant.logoPath!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
              HSpacing.sm,
              Selector<PersonalAssistantNotifier, bool>(
                  selector: (context, notifier) => notifier.isPersonal,
                  builder: (context, isPersonal, child) {
                    return isPersonal ?
                        //Personal bots
                    Text(
                      personalAssistantNotifier.currentAssistant!.name!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TColor.petRock,
                      ),
                    ) :
                       //Given models
                    Text(
                      _assistantNotifier.currentAssistant.name!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TColor.petRock,
                      ),
                    );
                  }),
              Icon(
                _isExpanded
                    ? Icons.arrow_drop_up_rounded
                    : Icons.arrow_drop_down_rounded,
                size: 24,
                color: TColor.petRock,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
