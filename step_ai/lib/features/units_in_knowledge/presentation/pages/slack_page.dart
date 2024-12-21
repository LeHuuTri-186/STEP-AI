import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/constants.dart';
import 'package:step_ai/features/knowledge_base/notifier/knowledge_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/slack_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/unit_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

class SlackPage extends StatelessWidget {
  SlackPage({super.key});
  late SlackNotifier slackNotifier;
  late KnowledgeNotifier knowledgeNotifier;
  late UnitNotifier unitNotifier;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
    slackNotifier = Provider.of<SlackNotifier>(context, listen: true);
    knowledgeNotifier = Provider.of<KnowledgeNotifier>(context, listen: false);
    unitNotifier = Provider.of<UnitNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slack'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: slackNotifier.isUploadLoading
              ? null
              : () {
                  Navigator.pop(context);
                },
        ),
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              color: Colors.grey[300],
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
                        Image.asset(Constant.slackImagePath,
                            width: 50, height: 50),
                        const SizedBox(width: 10),
                        const Text('Slack'),
                      ],
                    ),
                    IconButton(
                        onPressed: () async {
                          final Uri url = Uri.parse(
                              'https://jarvis.cx/help/knowledge-base/connectors/slack/');
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
                        ))
                  ],
                ),
                const SizedBox(height: 4),
                const Divider(),
                const SizedBox(height: 10),
                //TextFormField for  name unit
                Padding(
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
                      slackNotifier.setUnitName(value);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                //TextFormField for Slack Workspace
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      labelText: 'Slack Workspace',
                      hintText: 'Enter Workspace',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Slack Workspace';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      slackNotifier.setSlackWorkspace(value);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                //TextFormField for Slack Bot Token
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      labelText: 'Slack Bot Token',
                      hintText: 'Enter Bot Token',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Slack Bot Token';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      slackNotifier.setSlackBotToken(value);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                //Button to connect
                ElevatedButton(
                  onPressed: (slackNotifier.isUploadLoading)
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          //show indicator
                          slackNotifier.setUploadLoading(true);
                          //try catch if web not valid
                          try {
                            await unitNotifier.uploadSlack(
                                slackNotifier.unitName,
                                slackNotifier.slackWorkspace,
                                slackNotifier.slackBotToken);
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
                            slackNotifier.setUploadLoading(false);
                            return;
                          }

                          //hide indicator
                          slackNotifier.setUploadLoading(false);
                          Navigator.pop(context);
                        },
                  child: (slackNotifier.isUploadLoading)
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
      ),
    );
  }
}
