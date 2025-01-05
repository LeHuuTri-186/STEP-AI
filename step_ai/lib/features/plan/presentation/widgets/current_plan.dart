import 'package:flutter/material.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/horizontal_spacing.dart';
import '../../../../shared/styles/vertical_spacing.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../domain/entity/plan.dart';

class CurrentPlan extends StatelessWidget {
  final Plan _plan;
  const CurrentPlan({super.key, required Plan plan}) : _plan = plan ;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
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
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child: Column(
          children: [
            VSpacing.sm,
            GradientText(
              "Current Plan: ${_plan.name}",
              style: Theme.of(context).textTheme.titleLarge, gradient: LinearGradient(colors: [TColor.finePine, TColor.daJuice]),
            ),
            VSpacing.md,
            Text(
              "Daily Tokens: ${_plan.dailyTokens}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            VSpacing.sm,
            Text(
              "Monthly Tokens: ${_plan.monthlyTokens}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            VSpacing.sm,
            Text(
              "Annually Tokens: ${_plan.annuallyTokens}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            VSpacing.sm,
          ],
        ),
      ),
    );
  }
}