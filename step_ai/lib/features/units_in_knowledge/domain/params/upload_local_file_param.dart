import 'dart:io';

import 'package:http_parser/http_parser.dart';

class UploadLocalFileParam {
  String knowledgeId;
  final File file;
  MediaType mediaType;
  UploadLocalFileParam({required this.knowledgeId,required this.file, required this.mediaType});
}
