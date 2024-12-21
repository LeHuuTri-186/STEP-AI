import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/constants.dart';
import 'package:step_ai/features/knowledge_base/notifier/knowledge_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/unit_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/web_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

class WebPage extends StatelessWidget {
  WebPage({super.key});
  late WebNotifier webNotifier;
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
    webNotifier = Provider.of<WebNotifier>(context, listen: true);
    knowledgeNotifier = Provider.of<KnowledgeNotifier>(context, listen: false);
    unitNotifier = Provider.of<UnitNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Website'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: webNotifier.isUploadLoading
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
            height: MediaQuery.of(context).size.height * 0.45,
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
                        Image.asset(Constant.webImagePath,
                            width: 50, height: 50),
                        const SizedBox(width: 10),
                        const Text('Website'),
                      ],
                    ),
                    IconButton(
                        onPressed: () async {
                          final Uri url = Uri.parse(
                              'https://jarvis.cx/help/knowledge-base/connectors/');
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
                      webNotifier.setNameUnit(value);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                //TextFormField for URL
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      labelText: 'URL',
                      hintText: 'Enter URL',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter URL';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      webNotifier.setWebUrl(value);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                //Button to connect
                ElevatedButton(
                  onPressed: (webNotifier.isUploadLoading)
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          //show indicator
                          webNotifier.setUploadLoading(true);
                          //try catch if web not valid
                          try {
                            await unitNotifier.uploadWeb(
                                webNotifier.webUrl, webNotifier.nameUnit);
                            await knowledgeNotifier.getKnowledgeList();
                            await unitNotifier.getUnitList();
                            findAndUpdateCurrentKnowledge();
                            //hide indicator
                            webNotifier.setUploadLoading(false);
                            Navigator.pop(context);
                          } catch (e) {
                            //hide indicator
                            webNotifier.setUploadLoading(false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                              ),
                            );
                            //hide indicator
                            webNotifier.setUploadLoading(false);
                            return;
                          }
                        },
                  child: (webNotifier.isUploadLoading)
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