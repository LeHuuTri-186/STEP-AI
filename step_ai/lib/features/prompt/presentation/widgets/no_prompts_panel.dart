import 'package:flutter/material.dart';
import 'package:step_ai/features/prompt/presentation/widgets/private_prompt_footer.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/horizontal_spacing.dart';
import '../../../../shared/styles/vertical_spacing.dart';

class NoPromptPanel extends StatelessWidget {
  const NoPromptPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const IntrinsicHeight(
            child: Image(
              image: AssetImage('lib/core/assets/imgs/searching.png'),
              height: 250,
              width: 250,
            ),
          ),
          VSpacing.md,
          Text("No prompt(s) found", style: Theme.of(context).textTheme.titleMedium,),
        ],
      ),
    );
  }
}