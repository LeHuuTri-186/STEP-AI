import 'dart:convert';

import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/features/chat/domain/entity/assistant.dart';
import 'package:step_ai/features/publish/domain/entity/published.dart';
import 'package:step_ai/features/publish/domain/params/disconnector_param.dart';
import 'package:step_ai/features/publish/domain/params/messenger_publish_param.dart';
import 'package:step_ai/features/publish/domain/params/messenger_validate_param.dart';
import 'package:step_ai/features/publish/domain/params/slack_publish_param.dart';
import 'package:step_ai/features/publish/domain/params/slack_validate_param.dart';
import 'package:step_ai/features/publish/domain/params/telegram_param.dart';
import 'package:step_ai/features/publish/domain/params/telegram_publish_param.dart';
import 'package:step_ai/features/publish/domain/repository/publisher_repository.dart';

class PublisherRepositoryImpl extends PublisherRepository {
  final ApiService _rest = ApiService(Constant.kbApiUrl);
  final SecureStorageHelper _storage;

  PublisherRepositoryImpl(this._storage);
  @override
  Future<List<Published>> getPublished(Assistant params) async{
    String? kbAccessToken = await _storage.kbAccessToken;
    // TODO: implement call
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken'
    };

    var request = await _rest.get(
        Constant.getPublishedEndpoint(params.id!),
        headers: headers
    );

    if (request.statusCode == 200) {
      String stream = await request.stream.bytesToString();
      print("Published: $stream");
      ResponseData res = ResponseData.fromJson(jsonDecode(stream));
      return res.items;
    }
    else {
      throw request.statusCode;
    }
  }

  @override
  Future<String> publishToMessenger(MessengerPublishParam params) async{
    // TODO: implement call
    String? kbAccessToken = await _storage.kbAccessToken;
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken',
      'Content-Type': 'application/json'
    };
    var body = {
      "botToken": params.botToken,
      "pageId": params.pageId,
      "appSecret": params.appSecret
    };

    var request = await _rest.post(
        Constant.messengerPublishEndpoint(params.assistant.id!),
        headers: headers,
        body: body
    );
    String stream = await request.stream.bytesToString();

    if (request.statusCode == 200) {
      // ResponseData res = ResponseData.fromJson(jsonDecode(stream));
      return jsonDecode(stream)['redirect'];
    }
    else {
      throw request.statusCode;
    }
  }

  @override
  Future<String> publishToSlack(SlackPublishParam params) async{
    // TODO: implement call
    String? kbAccessToken = await _storage.kbAccessToken;
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken',
      'Content-Type': 'application/json'
    };
    var body = {
      "botToken": params.botToken,
      "clientId": params.clientId,
      "clientSecret": params.clientSecret,
      "signingSecret": params.signingSecret
    };

    var request = await _rest.post(
        Constant.slackPublishEndpoint(params.assistant.id!),
        headers: headers,
        body: body
    );
    String stream = await request.stream.bytesToString();
    if (request.statusCode == 200) {
      return jsonDecode(stream)['redirect'];
    }
    else {
      throw request.statusCode;
    }
  }

  @override
  Future<String> publishToTelegram(TelegramPublishParam params)async {
    // TODO: implement call
    String? kbAccessToken = await _storage.kbAccessToken;
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken',
      'Content-Type': 'application/json'
    };
    var body = {
      "botToken": params.botToken
    };

    var request = await _rest.post(
        Constant.telegramPublishEndpoint(params.assistant.id!),
        headers: headers,
        body: body
    );
    String stream = await request.stream.bytesToString();

    if (request.statusCode == 200) {
      return jsonDecode(stream)['redirect'];
    }
    else {
      throw request.statusCode;
    }
  }

  @override
  Future<void> validateMessenger(MessengerValidateParam params) async{
    String? kbAccessToken = await _storage.kbAccessToken;
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken',
      'Content-Type': 'application/json'
    };
    var body = {
      "botToken": params.botToken,
      "pageId": params.pageId,
      "appSecret": params.appSecret
    };

    var request = await _rest.post(
        Constant.messengerValidateEndpoint,
        headers: headers,
        body: body
    );
    String stream = await request.stream.bytesToString();
    print("Messenger validate: $stream");
    if (request.statusCode == 200) {
      return;
    }
    else {
      throw request.statusCode;
    }
  }

  @override
  Future<void> validateSlack(SlackValidateParam params) async{
    // TODO: implement call
    String? kbAccessToken = await _storage.kbAccessToken;
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken',
      'Content-Type': 'application/json'
    };
    var body = {
      "botToken": params.botToken,
      "clientId": params.clientId,
      "clientSecret": params.clientSecret,
      "signingSecret": params.signingSecret
    };

    var request = await _rest.post(
        Constant.slackValidateEndpoint,
        headers: headers,
        body: body
    );
    String stream = await request.stream.bytesToString();

    if (request.statusCode == 200) {
      return;
    }
    else {
      throw request.statusCode;
    }
  }

  @override
  Future<void> validateTelegram(TelegramParam params) async{
    // TODO: implement call
    String? kbAccessToken = await _storage.kbAccessToken;
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken',
      'Content-Type': 'application/json'
    };
    var body = {
      "botToken": params.botToken
    };

    var request = await _rest.post(
        Constant.telegramValidateEndpoint,
        headers: headers,
        body: body
    );
    String stream = await request.stream.bytesToString();

    if (request.statusCode == 200) {
      return;
    }
    else {
      throw request.statusCode;
    }
  }

  @override
  Future<void> disconnectBot(DisconnectorParam params) async{
    String? kbAccessToken = await _storage.kbAccessToken;
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken',
    };

    var request = await _rest.delete(
      Constant.disconnectBotEndpoint(params.assistant.id!, params.type),
      headers: headers,
    );
    String stream = await request.stream.bytesToString();
    print("${request.statusCode} - Disconnect: $stream");
    if (request.statusCode == 200) {
      return;
    }
    else {
      throw request.statusCode;
    }

  }

}