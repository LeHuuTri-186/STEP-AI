import 'package:step_ai/features/preview/domain/entity/kb_in_bot.dart';
import 'package:step_ai/features/preview/domain/entity/preview_message.dart';
import 'package:step_ai/features/preview/domain/params/import_kb_param.dart';
import 'package:step_ai/features/preview/domain/params/remove_kb_param.dart';

abstract class KbInBotRepository {

  Future<KbListInBot> getKbInBot(String botId);
  Future<int> importKbInBot(ImportKbParam params);
  Future<int> removeKbInBot(RemoveKbParam params);
  Future<List<PreviewMessage>> retrieveHistory(String threadId);
}