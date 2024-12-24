import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/constants.dart';
import 'package:step_ai/config/routes/routes.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/add_option_unit_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/pages/local_file_page.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/widgets/option_unit_item.dart';

class AddOptionUnitDialog extends StatelessWidget {
  AddOptionUnitDialog({super.key});
  late AddOptionUnitNotifier addOptionUnitNotifier;
  String goToDetailAddUnitPage(BuildContext context) {
    String selectedOption = addOptionUnitNotifier.selectedOption;
    if (selectedOption == "web") {
      return Routes.webPage;
    }
    if (selectedOption == "confluence") {
      return Routes.confluencePage;
    }
    if (selectedOption == "drive") {
      return Routes.drivePage;
    }
    if (selectedOption == "slack") {
      return Routes.slackPage;
    }
    return Routes.localFilePage;
  }

  @override
  Widget build(BuildContext context) {
    addOptionUnitNotifier =
        Provider.of<AddOptionUnitNotifier>(context, listen: false);
    return AlertDialog(
      backgroundColor: Colors.white,
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
                      title: "Drive",
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      addOptionUnitNotifier.setSelectedOption("local_file");
                      Navigator.of(context).pop();
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      //print("Selected option:");
                      //Pop up the dialog

                      Navigator.of(context).pop();

                      Navigator.of(context)
                          .pushNamed(goToDetailAddUnitPage(context));
                      addOptionUnitNotifier.setSelectedOption("local_file");
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text("Continue",
                        style: TextStyle(color: Colors.white)),
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
