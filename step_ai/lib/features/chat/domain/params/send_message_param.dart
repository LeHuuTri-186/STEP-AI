import 'dart:io';

import 'package:dio/dio.dart';
import 'package:step_ai/features/chat/domain/entity/message.dart';

class SendMessageParam {
  final List<Message> historyMessages;
  List<File>? files;
  String? conversationId;
  SendMessageParam({
    required this.historyMessages,
    this.conversationId,
    this.files
  });
}