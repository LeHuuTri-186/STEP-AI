import 'package:flutter/material.dart';

import '../styles/colors.dart';

void showErrorDialog(BuildContext context, String error) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: TColor.doctorWhite,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Oops!",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            CloseButton(
              onPressed: Navigator.of(context).pop,
            )
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(error,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: TColor.petRock,
                fontWeight: FontWeight.w700,
              )),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Got it",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: TColor.poppySurprise,
              ),
            ),
          ),
        ],
      );
    },
  );
}