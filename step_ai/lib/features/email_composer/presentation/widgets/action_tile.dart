import 'package:flutter/material.dart';

import '../../../../shared/styles/colors.dart';

class ActionTile extends StatelessWidget {
  const ActionTile({super.key, required this.action, this.onTap});
  final String action;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: TColor.northEastSnow.withOpacity(0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      action,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: TColor.petRock,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_circle_right_outlined,
                    color: TColor.petRock,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    ;
  }
}
