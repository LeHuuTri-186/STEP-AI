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
        Image(
          image: AssetImage('lib/core/assets/imgs/file.png'),
          width: 100,
        ),
        Text(
          "No data",
          style: GoogleFonts.jetBrainsMono(
              fontSize: MediaQuery.of(context).size.width * 0.05,
              fontWeight: FontWeight.w800),
        ),
        Text(contentNoData, style: GoogleFonts.jetBrainsMono(
            fontSize: MediaQuery.of(context).size.width * 0.035,
            color: Colors.black54,
            fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
