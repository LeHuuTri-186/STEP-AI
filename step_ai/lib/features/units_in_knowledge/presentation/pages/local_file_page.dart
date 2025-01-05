import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/constants.dart';
import 'package:step_ai/features/knowledge_base/notifier/knowledge_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/local_file_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/unit_notifier.dart';
import 'package:step_ai/shared/styles/vertical_spacing.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/styles/colors.dart';

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
                  localFileNotifier.changeFileName("");
                  Navigator.pop(context);
                },
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          //Main Column
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              VSpacing.md,
              //Title of the page + Image
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(children: [
                    Image.asset(Constant.localFileImagePath,
                        width: 50, height: 50),
                    const SizedBox(width: 10),
                    Text('Local Files', style: Theme.of(context).textTheme.titleLarge,),
                  ]),
                  IconButton(
                      onPressed: () async {
                        final Uri url = Uri.parse(
                            'https://jarvis.cx/help/knowledge-base/connectors/file/');
                        try {
                          if (!await canLaunchUrl(url)) {
                            throw 'URL không hợp lệ hoặc không thể mở: $url';
                          }

                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        } catch (e) {
                          // Xử lý lỗi, có thể hiển thị thông báo cho người dùng
                          //print('Lỗi khi mở URL: $e');
                        }
                      },
                      icon: const Icon(
                        Icons.link,
                        color: Colors.blue,
                      ))
                ],
              ),
              const SizedBox(height: 4),
              const SizedBox(height: 10),
              //Container to upload files (select file)
              GestureDetector(
                onTap: () async {
                  await selectFile();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      style: BorderStyle.solid,
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload,
                          size: 50,
                          color: TColor.tamarama,
                        ),
                        const SizedBox(height: 10),
                        Text("Click here to upload files",
                            style: Theme.of(context).textTheme.bodyMedium,),
                        const SizedBox(height: 4),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Support for single or bulk. Strictly prohibit from uploading company data or other banned files",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: TColor.petRock,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
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
                        Icon(Icons.attach_file, color: TColor.tamarama),
                        const SizedBox(width: 4),
                        Text(localFileNotifier.fileName, style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: TColor.tamarama,
                        ),),
                      ],
                    ),
              const SizedBox(height: 10),
              //Button to connect
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.tamarama,
                    disabledBackgroundColor: TColor.petRock,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: (localFileNotifier.isUploadLoading || file == null)
                      ? null
                      : () async {
                          if (file == null) {
                            return;
                          }
                          //show indicator
                          localFileNotifier.changeUploadLoading(true);
                          try {
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
                            localFileNotifier.changeFileName("");
                            Navigator.pop(context);
                          } catch (e) {
                            //hide indicator
                            localFileNotifier.changeUploadLoading(false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.toString(),
                                ),
                              ),
                            );
                          }
                        },
                  child: (localFileNotifier.isUploadLoading)
                      ? Stack(alignment: Alignment.center, children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Uploading..."),
                        ],
                      ),
                    ),
                    Positioned(
                        child: LoadingAnimationWidget.discreteCircle(
                            color: TColor.doctorWhite, size: 14)
                    ),
                  ])
                      : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Connect',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
