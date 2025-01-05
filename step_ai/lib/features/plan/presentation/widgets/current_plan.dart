import 'package:flutter/material.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/horizontal_spacing.dart';
import '../../../../shared/styles/vertical_spacing.dart';
import '../../domain/entity/plan.dart';

class CurrentPlan extends StatelessWidget {
  final Plan _plan;
  const CurrentPlan({super.key, required Plan plan}) : _plan = plan ;

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
        child: Column(
          children: [
            VSpacing.sm,
            Text(
              _plan.name,
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
      ),
    );
  }
}