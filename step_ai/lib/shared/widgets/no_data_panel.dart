import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoDataPannel extends StatelessWidget {
  final String contentNoData;
  const NoDataPannel({super.key, required this.contentNoData});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Image(
          image: AssetImage('lib/core/assets/imgs/file.png'),
          width: 300,
        ),
        Text(
          "No data",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(contentNoData, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
