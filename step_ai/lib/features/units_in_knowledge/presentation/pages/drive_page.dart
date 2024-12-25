import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/constants.dart';
import 'package:step_ai/features/knowledge_base/notifier/knowledge_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/drive_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/unit_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

class DrivePage extends StatelessWidget {
  DrivePage({super.key});
  late DriveNotifier driveNotifier;
  late KnowledgeNotifier knowledgeNotifier;
  late UnitNotifier unitNotifier;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void findAndUpdateCurrentKnowledge() {
    //to update size and numbers units when add unit
    knowledgeNotifier.knowledgeList!.knowledgeList.forEach((knowledge) {
      if (knowledge.id == unitNotifier.currentKnowledge!.id) {
        unitNotifier.updateCurrentKnowledge(knowledge);
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    driveNotifier = Provider.of<DriveNotifier>(context, listen: true);
    knowledgeNotifier = Provider.of<KnowledgeNotifier>(context, listen: false);
    unitNotifier = Provider.of<UnitNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drive'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: driveNotifier.isUploadLoading
              ? null
              : () {
                  Navigator.pop(context);
                },
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.45,
          decoration: BoxDecoration(
            color: Colors.lightBlue[100],
            borderRadius: BorderRadius.circular(10),
          ),
          //Main Column
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Title of the page + Image
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Image.asset(Constant.driveImagePath,
                          width: 50, height: 50),
                      const SizedBox(width: 10),
                      const Text('Drive'),
                    ],
                  ),
                  IconButton(
                      onPressed: () async {
                        final Uri url = Uri.parse(
                            'https://jarvis.cx/help/knowledge-base/connectors/google-drive');
                        try {
                          if (!await canLaunchUrl(url)) {
                            throw 'URL không hợp lệ hoặc không thể mở: $url';
                          }

                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        } catch (e) {
                          // Xử lý lỗi, có thể hiển thị thông báo cho người dùng
                          print('Lỗi khi mở URL: $e');
                        }
                      },
                      icon: const Icon(
                        Icons.link,
                        color: Colors.blue,
                        size: 30,
                      ))
                ],
              ),
              const SizedBox(height: 4),
              const Divider(),
              const SizedBox(height: 20),
              //TextFormField for  name unit
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      driveNotifier.setUnitName(value);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    style: BorderStyle.solid,
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Constant.driveImagePath,
                            width: 30, height: 30),
                        const SizedBox(width: 10),
                        const Text("Upload Drive",
                            style: TextStyle(color: Colors.blue)),
                      ],
                    )),
              ),
              const SizedBox(height: 30),
              //TextFormField for Slack Workspace
              //Button to connect
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  disabledBackgroundColor:
                      const Color.fromARGB(255, 173, 205, 221),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: (driveNotifier.isUploadLoading)
                    ? null
                    : () async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        //show indicator
                        driveNotifier.setUploadLoading(true);
                        //try catch if web not valid
                        try {
                          await unitNotifier.uploadDrive();
                          await knowledgeNotifier.getKnowledgeList();
                          await unitNotifier.getUnitList();
                          findAndUpdateCurrentKnowledge();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                            ),
                          );
                          //hide indicator
                          driveNotifier.setUploadLoading(false);
                          return;
                        }

                        //hide indicator
                        driveNotifier.setUploadLoading(false);
                        Navigator.pop(context);
                      },
                child: (driveNotifier.isUploadLoading)
                    ? const Stack(alignment: Alignment.center, children: [
                        Text("Uploading..."),
                        Positioned(
                          child: CupertinoActivityIndicator(
                            radius: 10,
                            color: Colors.blue,
                          ),
                        ),
                      ])
                    : const Text('Connect',
                        style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
