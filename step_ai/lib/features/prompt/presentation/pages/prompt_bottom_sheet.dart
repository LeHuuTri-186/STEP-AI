import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_ai/features/prompt/presentation/pages/private_prompts.dart';
import 'package:step_ai/shared/styles/a_bee_zee_style.dart';
import 'package:step_ai/shared/styles/colors.dart';
import 'package:step_ai/shared/styles/varela_round_style.dart';

class PromptBottomSheet extends StatefulWidget {
  const PromptBottomSheet({super.key});

  @override
  State<PromptBottomSheet> createState() => _PromptBottomSheetState();
}

class _PromptBottomSheetState extends State<PromptBottomSheet> {
  bool _isPrivate = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Prompt Library"),
            titleTextStyle: Theme.of(context).textTheme.titleLarge,
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.add_outlined,
                ),
              ),
              const CloseButton(),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color:
                        TColor.grahamHair, //Background color for the container
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // My Prompts Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPrivate = true;
                          });
                        },
                        child: AnimatedContainer(
                          curve: Curves.decelerate,
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color:
                                _isPrivate ? TColor.mcFanning : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            'My Prompts',
                            style: VarelaRoundStyle.basicW600.copyWith(
                              color: _isPrivate ? TColor.doctorWhite : TColor.squidInk,
                            ),
                          ),
                        ),
                      ),

                      // Public Prompts Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPrivate = false;
                          });
                        },
                        child: AnimatedContainer(
                          curve: Curves.decelerate,
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color:
                                !_isPrivate ? TColor.mcFanning : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            'Public Prompts',
                            style: VarelaRoundStyle.basicW600.copyWith(
                              color: !_isPrivate ? TColor.doctorWhite : TColor.squidInk,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child:
                      _isPrivate ? const PrivatePromptsPanel() : Placeholder(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
