import 'package:flutter/material.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/varela_round_style.dart';

class ButtonsPair extends StatelessWidget {
  const ButtonsPair({super.key, required this.isFirstSelected, required this.firstOnTap, required this.secondOnTap, required this.firstButtonText, required this.secondButtonText, this.borderRadius = 30, this.mainAxisSize = MainAxisSize.min});
  final bool isFirstSelected;
  final Function() firstOnTap;
  final Function() secondOnTap;
  final String firstButtonText;
  final String secondButtonText;
  final double borderRadius;
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TColor.grahamHair, //Background color for the container
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: _buildButtonPair(),
    );
  }

  Widget _buildButtonPair() {
    return Row(
      mainAxisSize: mainAxisSize,
      children: [
        // My Prompts Button
        Expanded(
          child: GestureDetector(
            onTap: firstOnTap,
            child: AnimatedContainer(
              curve: Curves.decelerate,
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: isFirstSelected ? TColor.tamarama : Colors.transparent,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Center(
                child: Text(
                  firstButtonText,
                  style: VarelaRoundStyle.basicW600.copyWith(
                    color: isFirstSelected ? TColor.doctorWhite : TColor.squidInk,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Public Prompts Button
        Expanded(
          child: GestureDetector(
            onTap: secondOnTap,
            child: AnimatedContainer(
              curve: Curves.decelerate,
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: !isFirstSelected ? TColor.tamarama : Colors.transparent,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Center(
                child: Text(
                  secondButtonText,
                  style: VarelaRoundStyle.basicW600.copyWith(
                    color: !isFirstSelected ? TColor.doctorWhite : TColor.squidInk,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
