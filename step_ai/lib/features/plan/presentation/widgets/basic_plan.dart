import 'package:flutter/material.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/horizontal_spacing.dart';
import '../../../../shared/styles/vertical_spacing.dart';

class BasicPlan extends StatelessWidget {
  final bool isSelected;

  const BasicPlan({super.key, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 910,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              offset: const Offset(-3, 3),
              color: TColor.slate.withOpacity(0.5),
              blurRadius: 5.0)
        ],
        color: TColor.doctorWhite,
        border: Border.all(color: TColor.petRock.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: Stack(
          children: [
            if (isSelected)
              Positioned(
                right: 0,
                child: Transform.translate(
                  offset: const Offset(17, -5),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: TColor.finePine, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Text("Current plan",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                              color: TColor.finePine,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.italic,
                            )),
                      )),
                ),
              ),
            Column(
              children: [
                VSpacing.sm,
                Text(
                  "Basic",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                VSpacing.sm,
                const Text(""),
                VSpacing.sm,
                Text("Free", style: Theme.of(context).textTheme.titleMedium),
                VSpacing.sm,
                const Text(""),
                VSpacing.sm,
                const Text(""),
                VSpacing.sm,
                Divider(
                  color: TColor.petRock.withOpacity(0.5),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Basic features",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                VSpacing.sm,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("AI Models",
                            style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(
                            width: 250,
                            child: Text(
                              "GPT-3.5 & GPT-4.0/Turbo & Gemini Pro & Gemini Ultra",
                              maxLines: 3,
                            )),
                      ],
                    ),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("AI Action Injection",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("Select Text for AI Action",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Text("", style: Theme.of(context).textTheme.titleSmall),
                Divider(
                  color: TColor.petRock.withOpacity(0.5),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Limited queries per day",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: TColor.finePine,
                    ),
                    HSpacing.sm,
                    Text("50 free queries per day",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                Divider(
                  color: TColor.petRock.withOpacity(0.5),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Advanced features",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("AI Reading Assistant",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("Real-time Web Access",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("AI Writing Assistant",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Text("", style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Text("", style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Text.rich(
                  TextSpan(
                    text: "",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: TColor.petRock.withOpacity(0.8)),
                    children: [
                      TextSpan(
                          text: "",
                          style:
                          Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w700,
                          )),
                      const TextSpan(text: ""),
                    ],
                  ),
                ),
                Divider(
                  color: TColor.petRock.withOpacity(0.5),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Other benefits",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    SizedBox(
                      width: 270,
                      child: Text("Lower response speed during high-traffic",
                          maxLines: 2,
                          style: Theme.of(context).textTheme.titleSmall),
                    ),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Text("", style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Text("", style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
              ],
            ),
          ],
        ),
      ),
    );
  }
}