import 'package:flutter/material.dart';
import 'package:step_ai/config/constants.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/widgets/option_unit_item.dart';

class AddOptionUnitDialog extends StatelessWidget {
  AddOptionUnitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    OptionUnitItem(
                      imagePath: Constant.localFileImagePath,
                      title: "Local files",
                      subtitle: "Upload pdf, docx, ...",
                      value: "local_file",
                    ),
                    OptionUnitItem(
                      imagePath: Constant.webImagePath,
                      title: "Website",
                      subtitle: "Connect Website to get data",
                      value: "web",
                    ),
                    OptionUnitItem(
                      imagePath: Constant.confluenceImagePath,
                      title: "Confluence",
                      subtitle: "Connect Confluence to get data",
                      value: "confluence",
                    ),
                    OptionUnitItem(
                      imagePath: Constant.driveImagePath,
                      title: "Google drive",
                      subtitle: "Connect Google drive to get data",
                      value: "drive",
                    ),
                    OptionUnitItem(
                      imagePath: Constant.slackImagePath,
                      title: "Slack",
                      subtitle: "Connect Slack to get data",
                      value: "slack",
                    ),
                  ],
                ),
              ),
            ),
            //Button Cancel and Next
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                  ),
                ),
              
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      print("Selected option:");
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text("Continue", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
