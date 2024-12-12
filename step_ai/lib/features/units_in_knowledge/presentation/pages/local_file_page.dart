import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/constants.dart';
import 'package:step_ai/features/knowledge_base/notifier/knowledge_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/local_file_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/unit_notifier.dart';

class LocalFilePage extends StatelessWidget {
  LocalFilePage({super.key});
  late LocalFileNotifier localFileNotifier;
  late KnowledgeNotifier knowledgeNotifier;
  late UnitNotifier unitNotifier;
  FilePickerResult? result;
  File? file;
  void findAndUpdateCurrentKnowledge() {
    //to update size and numbers units when add unit
    knowledgeNotifier.knowledgeList!.knowledgeList.forEach((knowledge) {
      if (knowledge.id == unitNotifier.currentKnowledge!.id) {
        unitNotifier.updateCurrentKnowledge(knowledge);
        return;
      }
    });
  }

  Future<void> selectFile() async {
    // Pick a file using file_picker
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: localFileNotifier.acceptTypeFile,
      // withData: true,
    );

    if (result != null) {
      localFileNotifier.changeFileName(result!.files.single.name);
      file = File(result!.files.single.path!);
    }
  }

  @override
  Widget build(BuildContext context) {
    localFileNotifier = Provider.of<LocalFileNotifier>(context, listen: true);
    knowledgeNotifier = Provider.of<KnowledgeNotifier>(context, listen: false);
    unitNotifier = Provider.of<UnitNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Files'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: localFileNotifier.isUploadLoading
              ? null
              : () {
                  Navigator.pop(context);
                },
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          height: MediaQuery.of(context).size.height * 0.5,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Constant.localFileImagePath,
                      width: 50, height: 50),
                  const SizedBox(width: 10),
                  const Text('Local Files'),
                ],
              ),
              const SizedBox(height: 4),
              const Divider(),
              const SizedBox(height: 10),
              //Container to upload files (select file)
              GestureDetector(
                onTap: () async {
                  await selectFile();
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      style: BorderStyle.solid,
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        size: 50,
                        color: Colors.blue,
                      ),
                      SizedBox(height: 10),
                      Text("Click here to upload files",
                          style: TextStyle(color: Colors.blue)),
                      SizedBox(height: 4),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Support for a single or bulk. Strictly prohibit from uploading company data or other band files",
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Row file after upload
              const SizedBox(height: 10),
              localFileNotifier.fileName == ''
                  ? const SizedBox.shrink()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.attach_file, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(localFileNotifier.fileName,
                            style: const TextStyle(color: Colors.blue)),
                      ],
                    ),
              const SizedBox(height: 10),
              //Button to connect
              ElevatedButton(
                onPressed: (localFileNotifier.isUploadLoading)
                    ? null
                    : () async {
                        if (file == null) {
                          return;
                        }
                        //show indicator
                        localFileNotifier.changeUploadLoading(true);

                        // Upload file
                        String extension =
                            file!.path.split('.').last.toLowerCase();
                        await unitNotifier.uploadLocalFile(
                            file!,
                            MediaType.parse(
                                localFileNotifier.getMimeType(extension)));
                        await knowledgeNotifier.getKnowledgeList();
                        await unitNotifier.getUnitList();
                        findAndUpdateCurrentKnowledge();
                        // Clear temporary files
                        await FilePicker.platform.clearTemporaryFiles();
                        localFileNotifier.changeFileName("");

                        //hide indicator
                        localFileNotifier.changeUploadLoading(false);
                        Navigator.pop(context);
                      },
                child: (localFileNotifier.isUploadLoading)
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
