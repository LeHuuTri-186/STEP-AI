import 'package:flutter/material.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/horizontal_spacing.dart';
import '../../../../shared/styles/vertical_spacing.dart';
import '../../../../shared/usecases/pricing_redirect_service.dart';

class ProPlan extends StatelessWidget {
  final bool isSelected;

  const ProPlan({super.key, this.isSelected = false});

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
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: TColor.petRock.withOpacity(0.5)),
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
                  )),
            Column(
              children: [
                VSpacing.sm,
                Text("Pro Annually",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    )),
                VSpacing.sm,
                Text("1-month Free Trial",
                    style: Theme.of(context).textTheme.titleSmall),
                const Text("then"),
                VSpacing.sm,
                Text.rich(
                  TextSpan(
                    text: "\$79.99",
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                          text: "/year",
                          style: Theme.of(context).textTheme.titleSmall)
                    ],
                  ),
                ),
                VSpacing.sm,
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async => await PricingRedirectService.call(),
                    borderRadius: BorderRadius.circular(4),
                    child: Ink(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: TColor.goldenState,
                          gradient: LinearGradient(
                              colors: [TColor.goldenState, Colors.deepOrange])),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 50),
                        child: Text(
                          isSelected ? "Unsubscribe" : "Choose Plan",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                              fontSize: 20,
                              color: TColor.doctorWhite,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                ),
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
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: TColor.finePine,
                    ),
                    HSpacing.sm,
                    Text("No ads",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                Divider(
                  color: TColor.petRock.withOpacity(0.5),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("More queries per year",
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
                    Text("Unlimited queries per year",
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
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("Jira Copilot Assistant",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("Github Copilot Assistant",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Text.rich(
                  TextSpan(
                    text: "Maximize productivity with ",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: TColor.petRock.withOpacity(0.8)),
                    children: [
                      TextSpan(
                          text: "unlimited*",
                          style:
                          Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w700,
                          )),
                      const TextSpan(text: " queries"),
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
                    Text("No request limits during high-traffic",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("2X faster response speed",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("Priority email support",
                        style: Theme.of(context).textTheme.titleSmall),
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