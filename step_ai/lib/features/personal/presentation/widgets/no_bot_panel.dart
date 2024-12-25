import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_ai/shared/styles/vertical_spacing.dart';

class NoBotPanel extends StatelessWidget {
  const NoBotPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Image(
        image: AssetImage('lib/core/assets/imgs/empty-box.png'),
        width: 300,
      ),
      VSpacing.md,
      SizedBox(
        width: 300,
        child: Center(
          child: Text(
            "No bots found",
            style: Theme.of(context).textTheme.titleMedium,),
        )),
        Text("Build a bot first", style: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: Colors.black54,
          fontWeight: FontWeight.w500),
          )
            ,],
        );
  }
}
