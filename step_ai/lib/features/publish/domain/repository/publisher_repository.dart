import 'package:step_ai/features/chat/domain/entity/assistant.dart';
import 'package:step_ai/features/publish/domain/entity/published.dart';
import 'package:step_ai/features/publish/domain/params/disconnector_param.dart';
import 'package:step_ai/features/publish/domain/params/messenger_publish_param.dart';
import 'package:step_ai/features/publish/domain/params/messenger_validate_param.dart';
import 'package:step_ai/features/publish/domain/params/slack_publish_param.dart';
import 'package:step_ai/features/publish/domain/params/slack_validate_param.dart';
import 'package:step_ai/features/publish/domain/params/telegram_param.dart';
import 'package:step_ai/features/publish/domain/params/telegram_publish_param.dart';

abstract class PublisherRepository {
  Future<List<Published>> getPublished(Assistant params);
  Future<String> publishToMessenger(MessengerPublishParam params);
  Future<void> validateMessenger(MessengerValidateParam params);

  Future<String> publishToTelegram(TelegramPublishParam params);
  Future<void> validateTelegram(TelegramParam params);

  Future<String> publishToSlack(SlackPublishParam params);
  Future<void> validateSlack(SlackValidateParam params);

  Future<void> disconnectBot(DisconnectorParam params);
}